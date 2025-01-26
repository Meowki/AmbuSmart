from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.health_personnel import HealthPersonnel, HealthPersonnelCreate
from services.health_personnel import health_personnel_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/health_personnel",
    tags=["health_personnel"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=HealthPersonnel)
def create_health_personnel(health_personnel: HealthPersonnelCreate, db: Session = Depends(get_db)):
    db_health_personnel = health_personnel_service.create_health_personnel(db, health_personnel)
    return db_health_personnel

@router.get("/{wid}", response_model=HealthPersonnel)
def read_health_personnel(wid: str, db: Session = Depends(get_db)):
    db_health_personnel = health_personnel_service.get_health_personnel(db, wid)
    if db_health_personnel is None:
        raise HTTPException(status_code=404, detail="HealthPersonnel not found")
    return db_health_personnel

@router.get("/", response_model=list[HealthPersonnel])
def read_health_personnel(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    health_personnel = health_personnel_service.get_health_personnel(db, skip, limit)
    return health_personnel