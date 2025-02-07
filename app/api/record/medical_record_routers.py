# api/record/medical_record_routers.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.medical_record import MedicalRecord, MedicalRecordCreate,MedicalRecordWithChecksResponse
from services.medical_record_service import medical_record_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/record/medical-records",
    tags=["medical-records"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=MedicalRecord)
def add_medical_record(medical_record: MedicalRecordCreate, db: Session = Depends(get_db)):
    db_medical_record = medical_record_service.add_medical_record(db, medical_record)
    return db_medical_record

@router.get("/", response_model=list[MedicalRecord])
def get_all_medical_record(db: Session = Depends(get_db)):
    medical_record = medical_record_service.get_all_medical_record(db)
    return medical_record

@router.get("/{patient_id}", response_model=list[MedicalRecordWithChecksResponse])
def get_medical_histories_by_patient(patient_id: str, db: Session = Depends(get_db)):
    medical_record = medical_record_service.get_medical_record_by_patient(db, patient_id)
    return medical_record 

# 其他医疗历史相关的路由