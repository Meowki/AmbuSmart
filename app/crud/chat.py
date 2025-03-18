from sqlalchemy.orm import Session
from models.chat import ChatHistory
from models.operation_history import OperationHistory

def create_chat_record(db: Session, operation_id: int, user_message: str, ai_response: str):
    # 确保 operation_id 存在
    operation = db.query(OperationHistory).filter_by(operation_id=operation_id).first()
    if not operation:
        raise ValueError("Operation ID 不存在")

    chat_record = ChatHistory(
        operation_id=operation_id,
        user_message=user_message,
        ai_response=ai_response
    )
    db.add(chat_record)
    db.commit()
    db.refresh(chat_record)
    return chat_record

def get_chat_history(db: Session, operation_id: int):
    return db.query(ChatHistory).filter_by(operation_id=operation_id).order_by(ChatHistory.created_at).all()
