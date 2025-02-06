from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.patient import Patient, PatientCreate
from services.patient_service import patient_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/patients",
    tags=["patients"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=Patient)
def create_patient(patient: PatientCreate, db: Session = Depends(get_db)):
    db_patient = patient_service.create_patient(db, patient)
    return db_patient

@router.get("/{patient_id}", response_model=list[Patient])
def read_patient(patient_id: str, db: Session = Depends(get_db)):
    db_patient = patient_service.get_patient(db, patient_id)
    if db_patient is None:
        raise HTTPException(status_code=404, detail="Patient not found")
    return db_patient

@router.get("/", response_model=list[Patient])
def read_patients(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    patients = patient_service.get_patients(db, skip, limit)
    return patients
