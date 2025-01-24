# services/allergy_service.py
from sqlalchemy.orm import Session
from schemas.allergy import AllergyCreate
from crud.crud_allergy import crud_allergy

class AllergyService:
    def get_allergies(self, db: Session, patient_id: str):
        return crud_allergy.get_by_patient(db, patient_id)

    def add_allergy(self, db: Session, allergy: AllergyCreate, patient_id: str):
        return crud_allergy.create(db, allergy, patient_id)

    # 其他服务方法

allergy_service = AllergyService()