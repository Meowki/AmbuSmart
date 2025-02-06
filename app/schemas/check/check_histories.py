from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class CheckHistoryBase(BaseModel):
    patient_id: str
    wid: Optional[str] = None
    timestamp: Optional[datetime] = None
    remark: Optional[str] = None
    result: Optional[bytes] = None
    description: Optional[bytes] = None
    cid: Optional[str] = None

class CheckHistoryCreate(CheckHistoryBase):
    pass

class CheckHistory(CheckHistoryBase):
    check_id: int

    class Config:
        orm_mode = True