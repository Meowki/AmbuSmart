# schemas/check_relationship.py

from pydantic import BaseModel
from typing import Optional

class CheckRelationshipBase(BaseModel):
    record_id: Optional[int] = None
    case_id: Optional[int] = None
    operation_id: Optional[int] = None
    check_id: Optional[int] = None

class CheckRelationship(CheckRelationshipBase):
    id: int

    class Config:
        orm_mode = True
