from sqlalchemy.orm import Session
from models.operation_history import OperationHistory
from schemas.ambulance.operation_history import OperationHistoryCreate

class CRUDOperationHistory:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(OperationHistory).offset(skip).limit(limit).all()

    def create(self, db: Session, operation: OperationHistoryCreate):
        db_operation = OperationHistory(**operation.dict())
        db.add(db_operation)
        db.commit()
        db.refresh(db_operation)
        return db_operation
    
    def get_by_patient_id(self, db: Session, patient_id: str):
        return db.query(OperationHistory).filter(OperationHistory.patient_id == patient_id).all()
    

crud_operation_histories = CRUDOperationHistory()