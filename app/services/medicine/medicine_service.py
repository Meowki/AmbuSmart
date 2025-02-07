from sqlalchemy.orm import Session
from schemas.medicine.medicine import MedicineCreate
from crud.medicine.medicine_crud import crud_medicine

class MedicineService:
    def get_medicine_by_mid(self, db: Session, mid: str):
        return crud_medicine.get_by_mid(db, mid)

    def get_medicines(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_medicine.get_all(db, skip, limit)
    
    def get_medicine_by_mname(self, db: Session, mname: str):
        return crud_medicine.get_by_mname(db, mname)

    def create_medicine(self, db: Session, medicine: MedicineCreate):
        return crud_medicine.create(db, medicine)

    # 其他服务方法

medicine_service = MedicineService()