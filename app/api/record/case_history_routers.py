# api/record/case_history_routers.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.case_history import CaseHistory, CaseHistoryCreate, CaseHistoryWithChecksResponse
from services.case_history_service import case_history_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/record/case-histories",
    tags=["case-histories"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=CaseHistory)
def add_case_history(case_history: CaseHistoryCreate, db: Session = Depends(get_db)):
    db_case_history = case_history_service.add_case_history(db, case_history)
    return db_case_history

@router.get("/", response_model=list[CaseHistory])
def get_all_case_histories(db: Session = Depends(get_db)):
    case_history = case_history_service.get_all_case_history(db)
    return case_history 

@router.get("/patientId/{patient_id}", response_model=list[CaseHistoryWithChecksResponse])
def get_case_histories_by_patient(patient_id: str, db: Session = Depends(get_db)):
    case_history = case_history_service.get_case_history_by_patient(db, patient_id)
    return case_history 

# 其他医疗历史相关的路由