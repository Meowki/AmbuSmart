# 门诊/急诊病历
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base

class MedicalRecord(Base):
    __tablename__ = "medical_record"
    
    record_id = Column(Integer, primary_key=True, index=True, autoincrement=True, comment='门诊病历，已剔除check')
    patient_id = Column(String(255), ForeignKey("patient.patient_id", ondelete="CASCADE"), nullable=False)
    wid = Column(String(255), ForeignKey("health_personnel.wid", ondelete="RESTRICT"), nullable=True, comment='门诊医师')
    dno = Column(String(255), ForeignKey("department.dno", ondelete="RESTRICT"), nullable=True)
    hospital = Column(String(255), nullable=True)
    type = Column(String(255), nullable=True, comment='初诊/复诊/急诊')
    companion = Column(String(255), nullable=True, comment='是否有陪护')
    chief_complaint = Column(String(255), nullable=True, comment='主诉')
    present_illness = Column(String(255), nullable=True, comment='现病史')
    timestamp = Column(DateTime, nullable=True)
    temperature = Column(String(255), nullable=True, comment='体温 ℃')
    pulse = Column(String(255), nullable=True, comment='脉搏 （次/分）')
    sbp = Column(String(255), nullable=True, comment='收缩压 mmHg')
    dbp = Column(String(255), nullable=True, comment='舒张压 mmHg')
    pulmonary = Column(String(255), nullable=True, comment='呼吸 （次/分）')
    consciousness = Column(String(255), nullable=True, comment='意识状态')
    measures = Column(String(255), nullable=True, comment='处理措施')
    observation = Column(String(255), nullable=True, comment='是否留观')
    assessment = Column(String(255), nullable=True, comment='初步评估结果/诊断')
    remark = Column(String(255), nullable=True)

    patient = relationship("Patient", back_populates="medical_record")
    check_relationship = relationship("CheckRelationship", back_populates="medical_record")
    medicine_relationship = relationship("MedicineRelationship", back_populates="medical_record")
    department = relationship("Department", back_populates="medical_record")
    health_personnel = relationship("HealthPersonnel", back_populates="medical_record")