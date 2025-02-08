from sqlalchemy.orm import Session
from schemas.ambulance.operation_history import OperationHistoryCreate
from crud.ambulance.crud_operation_history import crud_operation_histories

class OperationHistoryService:
    def get_by_patient_id(self, db: Session, patient_id: str):
        return crud_operation_histories.get_by_patient_id(db, patient_id)

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_operation_histories.get_all(db, skip, limit)

    def create_operation_history(self, db: Session, operation: OperationHistoryCreate):
        return crud_operation_histories.create(db, operation)


operation_histories_service = OperationHistoryService()