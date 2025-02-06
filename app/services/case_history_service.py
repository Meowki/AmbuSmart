# services/case_history_service.py
from sqlalchemy.orm import Session
from schemas.case_history import CaseHistoryCreate
from crud.case_history import crud_case_history

class CaseHistoryService:
    def get_all_case_history(self, db: Session):
        return crud_case_history.get_all(db)
    
    def get_case_history_by_patient(self, db: Session, patient_id: str):
        return crud_case_history.get_by_patient(db, patient_id)

    def add_case_history(self, db: Session, case_history: CaseHistoryCreate):
        return crud_case_history.create(db, case_history)

    # 其他服务方法

case_history_service = CaseHistoryService()