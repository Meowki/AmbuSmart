from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from models.users import User
from db.session import Database
from pydantic import BaseModel

router = APIRouter(
    prefix="/users",
    tags=["users"],
)

# Pydantic 模型
class UserCreate(BaseModel):
    name: str
    email: str

class UserRead(BaseModel):
    id: int
    name: str
    email: str

    class Config:
        orm_mode = True

db_instance = Database()

@router.post("/", response_model=UserRead)
def create_user(user: UserCreate, db: Session = Depends(db_instance.get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email 已存在")
    new_user = User(name=user.name, email=user.email)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@router.get("/", response_model=List[UserRead])
def read_users(skip: int = 0, limit: int = 10, db: Session = Depends(db_instance.get_db)):
    users = db.query(User).offset(skip).limit(limit).all()
    return users

@router.get("/{user_id}", response_model=UserRead)
def read_user(user_id: int, db: Session = Depends(db_instance.get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise HTTPException(status_code=404, detail="用户未找到")
    return user

@router.put("/{user_id}", response_model=UserRead)
def update_user(user_id: int, user: UserCreate, db: Session = Depends(db_instance.get_db)):
    db_user = db.query(User).filter(User.id == user_id).first()
    if db_user is None:
        raise HTTPException(status_code=404, detail="用户未找到")
    db_user.name = user.name
    db_user.email = user.email
    db.commit()
    db.refresh(db_user)
    return db_user

@router.delete("/{user_id}")
def delete_user(user_id: int, db: Session = Depends(db_instance.get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise HTTPException(status_code=404, detail="用户未找到")
    db.delete(user)
    db.commit()
    return {"detail": "用户已删除"}
