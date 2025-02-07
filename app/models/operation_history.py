# models/operation_history.py,超级半成品
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base


class OperationHistory(Base):
    __tablename__ = 'operation_histories'

    operation_id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(String(255), ForeignKey('patient.patient_id'), nullable=True)  


    # 关系设置
    ambulance = relationship("Ambulance", back_populates="operation_history")
    # patient = relationship("Patient", back_populates="operation_history")
