# api/allergies/routers.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.allergy import Allergy, AllergyCreate
from services.allergy_service import allergy_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/patients/{patient_id}/allergies",
    tags=["allergies"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=Allergy)
def add_allergy(patient_id: str, allergy: AllergyCreate, db: Session = Depends(get_db)):
    db_allergy = allergy_service.add_allergy(db, allergy, patient_id)
    return db_allergy

@router.get("/", response_model=list[Allergy])
def get_allergies(patient_id: str, db: Session = Depends(get_db)):
    allergies = allergy_service.get_allergies(db, patient_id)
    return allergies

# 其他过敏相关的路由