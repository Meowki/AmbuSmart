# services/department_service.py
from sqlalchemy.orm import Session
from schemas.department import DepartmentCreate
from crud.crud_department import crud_department

class DepartmentService:
    def get_department(self, db: Session, dno: str):
        return crud_department.get(db, dno)

    def get_departments(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_department.get_all(db, skip, limit)

    def create_department(self, db: Session, department: DepartmentCreate):
        return crud_department.create(db, department)

    # 其他服务方法

department_service = DepartmentService()