# services/medical_record_service.py
from sqlalchemy.orm import Session
from schemas.medical_record import MedicalRecordCreate
from crud.medical_record import crud_medical_record

class MedicalRecordService:
    def get_medical_record_by_patient(self, db: Session, patient_id: str):
        return crud_medical_record.get_by_patient(db, patient_id)

    def add_medical_record(self, db: Session, medical_record: MedicalRecordCreate, patient_id: str):
        return crud_medical_record.create(db, medical_record, patient_id)

    # 其他服务方法

medical_record_service = MedicalRecordService()