from sqlalchemy.orm import Session
from schemas.ambulance.ambulance import AmbulanceCreate
from crud.ambulance.crud_ambulance import crud_ambulance

class AmbulanceService:
    def get_ambulance_by_aid(self, db: Session, aid: int):
        return crud_ambulance.get_by_aid(db, aid)

    def get_ambulances(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_ambulance.get_all(db, skip, limit)
    
    def get_ambulance_by_operation_id(self, db: Session, operation_id: int):
        return crud_ambulance.get_by_operation_id(db, operation_id)

    def create_ambulance(self, db: Session, ambulance: AmbulanceCreate):
        return crud_ambulance.create(db, ambulance)

    # 其他服务方法

ambulance_service = AmbulanceService()