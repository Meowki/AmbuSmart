from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class AmbulanceBase(BaseModel):
    car_num: Optional[str] = None
    dispatch_time: Optional[datetime] = None
    arrival_on_scene_time: Optional[datetime] = None
    departure_from_scene_time: Optional[datetime] = None
    arrival_at_hospital_time: Optional[datetime] = None
    operation_id: Optional[int] = None

class AmbulanceCreate(AmbulanceBase):
    pass

class Ambulance(AmbulanceBase):
    aid: int

    class Config:
        orm_mode = True
