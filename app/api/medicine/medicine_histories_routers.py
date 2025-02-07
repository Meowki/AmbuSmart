from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.medicine.medicine_histories import MedicineHistory, MedicineHistoryCreate
from services.medicine.medicine_histories_service import medicine_histories_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/medicine_histories",
    tags=["medicine_histories"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=MedicineHistory)
def create_medicine_history(medicine: MedicineHistoryCreate, db: Session = Depends(get_db)):
    db_medicine = medicine_histories_service.create_medicine_history(db, medicine)
    return db_medicine

@router.get("/{patient_id}", response_model=list[MedicineHistory])
def get_by_patient_id(patient_id: str, db: Session = Depends(get_db)):
    db_medicine = medicine_histories_service.get_by_patient_id(db, patient_id)
    if db_medicine is None:
        raise HTTPException(status_code=404, detail="Medicine History not found")
    return db_medicine

@router.get("/", response_model=list[MedicineHistory])
def get_all_medicine_histories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    medicines = medicine_histories_service.get_all(db, skip, limit)
    return medicines

