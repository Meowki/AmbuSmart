from sqlalchemy import Column, Integer,ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base


class CheckRelationship(Base):
    __tablename__ = 'check_relationship'

    id = Column(Integer, primary_key=True, index=True)
    record_id = Column(Integer, ForeignKey('medical_record.record_id'))
    case_id = Column(Integer, ForeignKey('case_histories.case_id'))
    operation_id = Column(Integer, ForeignKey('operation_histories.operation_id'))
    check_id = Column(Integer, ForeignKey('check_histories.check_id'))

    medical_record = relationship("MedicalRecord", back_populates="check_relationship")
    check_histories = relationship("CheckHistory", back_populates="check_relationship")
    case_history = relationship("CaseHistory", back_populates="check_relationship")
