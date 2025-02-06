from sqlalchemy import Column, String, Integer, DECIMAL
from sqlalchemy.orm import relationship
from db.base import Base

class Medicine(Base):
    __tablename__ = 'medicine'

    mid = Column(String(255), primary_key=True, comment='药品ID')
    mname = Column(String(255), nullable=True, comment='药品名称')
    type = Column(String(255), nullable=True, comment='药品类型')
    factory = Column(String(255), nullable=True, comment='生产厂家')
    price = Column(DECIMAL(10, 2), nullable=True, comment='药品价格')
    unit = Column(String(255), nullable=True, comment='单位')
    store = Column(String(255), nullable=True, comment='库存')
    specs = Column(String(255), nullable=True, comment='规格')
    sell = Column(Integer, default=0, comment='销售数量')
