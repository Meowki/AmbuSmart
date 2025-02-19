from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base

class HealthPersonnel(Base):
    __tablename__ = "health_personnel"
    
    wid = Column(String(255), primary_key=True, nullable=False)
    dno = Column(String(255), ForeignKey("department.dno", ondelete="RESTRICT", onupdate="CASCADE"), nullable=True)
    name = Column(String(255), nullable=True)
    job = Column(String(50), nullable=True)
    sex = Column(String(255), nullable=True)
    id = Column(String(255), nullable=True)
    age = Column(Integer, nullable=True)
    
    # 关系
    department = relationship("Department", back_populates="health_personnel")
    medical_record = relationship("MedicalRecord", back_populates="health_personnel")
    case_histories = relationship("CaseHistory", back_populates="health_personnel")
