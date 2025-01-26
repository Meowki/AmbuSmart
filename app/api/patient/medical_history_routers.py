# api/medical_history/routers.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.medical_history import MedicalHistory, MedicalHistoryCreate
from services.medical_history_service import medical_history_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/patients/{patient_id}/medical-histories",
    tags=["medical-histories"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=MedicalHistory)
def add_medical_history(patient_id: str, medical_history: MedicalHistoryCreate, db: Session = Depends(get_db)):
    db_medical_history = medical_history_service.add_medical_history(db, medical_history, patient_id)
    return db_medical_history

@router.get("/", response_model=list[MedicalHistory])
def get_medical_histories(patient_id: str, db: Session = Depends(get_db)):
    medical_histories = medical_history_service.get_medical_histories(db, patient_id)
    return medical_histories

# 其他医疗历史相关的路由