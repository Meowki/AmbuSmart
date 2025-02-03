from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class CaseHistoryBase(BaseModel):
    patient_id: str
    wid: Optional[str] = None
    dno: Optional[str] = None
    hospital: Optional[str] = None
    in_timestamp: Optional[datetime] = None
    out_timestamp: Optional[datetime] = None
    in_assessment: Optional[str] = None
    remark: Optional[str] = None
    out_result: Optional[str] = None

class CaseHistoryCreate(CaseHistoryBase):
    pass

class CaseHistory(CaseHistoryBase):
    case_id: int

    class Config:
        from_attributes = True