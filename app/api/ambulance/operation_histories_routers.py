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

@router.get("/operationId/{operation_id}", response_model=OperationHistoryWithBasicCheck)
def get_by_operation_id(operation_id: int, db: Session = Depends(get_db)):
    db_operation = operation_histories_service.get_by_operation_id(db, operation_id)
    if db_operation is None:
        raise HTTPException(status_code=404, detail="Operation History not found")
    return db_operation

# 获取除了当前急救之外的所有记录
@router.get("/withoutThis/{operation_id}/{patient_id}", response_model=list[OperationHistoryWithBasicCheck])
def get_without_operation_id(operation_id: int, patient_id: str, db: Session = Depends(get_db)):
    db_operation = operation_histories_service.get_without_operation_id(db, operation_id, patient_id)
    if db_operation is None:
        raise HTTPException(status_code=404, detail="Operation History not found")
    return db_operation

@router.get("/", response_model=list[OperationHistory])
def get_all_operation_histories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    operations = operation_histories_service.get_all(db, skip, limit)
    return operations

@router.delete("/delete/{operation_id}", response_model=OperationHistory)
def delete_operation_history(operation_id: str, db: Session = Depends(get_db)):
    db_operation = operation_histories_service.get_by_operation_id(db, operation_id)
    if db_operation is None:
        raise HTTPException(status_code=404, detail="Operation History not found")
    operation_histories_service.delete_operation_history(db, operation_id)
    return db_operation

@router.put("/update/{operation_id}", response_model=OperationHistory)
def update_operation_history(operation_id: str, operation: OperationHistoryCreate, db: Session = Depends(get_db)):
    # 获取现有记录
    db_operation = operation_histories_service.get_by_operation_id(db, operation_id)
    if db_operation is None:
        raise HTTPException(status_code=404, detail="Operation History not found")
    
    # 遍历传入的更新数据，只更新非空字段
    for attr, value in vars(operation).items():
        if value is not None:
            setattr(db_operation, attr, value)
    
    # 提交更新后的对象
    db.add(db_operation)
    db.commit()
    db.refresh(db_operation)
    
    return db_operation


