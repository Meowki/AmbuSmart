from pydantic import BaseModel
from typing import Optional

class OperationHistoryBase(BaseModel):
    patient_id: Optional[str] = None


class OperationHistory(OperationHistoryBase):
    operation_id: int

    class Config:
        orm_mode = True
