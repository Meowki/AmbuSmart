from pydantic import BaseModel
from datetime import datetime

class ChatRequest(BaseModel):
    operation_id: int  # 绑定急救操作ID
    message: str
    prompt_type: str = "standard"

class ChatResponse(BaseModel):
    operation_id: int
    response: str

class ChatHistoryResponse(BaseModel):
    id: int
    operation_id: int
    user_message: str
    ai_response: str
    created_at: datetime

    class Config:
        orm_mode = True
