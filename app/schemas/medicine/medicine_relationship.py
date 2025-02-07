from pydantic import BaseModel
from typing import Optional

class MedicineRelationshipBase(BaseModel):
    mrid: Optional[int] = None
    record_id: Optional[int] = None
    case_id: Optional[int] = None
    operation_id: Optional[int] = None

class MedicineRelationship(MedicineRelationshipBase):
    id: int

    class Config:
        orm_mode = True
