# services/medical_record_service.py
from sqlalchemy.orm import Session
from models.check.check_relationship import CheckRelationship
from models.medical_record import MedicalRecord
from models.check.check_histories import CheckHistory
from schemas.medical_record import MedicalRecordCreate
from crud.medical_record import crud_medical_record
from sqlalchemy.orm import joinedload

class MedicalRecordService:
    def get_all_medical_record(self, db: Session):
        return crud_medical_record.get_all(db)
    
    # 用db的时候是model的，上面括号里的属性才是schemas配置的
    def get_medical_record_by_patient(self, db: Session, patient_id: str):
        # return crud_medical_record.get_by_patient(db, patient_id)
        # 获取病历和相关联的检查记录
        # result = db.query(MedicalRecord).join(CheckRelationship, CheckRelationship.record_id == MedicalRecord.record_id).join(CheckHistory, CheckHistory.check_id == CheckRelationship.check_id).filter(MedicalRecord.patient_id == patient_id).all()
        result = db.query(MedicalRecord).options(
        # 使用joinedload加载CheckHistory关系
        joinedload(MedicalRecord.check_relationship).joinedload(CheckRelationship.check_histories)
    ).filter(MedicalRecord.patient_id == patient_id).all()

    # 输出调试信息查看结果
        for record in result:
            print(f"Medical Record ID: {record.record_id}")
            for check_rel in record.check_relationship:
                print(f"Check ID: {check_rel.check_id}, Check Name: {check_rel.check_histories.remark}")
        
         # 确保返回的数据正确映射到 schema
        medical_records_with_checks = []
        for record in result:
            medical_record_dict = record.__dict__  # 将 ORM 对象转换为字典
            medical_record_dict['check_histories'] = [
                check_rel.check_histories for check_rel in record.check_relationship
            ]
            medical_records_with_checks.append(medical_record_dict)
    
        return medical_records_with_checks

        # return result

    def add_medical_record(self, db: Session, medical_record: MedicalRecordCreate):
        return crud_medical_record.create(db, medical_record)

    # 其他服务方法

medical_record_service = MedicalRecordService()