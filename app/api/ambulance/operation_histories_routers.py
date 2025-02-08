from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.ambulance.operation_history import OperationHistoryCreate, OperationHistory, OperationHistoryWithBasicCheck
from services.ambulance.operation_histories_sevice import operation_histories_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/operation_histories",
    tags=["operation_histories"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=OperationHistory)
def create_operation_history(operation: OperationHistoryCreate, db: Session = Depends(get_db)):
    db_operation = operation_histories_service.create_operation_history(db, operation)
    return db_operation

@router.get("/{patient_id}", response_model=list[OperationHistoryWithBasicCheck])
def get_by_patient_id(patient_id: str, db: Session = Depends(get_db)):
    db_operation = operation_histories_service.get_by_patient_id(db, patient_id)
    if db_operation is None:
        raise HTTPException(status_code=404, detail="Operation History not found")
    return db_operation

@router.get("/", response_model=list[OperationHistory])
def get_all_operation_histories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    operations = operation_histories_service.get_all(db, skip, limit)
    return operations

