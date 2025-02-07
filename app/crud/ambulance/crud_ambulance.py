from sqlalchemy.orm import Session
from models.ambulance import Ambulance
from schemas.ambulance.ambulance import AmbulanceCreate

class CRUDAmbulance:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(Ambulance).offset(skip).limit(limit).all()

    def create(self, db: Session, ambulance: AmbulanceCreate):
        db_ambulance = Ambulance(**ambulance.dict())
        db.add(db_ambulance)
        db.commit()
        db.refresh(db_ambulance)
        return db_ambulance
    
    def get_by_aid(self, db: Session, aid: int):
        return db.query(Ambulance).filter(Ambulance.aid == aid).all()
    
    def get_by_operation_id(self, db: Session, operation_id: int):
        return db.query(Ambulance).filter(Ambulance.operation_id == operation_id).all()
    

crud_ambulance = CRUDAmbulance()