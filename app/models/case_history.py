# 门诊/急诊病历，待补充药方和检查结果
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base

class CaseHistory(Base):
    __tablename__ = "case_histories"
    
    case_id = Column(Integer, primary_key=True, autoincrement=True, comment='住院单，已剔除check')
    patient_id = Column(String(255), ForeignKey("patient.patient_id", ondelete="CASCADE"), nullable=False)
    wid = Column(String(255), ForeignKey("health_personnel.wid", ondelete="RESTRICT"), nullable=True, comment='门诊医师')
    dno = Column(String(255), ForeignKey("department.dno", ondelete="RESTRICT"), nullable=True)
    hospital = Column(String(255), nullable=True)
    in_timestamp = Column(DateTime, nullable=True, comment='入院时间')
    out_timestamp = Column(DateTime, nullable=True, comment='出院时间')
    in_assessment = Column(String(255), nullable=True, comment='入院病情')
    remark = Column(String(255), nullable=True)
    out_result = Column(String(255), nullable=True, comment='出院诊断')

    patient = relationship("Patient", back_populates="case_histories")
    check_relationship = relationship("CheckRelationship", back_populates="case_history")
    medicine_relationship = relationship("MedicineRelationship", back_populates="case_history")