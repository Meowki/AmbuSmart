from sqlalchemy import JSON, Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from db.base import Base

class OperationHistory(Base):
    __tablename__ = 'operation_histories'

    operation_id = Column(Integer, primary_key=True, autoincrement=True, comment='急救用表')
    patient_id = Column(String(255), ForeignKey('patient.patient_id', ondelete='CASCADE', onupdate='CASCADE'))
    informant = Column(String(255), comment='供史者 本人/亲属/目击者')
    scene_address = Column(String(255), comment='现场地址')
    dispatch_time = Column(DateTime, comment='出车时间')
    arrival_on_scene_time = Column(DateTime, comment='到达现场时间')
    departure_from_scene_time = Column(DateTime, comment='离开现场时间')
    arrival_at_hospital_time = Column(DateTime, comment='到达医院时间')
    destination = Column(String(255), comment='送达地')
    severity_level = Column(String(255), comment='病情分级')
    emergency_type = Column(String(255), comment='急救性质 院前急救/转院/其他')
    chief_complaint = Column(Text, comment='病史/主诉')
    initial_diagnosis = Column(Text, comment='初步诊断')
    procedures = Column(Text, comment='急救处理，有就记录，看表')
    medicine = Column(Text, comment='药物使用记录')
    outcome = Column(Text, comment='急救结果')
    physician = Column(String(255), comment='急救医师')
    nurse = Column(String(255), comment='护士')
    driver = Column(String(255), comment='司机')
    paramedic = Column(String(255), comment='抢救员')
    stretcher_bearer = Column(String(255), comment='担架工')
    recipient = Column(String(255), comment='院内接收者')
    initial_eid = Column(Integer, comment='初检id')
    final_eid = Column(Integer, comment='终检id')
    ti_score = Column(String(255), comment='创伤指数评分')
    ti_content = Column(JSON, comment='ti具体内容')
    gcs_score = Column(String(255), comment='gcs评分')
    gcs_content = Column(JSON, comment='gcs具体内容')
    Killip_score = Column(String(255), comment='Killip分级')
    Killip_content = Column(JSON, comment='表格里的胸痛高位状态评估')
    Killip_diagnosis = Column(String(255), comment='胸痛初步判断')
    cerebral_stroke_content = Column(JSON, comment='脑卒中评估')

    # initial_exam = relationship("BasicCheck", foreign_keys=[initial_eid], backref="initial_operation_history")
    # final_exam = relationship("BasicCheck", foreign_keys=[final_eid], backref="final_operation_history")
    patient = relationship("Patient", back_populates="operation_histories")
    # basic_check = relationship("BasicCheck", back_populates="operation_histories")