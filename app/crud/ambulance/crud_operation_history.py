from sqlalchemy.orm import Session
from models.operation_history import OperationHistory
# from schemas.check.check_histories import CheckHistoryCreate

class CRUDOperationHistory:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(OperationHistory).offset(skip).limit(limit).all()

    # def create(self, db: Session, check: CheckHistoryCreate):
    #     db_check = CheckHistory(**check.dict())
    #     db.add(db_check)
    #     db.commit()
    #     db.refresh(db_check)
    #     return db_check
    
    def get_by_patient_id(self, db: Session, patient_id: str):
        return db.query(OperationHistory).filter(OperationHistory.patient_id == patient_id).all()
    

crud_operation_history = CRUDOperationHistory()