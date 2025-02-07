from sqlalchemy import Column, Integer,ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base

class MedicineRelationship(Base):
    __tablename__ = 'medicine_relationship'

    id = Column(Integer, primary_key=True, index=True)
    mrid = Column(Integer, ForeignKey('medicine_histories.mrid')) 
    record_id = Column(Integer, ForeignKey('medical_record.record_id'))  
    case_id = Column(Integer, ForeignKey('case_histories.case_id'))  
    operation_id = Column(Integer, ForeignKey('operation_histories.operation_id'))  

    # 设置关系
    medical_record = relationship("MedicalRecord", back_populates="medicine_relationship")
    medicine_histories = relationship("MedicineHistory", back_populates="medicine_relationship")
    case_history = relationship("CaseHistory", back_populates="medicine_relationship")
    # operation_history = relationship("OperationHistory", back_populates="medicine_relationship")
