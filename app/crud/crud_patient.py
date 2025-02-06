# crud/crud_patient.py
from sqlalchemy.orm import Session
from models.patient import Patient
from schemas.patient import PatientCreate

class CRUDPatient:
    def get(self, db: Session, patient_id: str):
        return db.query(Patient).filter(Patient.patient_id == patient_id).all()

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(Patient).offset(skip).limit(limit).all()

    def create(self, db: Session, patient: PatientCreate):
        db_patient = Patient(**patient.dict())
        db.add(db_patient)
        db.commit()
        db.refresh(db_patient)
        return db_patient

    # 其他CRUD方法

crud_patient = CRUDPatient()