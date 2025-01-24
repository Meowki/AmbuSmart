from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base

class Allergy(Base):
    __tablename__ = "allergies"

    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(String, ForeignKey("patient.patient_id"), nullable=False)
    allergy_name = Column(String, nullable=False)
    severity = Column(String, nullable=False)
    remark = Column(String, nullable=True)

    # 定义与 Patient 模型的关系 表示每个 Allergy 记录与一个 Patient 关联
    patient = relationship("Patient", back_populates="allergies")