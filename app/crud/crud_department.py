# crud/crud_department.py
from sqlalchemy.orm import Session
from models.department import Department
from schemas.department import DepartmentCreate

class CRUDDepartment:
    def get(self, db: Session, dno: str):
        return db.query(Department).filter(Department.dno == dno).first()

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return db.query(Department).offset(skip).limit(limit).all()

    def create(self, db: Session, department: DepartmentCreate):
        db_department = Department(**department.dict())
        db.add(db_department)
        db.commit()
        db.refresh(db_department)
        return db_department

    # 其他CRUD方法

crud_department = CRUDDepartment()