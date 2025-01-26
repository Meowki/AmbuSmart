# services/medical_history_service.py
from sqlalchemy.orm import Session
from schemas.medical_history import MedicalHistoryCreate
from crud.medical_history import crud_medical_history

class MedicalHistoryService:
    def get_medical_histories(self, db: Session, patient_id: str):
        return crud_medical_history.get_by_patient(db, patient_id)

    def add_medical_history(self, db: Session, medical_history: MedicalHistoryCreate, patient_id: str):
        return crud_medical_history.create(db, medical_history, patient_id)

    # 其他服务方法

medical_history_service = MedicalHistoryService()