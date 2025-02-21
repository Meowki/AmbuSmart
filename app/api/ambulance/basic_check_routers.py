from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.ambulance.basic_check import BasicCheck, BasicCheckCreate
from services.ambulance.basic_check import basic_check_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/basic_check",
    tags=["basic_check"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=BasicCheck)
def create_basic_check(basic_check: BasicCheckCreate, db: Session = Depends(get_db)):
    db_basic_check = basic_check_service.create_basic_check(db, basic_check)
    return db_basic_check

@router.get("/eid/{eid}", response_model=BasicCheck)
def get_basic_check_by_eid(eid: str, db: Session = Depends(get_db)):
    db_basic_check = basic_check_service.get_basic_check_by_eid(db, eid)
    if db_basic_check is None:
        raise HTTPException(status_code=404, detail="Basic check not found")
    return db_basic_check

@router.get("/", response_model=list[BasicCheck])
def get_all_basic_checks(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    basic_checks = basic_check_service.get_basic_checks(db, skip, limit)
    return basic_checks

@router.get("/patient_id/{patient_id}", response_model=BasicCheck)
def get_basic_check_by_patient_id(patient_id: str, db: Session = Depends(get_db)):
    db_basic_check = basic_check_service.get_basic_check_by_patient_id(db, patient_id)
    if db_basic_check is None:
        raise HTTPException(status_code=404, detail="Basic check not found")
    return db_basic_check

@router.put("/update/{eid}", response_model=BasicCheck)
def update_basic_check(eid: int, basic_check: BasicCheckCreate, db: Session = Depends(get_db)):
    # 获取现有记录
    db_basic_check = basic_check_service.get_basic_check_by_eid(db, eid)
    if db_basic_check is None:
        raise HTTPException(status_code=404, detail="Basic Check not found")
    
    # 遍历传入的更新数据，只更新非空字段
    for attr, value in vars(basic_check).items():
        if value is not None:
            setattr(db_basic_check, attr, value)
    
    # 提交更新后的对象
    db.add(db_basic_check)
    db.commit()
    db.refresh(db_basic_check)
    
    return db_basic_check

