from sqlalchemy import Column, String, Integer, DECIMAL
from sqlalchemy.orm import relationship
from app.database import Base

class Check(Base):
    __tablename__ = 'check'

    cid = Column(String(255), primary_key=True, comment='检查项目ID')
    name = Column(String(255), nullable=True, comment='检查项目名称')
    place = Column(String(255), nullable=True, comment='检查地点')
    price = Column(DECIMAL(10, 2), nullable=True, comment='检查价格')
    device = Column(String(255), nullable=True, comment='使用设备')
    num = Column(Integer, unsigned=True, default=0, comment='检查次数')
