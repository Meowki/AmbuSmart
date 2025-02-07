from sqlalchemy.orm import Session
from schemas.medicine.medicine_histories import MedicineHistoryCreate
from crud.medicine.medicine_histories_crud import crud_medicine_histories

class MedicineHistoryService:
    def get_by_patient_id(self, db: Session, patient_id: str):
        return crud_medicine_histories.get_by_patient_id(db, patient_id)

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_medicine_histories.get_all(db, skip, limit)

    def create_medicine_history(self, db: Session, medicine: MedicineHistoryCreate):
        return crud_medicine_histories.create(db, medicine)


medicine_histories_service = MedicineHistoryService()