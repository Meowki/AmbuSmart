from pydantic import BaseModel
from typing import Optional, List
# from .department import Department

class HealthPersonnelBase(BaseModel):
    name: Optional[str] = None
    job: Optional[str] = None
    sex: Optional[str] = None
    id: Optional[str] = None
    age: Optional[int] = None

class HealthPersonnelCreate(HealthPersonnelBase):
    pass

class HealthPersonnelUpdate(HealthPersonnelBase):
    pass

class HealthPersonnel(HealthPersonnelBase):
    wid: str
    dno: Optional[str] = None
    # department: Optional[Department]=[]

    class Config:
        orm_mode = True
