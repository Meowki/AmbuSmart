from sqlalchemy.orm import Session
from models.medicine.medicine import Medicine
from schemas.medicine.medicine import MedicineCreate

class CRUDMedicine:

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(Medicine).offset(skip).limit(limit).all()

    def create(self, db: Session, medicine: MedicineCreate):
        db_medicine = Medicine(**medicine.dict())
        db.add(db_medicine)
        db.commit()
        db.refresh(db_medicine)
        return db_medicine
    
    def get_by_mid(self, db: Session, mid: str):
        return db.query(Medicine).filter(Medicine.mid == mid).first()
    
    def get_by_mname(self, db: Session, mname: str):
        return db.query(Medicine).filter(Medicine.mname.ilike(f"%{mname}%")).all()



crud_medicine = CRUDMedicine()