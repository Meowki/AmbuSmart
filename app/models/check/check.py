from sqlalchemy import Column, String, Integer, DECIMAL
from sqlalchemy.orm import relationship
from db.base import Base

class Check(Base):
    __tablename__ = 'checks' # 由于和sql关键字重合，所以只对表名添加s

    cid = Column(String(255), primary_key=True, comment='检查项目ID')
    name = Column(String(255), nullable=True, comment='检查项目名称')
    place = Column(String(255), nullable=True, comment='检查地点')
    price = Column(DECIMAL(10, 2), nullable=True, comment='检查价格')
    device = Column(String(255), nullable=True, comment='使用设备')
    num = Column(Integer,  default=0, comment='检查次数')
