from sqlalchemy.orm import Session
from models.chat import ChatHistory
from models.operation_history import OperationHistory
from models.basic_check import BasicCheck

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

# 获取 `operation_id` 相关的急救数据，包括初检与终检数据
def get_operation_data(db: Session, operation_id: int):
    # 根据 `operation_id` 查询数据库获取所有的急救信息
    operation = db.query(OperationHistory).filter(OperationHistory.operation_id == operation_id).first()
    if operation:

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
            "initial_check": initial_check_text,
            "final_check": final_check_text,
            "ti_content": operation.ti_content,
            "gcs_score": operation.gcs_score,
            "gcs_content": operation.gcs_content,
            "Killip_score": operation.Killip_score,
            "Killip_content": operation.Killip_content,
            "Killip_diagnosis": operation.Killip_diagnosis,
            "cerebral_stroke_content": operation.cerebral_stroke_content,
        }
    return {}
