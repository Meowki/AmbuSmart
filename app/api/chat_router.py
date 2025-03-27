from fastapi import APIRouter, Depends, HTTPException, Request, logger
from sqlalchemy.orm import Session
from typing import Dict, AsyncGenerator, List
import asyncio
from fastapi.responses import StreamingResponse
from contextlib import asynccontextmanager
from services.chat_service import chat_with_ai
from crud.chat import get_chat_history
from db.session import SessionLocal
from models.operation_history import OperationHistory
from schemas.chat import ChatHistoryResponse, ChatRequest
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

chat_router = APIRouter(
    prefix="/chat",
    tags=["Chat AI"]
)
active_generators: Dict[str, asyncio.Queue] = {}

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@asynccontextmanager
async def create_abort_channel(operation_id: str):
    queue = asyncio.Queue()
    active_generators[operation_id] = queue
    try:
        yield queue
    finally:
        active_generators.pop(operation_id, None)
        await queue.put(StopAsyncIteration)

@chat_router.post("/abort/{operation_id}")
async def abort_chat(operation_id: str):
    if operation_id in active_generators:
        queue = active_generators[operation_id]
        try:
            await queue.put("ABORT")
            logger.info(f"🚨 已发送终止信号到操作 {operation_id}")
            return {"status": "aborted", "operation_id": operation_id}
        except Exception as e:
            logger.error(f"终止操作失败: {str(e)}")
            raise HTTPException(500, detail="终止请求失败")
    return {"status": "not_found", "operation_id": operation_id}

@chat_router.post("/")
async def chat_endpoint(request: Request, chat_request: ChatRequest, db: Session = Depends(get_db)):
    operation_id = chat_request.operation_id
    logger.info(f"🎬 收到新的聊天请求: operation_id={operation_id}, prompt={chat_request.prompt_type}")
    async def response_generator():
        async with create_abort_channel(operation_id) as abort_queue:
            try:
                async for chunk in chat_with_ai(
                    db=db,
                    request=request,
                    operation_id=operation_id,
                    message=chat_request.message,
                    prompt_type=chat_request.prompt_type,
                    abort_queue=abort_queue
                ):
                    yield chunk
            except asyncio.CancelledError:
                logger.warning(f"🎬 操作 {operation_id} 被取消")
                yield "event: error\ndata: 请求已取消\n\n"
            except Exception as e:
                logger.error(f"生成器异常: {str(e)}")
                yield f"event: error\ndata: {str(e)}\n\n"

    return StreamingResponse(
        response_generator(),
        media_type="text/event-stream",
        headers={"X-Accel-Buffering": "no"}
    )

@chat_router.get("/history/{operation_id}", response_model=List[ChatHistoryResponse])
def get_history(operation_id: int, db: Session = Depends(get_db)):
    history = get_chat_history(db, operation_id)
    return history

@chat_router.get("/auto/{operation_id}")
async def auto_patient_basic_analysis(request: Request, operation_id: int, db: Session = Depends(get_db)):
    operation = db.query(OperationHistory).filter(OperationHistory.operation_id == operation_id).first()
    if not operation:
        raise HTTPException(status_code=404, detail="找不到对应的急救记录")

    if not operation.patient_id:
        raise HTTPException(status_code=400, detail="未录入患者信息，无法生成基础分析")

    async def response_generator():
        async with create_abort_channel(operation_id) as abort_queue:
            try:
                async for chunk in chat_with_ai(
                    db=db,
                    request=request,
                    operation_id=operation_id,
                    message="自动分析患者基础信息",
                    prompt_type="patient_basic_analysis",
                    abort_queue=abort_queue
                ):
                    yield chunk
            except asyncio.CancelledError:
                logger.warning(f"🎬 操作 {operation_id} 被取消")
                yield "event: error\ndata: 请求已取消\n\n"
            except Exception as e:
                logger.error(f"生成器异常: {str(e)}")
                yield f"event: error\ndata: {str(e)}\n\n"

    return StreamingResponse(
        response_generator(),
        media_type="text/event-stream",
        headers={"X-Accel-Buffering": "no"}
    )
