from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.department import Department, DepartmentCreate
from services.department_service import department_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/departments",
    tags=["departments"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=Department)
def create_department(department: DepartmentCreate, db: Session = Depends(get_db)):
    db_department = department_service.create_department(db, department)
    return db_department

@router.get("/{dno}", response_model=Department)
def read_department(dno: str, db: Session = Depends(get_db)):
    db_department = department_service.get_department(db, dno)
    if db_department is None:
        raise HTTPException(status_code=404, detail="Department not found")
    return db_department

@router.get("/", response_model=list[Department])
def read_departments(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    departments = department_service.get_departments(db, skip, limit)
    return departments
