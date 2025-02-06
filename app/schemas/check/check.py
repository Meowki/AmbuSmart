from pydantic import BaseModel
from typing import Optional

class CheckBase(BaseModel):
    name: Optional[str] = None
    place: Optional[str] = None
    price: Optional[float] = None
    device: Optional[str] = None
    num: Optional[int] = 0
    cid: str

class CheckCreate(CheckBase):
    pass

class Check(CheckBase):
    
    class Config:
        orm_mode = True