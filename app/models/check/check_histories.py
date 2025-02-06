from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, BLOB
from sqlalchemy.orm import relationship
from app.database import Base

class CheckHistory(Base):
    __tablename__ = 'check_histories'

    check_id = Column(Integer, primary_key=True, autoincrement=True, comment='检查信息，仅做内容，不考虑实际记录')
    patient_id = Column(String(255), ForeignKey('patient.patient_id'), nullable=False)
    wid = Column(String(255), ForeignKey('health_personnel.wid'), nullable=True, comment='操作人员工号')
    timestamp = Column(DateTime, nullable=True)
    remark = Column(String(255), nullable=True)
    result = Column(BLOB, nullable=True)
    description = Column(BLOB, nullable=True)
    cid = Column(String(255), ForeignKey('check.cid'), nullable=True)