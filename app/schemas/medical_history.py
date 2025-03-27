from pydantic import BaseModel
from datetime import date
from typing import Optional

class MedicalHistoryBase(BaseModel):
    condition_name: Optional[str] = None
    diagnosis_date: Optional[date] = None
    remark: Optional[str] = None

class MedicalHistoryCreate(MedicalHistoryBase):
    pass

class MedicalHistory(MedicalHistoryBase):
    id: int
    patient_id: str

    class Config:
        from_attributes = True 