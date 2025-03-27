from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.chat import ChatRequest, ChatResponse, ChatHistoryResponse
from services.chat_service import chat_with_ai
from crud.chat import get_chat_history
from db.session import SessionLocal
from typing import List
from fastapi.responses import StreamingResponse
from models.operation_history import OperationHistory  

chat_router = APIRouter(
    prefix="/chat",
    tags=["Chat AI"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@chat_router.post("/")
async def chat(request: ChatRequest, db: Session = Depends(get_db)):
    try:
        return StreamingResponse(
            chat_with_ai(db, request.operation_id, request.message, request.prompt_type),
            media_type="text/event-stream",  # 或 "application/x-ndjson"
            headers={"X-Accel-Buffering": "no"},
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))




@chat_router.get("/history/{operation_id}", response_model=List[ChatHistoryResponse])
def get_history(operation_id: int, db: Session = Depends(get_db)):
    history = get_chat_history(db, operation_id)
    return history


# 自动触发患者基础信息分析
@chat_router.get("/auto/{operation_id}")
async def auto_patient_basic_analysis(operation_id: int, db: Session = Depends(get_db)):
    operation = db.query(OperationHistory).filter(OperationHistory.operation_id == operation_id).first()
    if not operation:
        raise HTTPException(status_code=404, detail="找不到对应的急救记录")

    if not operation.patient_id:
        raise HTTPException(status_code=400, detail="未录入患者信息，无法生成基础分析")

    try:
        return StreamingResponse(
            chat_with_ai(
                db=db,
                operation_id=operation_id,
                message="分析患者基础信息",
                prompt_type="patient_basic_analysis"
            ),
            media_type="text/event-stream",
            headers={"X-Accel-Buffering": "no"},
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"生成分析失败: {str(e)}")
