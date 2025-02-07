from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from schemas.check.check_histories import CheckHistory
from schemas.medicine.medicine_histories import MedicineHistory

class MedicalRecordBase(BaseModel):
    patient_id: str
    wid: Optional[str] = None
    dno: Optional[str] = None
    hospital: Optional[str] = None
    type: Optional[str] = None
    companion: Optional[str] = None
    chief_complaint: Optional[str] = None
    present_illness: Optional[str] = None
    timestamp: Optional[datetime] = None
    temperature: Optional[str] = None
    pulse: Optional[str] = None
    sbp: Optional[str] = None
    dbp: Optional[str] = None
    pulmonary: Optional[str] = None
    consciousness: Optional[str] = None
    measures: Optional[str] = None
    observation: Optional[str] = None
    assessment: Optional[str] = None
    remark: Optional[str] = None

class MedicalRecordCreate(MedicalRecordBase):
    pass

# 这个用于普通的查询，不包含检查记录
class MedicalRecord(MedicalRecordBase):
    record_id: int

    class Config:
        orm_mode = True

# 这个用于病人ID查询时返回的 MedicalRecord 包括检查记录和用药记录
class MedicalRecordWithChecksResponse(MedicalRecordBase):
    record_id: int
    check_histories: Optional[List[CheckHistory]] = []
    medicine_histories: Optional[List[MedicineHistory]] = []

    class Config:
        orm_mode = True
