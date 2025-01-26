# crud/crud_health_personnel.py
from sqlalchemy.orm import Session
from models.health_personnel import HealthPersonnel
from schemas.health_personnel import HealthPersonnelCreate

class CRUDHealthPersonnel:
    def get(self, db: Session, wid: str):
        return db.query(HealthPersonnel).filter(HealthPersonnel.wid == wid).first()

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(HealthPersonnel).offset(skip).limit(limit).all()

    def create(self, db: Session, health_personnel: HealthPersonnelCreate):
        db_health_personnel = HealthPersonnel(**health_personnel.dict())
        db.add(db_health_personnel)
        db.commit()
        db.refresh(db_health_personnel)
        return db_health_personnel

    # 其他CRUD方法

crud_health_personnel = CRUDHealthPersonnel()