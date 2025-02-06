from pydantic import BaseModel
from typing import Optional
from datetime import date

class MedicineHistoryBase(BaseModel):
    patient_id: Optional[str] = None
    mid: Optional[str] = None
    numb: Optional[int] = None
    orders: Optional[str] = None
    time: Optional[date] = None
    status: Optional[str] = None
    wid: Optional[str] = None

class MedicineHistoryCreate(MedicineHistoryBase):
    pass

class MedicineHistory(MedicineHistoryBase):
    mrid: int

    class Config:
        orm_mode = True
