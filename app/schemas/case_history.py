from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

from schemas.check.check_histories import CheckHistory
from schemas.medicine.medicine_histories import MedicineHistory

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


# 这个用于病人ID查询时返回的 CaseHistory 包括检查记录和用药记录
class CaseHistoryWithChecksResponse(CaseHistoryBase):
    case_id: int
    check_histories: Optional[List[CheckHistory]] = []
    medicine_histories: Optional[List[MedicineHistory]] = []

    class Config:
        orm_mode = True