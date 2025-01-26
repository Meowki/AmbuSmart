from sqlalchemy.orm import Session
from models.medical_history import MedicalHistory
from schemas.medical_history import MedicalHistoryCreate

class CRUDMedicalHistory:
    def get_by_patient(self, db: Session, patient_id: str):
        return db.query(MedicalHistory).filter(MedicalHistory.patient_id == patient_id).all()
    
    def create(self, db: Session, medical_history: MedicalHistoryCreate, patient_id: str):
        db_medical_history = MedicalHistory(**medical_history.dict(), patient_id=patient_id)
        db.add(db_medical_history)
        db.commit()
        db.refresh(db_medical_history)
        return db_medical_history
    
    def get(self, db: Session):
        return db.query(MedicalHistory)
    
    # def update(self, db: Session, history_id: int, medical_history: MedicalHistoryUpdate):
    #     db_medical_history = self.get(db, history_id)
    #     if not db_medical_history:
    #         return None
    #     for key, value in medical_history.dict(exclude_unset=True).items():
    #         setattr(db_medical_history, key, value)
    #     db.commit()
    #     db.refresh(db_medical_history)
    #     return db_medical_history
    
    def remove(self, db: Session, id: int):
        db_medical_history = self.get(db, id)
        if not db_medical_history:
            return None
        db.delete(db_medical_history)
        db.commit()
        return db_medical_history

crud_medical_history = CRUDMedicalHistory() 