from pydantic import BaseModel
from typing import List, Optional
from .allergy import Allergy
from .medical_history import MedicalHistory
from .medical_record import MedicalRecord
from .case_history import CaseHistory
from .ambulance.operation_history import OperationHistory

class PatientBase(BaseModel):
    name: str
    sex: Optional[str] = None
    idType: Optional[str] = None
    telno: Optional[str] = None
    address: Optional[str] = None
    ethnicity: Optional[str] = None
    patient_id: Optional[str] = None

class PatientCreate(PatientBase):
    pass

class PatientUpdate(PatientBase):
    pass

class Patient(PatientBase):
    allergies: List[Allergy] = []
    medical_histories: List[MedicalHistory] = []
    medical_record: List[MedicalRecord] = []
    case_histories: List[CaseHistory] = []
    operation_histories: List[OperationHistory] = []
    # age: int

    class Config:
        orm_mode = True  # 让 Pydantic 支持 ORM 模型
    
    # @classmethod
    # def from_orm(cls, db_obj):
    #     patient = super().from_orm(db_obj)
    #     patient.age = calculate_age(patient.patient_id)  # 计算年龄
    #     return patient


