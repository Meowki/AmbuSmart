from pydantic import BaseModel
from typing import Optional

class AllergyBase(BaseModel):
    allergy_name: Optional[str] = None
    severity: Optional[str] = None
    remark: Optional[str] = None

class AllergyCreate(AllergyBase):
    pass

class Allergy(AllergyBase):
    id: int
    patient_id: str

    class Config:
        orm_mode = True
