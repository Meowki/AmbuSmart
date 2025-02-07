from sqlalchemy.orm import Session
from models.medicine.medicine_histories import MedicineHistory
from schemas.medicine.medicine_histories import MedicineHistoryCreate

class CRUDMedicineHistory:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(MedicineHistory).offset(skip).limit(limit).all()

    def create(self, db: Session, medicine: MedicineHistoryCreate):
        db_medicine = MedicineHistory(**medicine.dict())
        db.add(db_medicine)
        db.commit()
        db.refresh(db_medicine)
        return db_medicine
    
    def get_by_patient_id(self, db: Session, patient_id: str):
        return db.query(MedicineHistory).filter(MedicineHistory.patient_id == patient_id).all()
    

crud_medicine_histories = CRUDMedicineHistory()