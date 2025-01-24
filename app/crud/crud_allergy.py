# crud/crud_allergy.py
from sqlalchemy.orm import Session
from models.allergy import Allergy
from schemas.allergy import AllergyCreate

class CRUDAllergy:
    def get_by_patient(self, db: Session, patient_id: str):
        return db.query(Allergy).filter(Allergy.patient_id == patient_id).all()

    def create(self, db: Session, allergy: AllergyCreate, patient_id: str):
        db_allergy = Allergy(**allergy.dict(), patient_id=patient_id)
        db.add(db_allergy)
        db.commit()
        db.refresh(db_allergy)
        return db_allergy

    # 其他CRUD方法

crud_allergy = CRUDAllergy()