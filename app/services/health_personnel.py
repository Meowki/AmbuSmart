# services/health_personnel_service.py
from sqlalchemy.orm import Session
from schemas.health_personnel import HealthPersonnelCreate
from crud.health_personnel import crud_health_personnel

class HealthPersonnelService:
    def get_health_personnel(self, db: Session, wid: str):
        return crud_health_personnel.get(db, wid)

    def get_health_personnel(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_health_personnel.get_all(db, skip, limit)

    def create_health_personnel(self, db: Session, health_personnel: HealthPersonnelCreate):
        return crud_health_personnel.create(db, health_personnel)

    # 其他服务方法

health_personnel_service = HealthPersonnelService()