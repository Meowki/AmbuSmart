from fastapi import APIRouter, Depends, HTTPException, Request, logger, status 
from grpc import Status
from sqlalchemy.orm import Session
from typing import Dict, AsyncGenerator, List, Optional
import asyncio
from fastapi.responses import StreamingResponse
from contextlib import asynccontextmanager
from services.chat_service import chat_with_ai
from crud.chat import get_chat_history
from db.session import SessionLocal
from models.operation_history import OperationHistory
from schemas.chat import ChatHistoryResponse, ChatRequest
import logging
# import threading
# active_lock = threading.Lock()  # 添加在路由文件顶部
# 将线程锁改为异步锁
import asyncio
from contextlib import asynccontextmanager

# 初始化异步锁
active_lock = asyncio.Lock()

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

chat_router = APIRouter(
    prefix="/chat",
    tags=["Chat AI"]
)
active_generators: Dict[int, asyncio.Queue] = {}

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@asynccontextmanager
async def create_abort_channel(operation_id: int):
    queue = asyncio.Queue(maxsize=1)
    
    # 使用异步锁的正确方式
    async with active_lock:
        # 清理旧请求
        if operation_id in active_generators:
            old_queue = active_generators[operation_id]
            try:
                await old_queue.put("ABORT")
                logger.info(f"♻️ 终止旧请求: {operation_id}")
            except Exception as e:
                logger.error(f"旧请求终止失败: {str(e)}")
        
        # 注册新队列
        active_generators[operation_id] = queue
        logger.info(f"📝 注册新队列: {operation_id}")

    try:
        yield queue
    finally:
        async with active_lock:
            if operation_id in active_generators and active_generators[operation_id] is queue:
                del active_generators[operation_id]
                logger.info(f"🧹 清理队列: {operation_id}")

# 修改后的终止端点
@chat_router.post("/abort/{operation_id}",  status_code=status.HTTP_202_ACCEPTED)
async def abort_chat(operation_id: int):
    logger.info(f"🔴 收到终止请求: {operation_id}")
    logger.info(f"当前活跃队列: {list(active_generators.keys())}")
    async with active_lock:  # 正确使用异步锁
        logger.info(f"当前活跃队列: {list(active_generators.keys())}")
        if operation_id not in active_generators:
            logger.warning(f"❌ 操作不存在: {operation_id}")
            return {"status": "not_found"}
        
        queue = active_generators[operation_id]

    try:
        await queue.put("ABORT")
        logger.info(f"✅ 终止信号已发送: {operation_id}")
        return {"status": "aborted"}
    except Exception as e:
        logger.error(f"终止异常: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@chat_router.post("/")
async def chat_endpoint(request: Request, chat_request: ChatRequest, db: Session = Depends(get_db)):
    operation_id = chat_request.operation_id
    logger.info(f"🎬 收到新的聊天请求: operation_id={operation_id}, prompt={chat_request.prompt_type}")
    prompt_type=chat_request.prompt_type,
    async def response_generator():
        async with create_abort_channel(f"{operation_id}_{prompt_type}") as abort_queue:  # 使用异步上下文管理器,并且可以多功能同步运行
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

# 拆分api，以实现同步运行多个ai request
# 1. form section 获得主诉~最终结果
@chat_router.post("/optimize_full_entry")
async def chat_optimize_full_entry(request: Request, chat_request: ChatRequest, db: Session = Depends(get_db)):
    operation_id = chat_request.operation_id
    logger.info(f"🎬 收到新的聊天请求: operation_id={operation_id}, prompt={chat_request.prompt_type}")
    prompt_type=chat_request.prompt_type,
    async def response_generator():
        async with create_abort_channel(f"{operation_id}_{prompt_type}") as abort_queue:
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
# 2. smart advice 根据最后结果，给出建议
@chat_router.post("/patient_attention_suggestion")
async def chat_patient_attention_suggestion(request: Request, chat_request: ChatRequest, db: Session = Depends(get_db)):
    operation_id = chat_request.operation_id
    logger.info(f"🎬 收到新的聊天请求: operation_id={operation_id}, prompt={chat_request.prompt_type}")
    prompt_type=chat_request.prompt_type,
    async def response_generator():
        async with create_abort_channel(f"{operation_id}_{prompt_type}") as abort_queue:
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

# 3. 词云
@chat_router.post("/chat_keyword_extraction")
async def chat_chat_keyword_extraction(request: Request, chat_request: ChatRequest, db: Session = Depends(get_db)):
    operation_id = chat_request.operation_id
    logger.info(f"🎬 收到新的聊天请求: operation_id={operation_id}, prompt={chat_request.prompt_type}")
    prompt_type=chat_request.prompt_type,
    async def response_generator():
        async with create_abort_channel(f"{operation_id}_{prompt_type}") as abort_queue:
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
# 4. 矛盾项分析