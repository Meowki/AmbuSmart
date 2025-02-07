# ambulence这里指的是救护车信息，operation为急救信息
# 理应先创建operation，再关联ambulance
# relationship指随车工作人员、还有check、medicine的关系表

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.ambulance.ambulance import Ambulance, AmbulanceCreate
from services.ambulance.ambulance import ambulance_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/ambulance",
    tags=["ambulance"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=Ambulance)
def create_ambulance(ambulance: AmbulanceCreate, db: Session = Depends(get_db)):
    db_ambulance = ambulance_service.create_ambulance(db, ambulance)
    return db_ambulance

@router.get("/aid/{aid}", response_model=list[Ambulance])
def get_ambulance_by_aid(aid: str, db: Session = Depends(get_db)):
    db_ambulance = ambulance_service.get_ambulance_by_aid(db, aid)
    if db_ambulance is None:
        raise HTTPException(status_code=404, detail="Ambulance not found")
    return db_ambulance

@router.get("/", response_model=list[Ambulance])
def get_all_ambulances(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    ambulances = ambulance_service.get_ambulances(db, skip, limit)
    return ambulances

@router.get("/operation/{operation_id}", response_model=list[Ambulance])
def get_ambulance_by_operation_id(operation_id: int, db: Session = Depends(get_db)):
    db_ambulance = ambulance_service.get_ambulance_by_operation_id(db, operation_id)
    if db_ambulance is None:
        raise HTTPException(status_code=404, detail="Ambulance not found")
    return db_ambulance


