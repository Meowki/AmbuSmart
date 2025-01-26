from pydantic import BaseModel
from typing import Optional, List
from .health_personnel import HealthPersonnel

class DepartmentBase(BaseModel):
    dno: str
    dname: Optional[str] = None
    type: Optional[str] = None

class DepartmentCreate(DepartmentBase):
    pass

class Department(DepartmentBase):
    health_personnel: List[HealthPersonnel] = [] 

    class Config:
        orm_mode = True
