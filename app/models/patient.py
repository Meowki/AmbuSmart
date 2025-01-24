from sqlalchemy import Column, String, Integer
from sqlalchemy.orm import relationship
from db.base import Base

class Patient(Base):
    __tablename__ = "patient"
    
    patient_id = Column(String(255), primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    sex = Column(String(255), nullable=True)
    idType = Column(String(255), nullable=True)
    telno = Column(String(50), nullable=True)
    address = Column(String(255), nullable=True)
    ethnicity = Column(String(255), nullable=True)

    # 定义与 Allergy 模型的关系
    allergies = relationship("Allergy", back_populates="patient", cascade="all, delete-orphan")
    # 其他关系