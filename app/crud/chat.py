from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import Session
from datetime import datetime
from models.chat import ChatHistory
from models.operation_history import OperationHistory
from models.basic_check import BasicCheck
from models.patient import Patient
from services.patient_service import patient_service
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def create_chat_record(db: Session, operation_id: int, user_message: str, ai_response: str):
    # 确保 operation_id 存在
    operation = db.query(OperationHistory).filter_by(operation_id=operation_id).first()
    if not operation:
        raise ValueError("Operation ID 不存在")

    chat_record = ChatHistory(
        operation_id=operation_id,
        user_message=user_message,
        ai_response=ai_response
    )
    db.add(chat_record)
    db.commit()
    db.refresh(chat_record)
    return chat_record

def get_chat_history(db: Session, operation_id: int):
    return db.query(ChatHistory).filter_by(operation_id=operation_id).order_by(ChatHistory.created_at).all()

# 通过 patient_id 提取出生日期并计算年龄 
def extract_birthdate_from_id(patient_id: str):
    # 检查身份证号长度是否有效（18位身份证号）
    if len(patient_id) == 18:
        birthdate_str = patient_id[6:14]  # 身份证号第7到14位是出生日期，格式为YYYYMMDD
        birthdate = datetime.strptime(birthdate_str, '%Y%m%d')
        return birthdate
    else:
        return None
# 计算年龄
def calculate_age(patient_id: str):
    birthdate = extract_birthdate_from_id(patient_id)
    if birthdate:
        today = datetime.today()
        age = today.year - birthdate.year
        if today.month < birthdate.month or (today.month == birthdate.month and today.day < birthdate.day):
            age -= 1
        return age
    else:
        return None
    
def get_patient_history(db: Session, patient_id: str):
    patient = patient_service.get_patient(db, patient_id)
    if patient:
        logger.info(f"获取患者数据: patient={patient}")
        return jsonable_encoder(patient)
    else:
        logger.error(f"未找到患者数据: patient_id={patient_id}")
        return None

def get_patient_data(db: Session, patient_id: str):
    # 从数据库查询患者信息
    patient = db.query(Patient).filter(Patient.patient_id == patient_id).first()
    
    if patient:
        # 假设 Patient 模型中有出生日期字段 `birth_date`
        # 如果有出生日期字段，则计算年龄
        if patient.idType == '身份证':
            age = calculate_age(patient.patient_id)
        else:
            age = None  # 如果没有出生日期信息，则无法计算年龄
        
        # 返回格式化的患者信息
        patient_info = f"姓名：{patient.name}，性别：{patient.sex}，年龄：{age}"
        
        return patient_info
    return None


# 获取 `operation_id` 相关的急救数据，包括初检与终检数据
def get_operation_data(db: Session, operation_id: int):
    # 根据 `operation_id` 查询数据库获取所有的急救信息
    operation = db.query(OperationHistory).filter(OperationHistory.operation_id == operation_id).first()
    if operation:

        # 获取患者基本信息
        if operation.patient_id:
            patient_info = get_patient_data(db, operation.patient_id)
        else:
            patient_info = "未找到患者信息"    

        if operation.initial_eid:
            initial_check = db.query(BasicCheck).filter(BasicCheck.eid == operation.initial_eid).first()
            # 格式化初检和终检数据
            initial_check_text = f"""
            初检信息：时间：{initial_check.timestamp}，意识状态：{initial_check.consciousness}，瞳孔反射：{initial_check.pupillary_light_reflex}，
            血压：{initial_check.blood_pressure}，脉搏：{initial_check.pulse}，呼吸频率：{initial_check.respiration}，氧饱和度：{initial_check.oxygen_saturation}.
            """
        if operation.final_eid:
            final_check = db.query(BasicCheck).filter(BasicCheck.eid == operation.final_eid).first()
            final_check_text = f"""
            终检信息：时间：{final_check.timestamp}，意识状态：{final_check.consciousness}，瞳孔反射：{final_check.pupillary_light_reflex}，
            血压：{final_check.blood_pressure}，脉搏：{final_check.pulse}，呼吸频率：{final_check.respiration}，氧饱和度：{final_check.oxygen_saturation}.
            """

        return {
            "patient_info": patient_info,  # 患者基本信息
            "patient_id": operation.patient_id,
            "informant": operation.informant,
            "scene_address": operation.scene_address,
            "dispatch_time": operation.dispatch_time,
            "arrival_on_scene_time": operation.arrival_on_scene_time,
            "departure_from_scene_time": operation.departure_from_scene_time,
            "arrival_at_hospital_time": operation.arrival_at_hospital_time,
            "destination": operation.destination,
            "severity_level": operation.severity_level,
            "emergency_type": operation.emergency_type,
            "chief_complaint": operation.chief_complaint,
            "initial_diagnosis": operation.initial_diagnosis,
            "procedures": operation.procedures,
            "medicine": operation.medicine,
            "outcome": operation.outcome,
            "initial_check": initial_check_text if 'initial_check_text' in locals() else "初检信息暂未录入",
            "final_check": final_check_text if 'final_check_text' in locals() else "终检信息暂未录入",
            "ti_content": operation.ti_content,
            "gcs_score": operation.gcs_score,
            "gcs_content": operation.gcs_content,
            "Killip_score": operation.Killip_score,
            "Killip_content": operation.Killip_content,
            "Killip_diagnosis": operation.Killip_diagnosis,
            "cerebral_stroke_content": operation.cerebral_stroke_content,
        }
    return {}
