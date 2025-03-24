from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.chat import ChatRequest, ChatResponse, ChatHistoryResponse
from services.chat_service import chat_with_ai
from crud.chat import get_chat_history
from db.session import SessionLocal
from typing import List
from fastapi.responses import StreamingResponse

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
            # chat_with_ai(db, request.operation_id, request.message),
            media_type="text/event-stream",  # 或 "application/x-ndjson"
            headers={"X-Accel-Buffering": "no"}
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))




@chat_router.get("/history/{operation_id}", response_model=List[ChatHistoryResponse])
def get_history(operation_id: int, db: Session = Depends(get_db)):
    history = get_chat_history(db, operation_id)
    return history
