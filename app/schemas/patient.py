from pydantic import BaseModel
from typing import List, Optional
from .allergy import Allergy
from .medical_history import MedicalHistory
from .medical_record import MedicalRecord
from .case_history import CaseHistory
from datetime import datetime

# def calculate_age(id_card: str) -> int:
#     """根据身份证号计算年龄"""
#     birth_date = patient_id[6:14]  # 获取身份证号中的出生日期（假设为YYYYMMDD）
#     birth_date = datetime.strptime(birth_date, "%Y%m%d")
#     today = datetime.today()
#     age = today.year - birth_date.year
#     if today.month < birth_date.month or (today.month == birth_date.month and today.day < birth_date.day):
#         age -= 1
#     return age

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
    # age: int

    class Config:
        orm_mode = True  # 让 Pydantic 支持 ORM 模型
    
    # @classmethod
    # def from_orm(cls, db_obj):
    #     patient = super().from_orm(db_obj)
    #     patient.age = calculate_age(patient.patient_id)  # 计算年龄
    #     return patient


