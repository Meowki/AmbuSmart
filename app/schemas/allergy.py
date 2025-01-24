from pydantic import BaseModel
from typing import Optional

class AllergyBase(BaseModel):
    allergy_name: str
    severity: str
    remark: Optional[str] = None

class AllergyCreate(AllergyBase):
    pass

class Allergy(AllergyBase):
    id: int
    patient_id: str

    class Config:
        orm_mode = True
