from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from schemas.check.check import Check, CheckCreate
from services.check.check_service import check_service
from db.session import SessionLocal

router = APIRouter(
    prefix="/check",
    tags=["check"]
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=Check)
def create_check(check: CheckCreate, db: Session = Depends(get_db)):
    db_check = check_service.create_check(db, check)
    return db_check

@router.get("/{cid}", response_model=Check)
def get_check_by_cid(cid: str, db: Session = Depends(get_db)):
    db_check = check_service.get_check_by_cid(db, cid)
    if db_check is None:
        raise HTTPException(status_code=404, detail="Check not found")
    return db_check

@router.get("/", response_model=list[Check])
def get_all_checks(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    checks = check_service.get_checks(db, skip, limit)
    return checks

# 这里卡了好久，原因是：
# FastAPI是按顺序匹配路由的。当请求到达时，它会先匹配到第一个符合的路由。
# 原本用 /check/{name}做的路由
# 所以当访问/api/check/test时，会首先被get_check_by_cid处理，返回404。
# 期望的是通过name来查询，由于路由顺序的问题，导致请求被错误地处理。
@router.get("/search/{name}", response_model=list[Check])
def get_check_by_name(name: str, db: Session = Depends(get_db)):
    print("api_name:" + name, flush=True)  # 调试输出
    checks = check_service.get_check_by_name(db, name)
    if checks is None:
        raise HTTPException(status_code=404, detail="Check not found")
    return checks



