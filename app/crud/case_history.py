from sqlalchemy.orm import Session
from models.case_history import CaseHistory
from schemas.case_history import CaseHistoryCreate

class CRUDCaseHistory:
    def get(self, db: Session, record_id: str):
        return db.query(CaseHistory).filter(CaseHistory.case_id == case_id).first()

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(CaseHistory).offset(skip).limit(limit).all()

    def create(self, db: Session, case_history: CaseHistoryCreate):
        db_case_history = CaseHistory(**case_history.dict())
        db.add(db_case_history)
        db.commit()
        db.refresh(db_case_history)
        return db_case_history
    
    def get_by_patient(self, db: Session, patient_id: str):
        return db.query(CaseHistory).filter(CaseHistory.patient_id == patient_id).all()

crud_case_history = CRUDCaseHistory()