from sqlalchemy.orm import Session
from models.check.check_histories import CheckHistory
from schemas.check.check_histories import CheckHistoryCreate

class CRUDCheckHistory:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(CheckHistory).offset(skip).limit(limit).all()

    def create(self, db: Session, check: CheckHistoryCreate):
        db_check = CheckHistory(**check.dict())
        db.add(db_check)
        db.commit()
        db.refresh(db_check)
        return db_check
    
    def get_by_patient_id(self, db: Session, patient_id: str):
        return db.query(CheckHistory).filter(CheckHistory.patient_id == patient_id).all()
    

crud_check_histories = CRUDCheckHistory()