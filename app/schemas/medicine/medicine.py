from pydantic import BaseModel
from typing import Optional

class MedicineBase(BaseModel):
    mname: Optional[str] = None
    type: Optional[str] = None
    factory: Optional[str] = None
    price: Optional[float] = None
    unit: Optional[str] = None
    store: Optional[str] = None
    specs: Optional[str] = None
    sell: Optional[int] = 0
    mid: str

class MedicineCreate(MedicineBase):
    pass

class Medicine(MedicineBase):
   

    class Config:
        orm_mode = True
