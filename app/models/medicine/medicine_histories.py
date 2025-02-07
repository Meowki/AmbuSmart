from sqlalchemy import Column, Integer, String, Date, ForeignKey
from sqlalchemy.orm import relationship
from db.base import Base

class MedicineHistory(Base):
    __tablename__ = 'medicine_histories'

    mrid = Column(Integer, primary_key=True, autoincrement=True, comment='用药记录')
    patient_id = Column(String(255), ForeignKey('patient.patient_id'), nullable=True)
    mid = Column(String(255), ForeignKey('medicine.mid'), nullable=True)
    numb = Column(Integer, nullable=True)
    orders = Column(String(255), nullable=True)
    time = Column(Date, nullable=True)
    status = Column(String(255), nullable=True)
    wid = Column(String(255), ForeignKey('health_personnel.wid'), nullable=True)

    medicine_relationship = relationship("MedicineRelationship", back_populates="medicine_histories")