from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class BasicCheckBase(BaseModel):
    timestamp: Optional[datetime] = None
    reject: Optional[int] = None
    consciousness: Optional[str] = None
    pupil: Optional[str] = None
    pupillary_light_reflex: Optional[str] = None
    blood_pressure: Optional[str] = None
    pulse: Optional[str] = None
    respiration: Optional[str] = None
    oxygen_saturation: Optional[str] = None

class BasicCheckCreate(BasicCheckBase):
    # eid: int
    timestamp: Optional[datetime] = None

class BasicCheck(BasicCheckBase):
    eid: int

    class Config:
        orm_mode = True
