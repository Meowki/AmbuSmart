from sqlalchemy.orm import Session
from schemas.ambulance.basic_check import BasicCheckCreate
from crud.ambulance.basic_check import crud_basic_check

class BasicCheckService:
    def get_basic_check_by_eid(self, db: Session, eid: int):
        return crud_basic_check.get_by_eid(db, eid)
    
    def get_basic_check_by_patient_id(self, db: Session, patient_id: str):
        return crud_basic_check.get_by_patient_id(db, patient_id)

    def get_basic_checks(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_basic_check.get_all(db, skip, limit)

    def create_basic_check(self, db: Session, basic_check: BasicCheckCreate):
        return crud_basic_check.create(db, basic_check)

    # 其他服务方法

basic_check_service = BasicCheckService()