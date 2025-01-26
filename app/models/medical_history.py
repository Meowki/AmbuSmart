from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base

class MedicalHistory(Base):
    __tablename__ = "medical_histories"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    patient_id = Column(String(255), ForeignKey("patient.patient_id", ondelete="CASCADE"))
    condition_name = Column(String(255))
    diagnosis_date = Column(Date)
    remark = Column(String(255))
    
    patient = relationship("Patient", back_populates="medical_histories")