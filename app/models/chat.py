from sqlalchemy import Column, Integer, Text, DateTime, ForeignKey, func
from sqlalchemy.orm import relationship
from db.base import Base

class ChatHistory(Base):
    __tablename__ = "chat_history"

    id = Column(Integer, primary_key=True, autoincrement=True)
    operation_id = Column(Integer, ForeignKey("operation_histories.operation_id", ondelete="CASCADE", onupdate="CASCADE"), nullable=False, index=True, comment="关联急救操作")
    user_message = Column(Text, nullable=False)
    ai_response = Column(Text, nullable=False)
    created_at = Column(DateTime, default=func.now())

    operation = relationship("OperationHistory", back_populates="chat_histories")
