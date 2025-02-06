from sqlalchemy.orm import Session
from schemas.check.check_histories import CheckHistoryCreate
from crud.check.check_histories_crud import crud_check_histories

class CheckHistoryService:
    def get_by_patient_id(self, db: Session, patient_id: str):
        return crud_check_histories.get_by_patient_id(db, patient_id)

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_check_histories.get_all(db, skip, limit)

    def create_check_history(self, db: Session, check: CheckHistoryCreate):
        return crud_check_histories.create(db, check)


check_histories_service = CheckHistoryService()