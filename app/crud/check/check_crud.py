from sqlalchemy.orm import Session
from models.check.check import Check
from schemas.check.check import CheckCreate

class CRUDCheck:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(Check).offset(skip).limit(limit).all()

    def create(self, db: Session, check: CheckCreate):
        db_check = Check(**check.dict())
        db.add(db_check)
        db.commit()
        db.refresh(db_check)
        return db_check
    
    def get_by_cid(self, db: Session, cid: str):
        return db.query(Check).filter(Check.cid == cid).first()
    
    def get_by_name(self, db: Session, name: str):
        return db.query(Check).filter(Check.name.ilike(f"%{name}%")).all()



crud_check = CRUDCheck()