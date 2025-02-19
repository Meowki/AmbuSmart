from sqlalchemy import Column, String
from sqlalchemy.orm import relationship
from db.base import Base

class Department(Base):
    __tablename__ = "department"
    
    dno = Column(String(255), primary_key=True, nullable=False)
    dname = Column(String(255), nullable=True)
    type = Column(String(255), nullable=True)
    
    # 关系
    health_personnel = relationship("HealthPersonnel", back_populates="department")
    medical_record = relationship("MedicalRecord", back_populates="department")
    case_histories = relationship("CaseHistory", back_populates="department")
