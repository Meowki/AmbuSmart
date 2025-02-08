from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.orm import relationship
from db.base import Base

class BasicCheck(Base):
    __tablename__ = 'basic_check'

    eid = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime, nullable=True)
    reject = Column(Integer, nullable=True, default=0, comment='若1表示患者拒绝检查')
    consciousness = Column(String(255), nullable=True, comment='神志 清醒/嗜睡/昏迷')
    pupil = Column(String(255), nullable=True, comment='如2/2 表示左右')
    pupillary_light_reflex = Column(String(255), nullable=True, comment='对光反射 灵敏/迟钝/消失')
    blood_pressure = Column(String(255), nullable=True, comment='血压 mmHg')
    pulse = Column(String(255), nullable=True, comment='脉搏 次/分')
    respiration = Column(String(255), nullable=True, comment='呼吸 次/分')
    oxygen_saturation = Column(String(255), nullable=True, comment='血氧饱和度 %')

    operation_histories = relationship("OperationHistory", back_populates="basic_check")