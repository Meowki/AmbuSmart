from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.medicine.medicine import Medicine, MedicineCreate
from services.medicine.medicine_service import medicine_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/medicine",
    tags=["medicine"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=Medicine)
def create_medicine(medicine: MedicineCreate, db: Session = Depends(get_db)):
    db_medicine = medicine_service.create_medicine(db, medicine)
    return db_medicine

@router.get("/{mid}", response_model=Medicine)
def get_medicine_by_mid(mid: str, db: Session = Depends(get_db)):
    db_medicine = medicine_service.get_medicine_by_mid(db, mid)
    if db_medicine is None:
        raise HTTPException(status_code=404, detail="Medicine not found")
    return db_medicine

@router.get("/", response_model=list[Medicine])
def get_all_medicines(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    medicines = medicine_service.get_medicines(db, skip, limit)
    return medicines

@router.get("/search/{mname}", response_model=list[Medicine])
def get_medicine_by_name(mname: str, db: Session = Depends(get_db)):
    medicines = medicine_service.get_medicine_by_mname(db, mname)
    if medicines is None:
        raise HTTPException(status_code=404, detail="Medicine not found")
    return medicines



