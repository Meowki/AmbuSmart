from pydantic import BaseModel
from typing import Optional
from datetime import datetime

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

class MedicalRecord(MedicalRecordBase):
    record_id: int

    class Config:
        orm_mode = True