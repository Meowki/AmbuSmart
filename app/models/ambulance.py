from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base
from models.operation_history import OperationHistory  

class Ambulance(Base):
    __tablename__ = 'ambulance'
    # 这不对了，这应该是车和司机的信息，感觉其实不需要车。。。？
    # 暂时ambulance 表弃用，车的信息暂时不考虑。。。

    aid = Column(Integer, primary_key=True, index=True)
    car_num = Column(String(255), nullable=True)
    driver = Column(String(255), nullable=True)
    dispatch_time = Column(DateTime, nullable=True)
    arrival_on_scene_time = Column(DateTime, nullable=True)
    departure_from_scene_time = Column(DateTime, nullable=True)
    arrival_at_hospital_time = Column(DateTime, nullable=True)
    operation_id = Column(Integer, ForeignKey('operation_histories.operation_id'), nullable=True)

    # 关系设置
    # operation_history = relationship("OperationHistory", back_populates="ambulance")


