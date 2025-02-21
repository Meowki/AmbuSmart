from sqlalchemy.orm import Session
from models.basic_check import BasicCheck
from schemas.ambulance.basic_check import BasicCheckCreate

class CRUDBasicCheck:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(BasicCheck).offset(skip).limit(limit).all()

    def create(self, db: Session, basic_check: BasicCheckCreate):
        db_basic_check = BasicCheck(**basic_check.dict())
        db.add(db_basic_check)
        db.commit()
        db.refresh(db_basic_check)
        return db_basic_check
    
    def get_by_eid(self, db: Session, eid: int):
        return db.query(BasicCheck).filter(BasicCheck.eid == eid).first()
    
    def get_by_patient_id(self, db: Session, patient_id: str):
        return db.query(BasicCheck).filter(BasicCheck.patient_id == patient_id).all()
    

crud_basic_check = CRUDBasicCheck()