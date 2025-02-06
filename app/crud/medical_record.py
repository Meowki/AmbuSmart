from sqlalchemy.orm import Session
from models.medical_record import MedicalRecord
from schemas.medical_record import MedicalRecordCreate

class CRUDMedicalRecord:
    def get(self, db: Session, record_id: str):
        return db.query(MedicalRecord).filter(MedicalRecord.record_id == record_id).first()

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(MedicalRecord).offset(skip).limit(limit).all()

    def create(self, db: Session, medical_record: MedicalRecordCreate):
        db_medical_record = MedicalRecord(**medical_record.dict())
        db.add(db_medical_record)
        db.commit()
        db.refresh(db_medical_record)
        return db_medical_record
    
    def get_by_patient(self, db: Session, patient_id: str):
        return db.query(MedicalRecord).filter(MedicalRecord.patient_id == patient_id)

    # 其他CRUD方法

crud_medical_record = CRUDMedicalRecord()