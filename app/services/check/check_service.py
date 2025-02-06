from sqlalchemy.orm import Session
from schemas.check.check import CheckCreate
from crud.check.check_crud import crud_check

class CheckService:
    def get_check_by_cid(self, db: Session, cid: str):
        return crud_check.get_by_cid(db, cid)

    def get_checks(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_check.get_all(db, skip, limit)
    
    def get_check_by_name(self, db: Session, name: str):
        return crud_check.get_by_name(db, name)

    def create_check(self, db: Session, check: CheckCreate):
        return crud_check.create(db, check)

    # 其他服务方法

check_service = CheckService()