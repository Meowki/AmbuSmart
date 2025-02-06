from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.check.check_histories import CheckHistory, CheckHistoryCreate
from services.check.check_histories_service import check_histories_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/check_histories",
    tags=["check_histories"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=CheckHistory)
def create_check_history(check: CheckHistoryCreate, db: Session = Depends(get_db)):
    db_check = check_histories_service.create_check_history(db, check)
    return db_check

@router.get("/{patient_id}", response_model=list[CheckHistory])
def get_by_patient_id(patient_id: str, db: Session = Depends(get_db)):
    db_check = check_histories_service.get_by_patient_id(db, patient_id)
    if db_check is None:
        raise HTTPException(status_code=404, detail="Check History not found")
    return db_check

@router.get("/", response_model=list[CheckHistory])
def get_all_check_histories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    checks = check_histories_service.get_all(db, skip, limit)
    return checks

