# services/patient_service.py
from sqlalchemy.orm import Session
from schemas.patient import PatientCreate
from crud.crud_patient import crud_patient

class PatientService:
    def get_patient(self, db: Session, patient_id: str):
        return crud_patient.get(db, patient_id)

    def get_patients(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_patient.get_all(db, skip, limit)

    def create_patient(self, db: Session, patient: PatientCreate):
        return crud_patient.create(db, patient)

    # 其他服务方法

patient_service = PatientService()