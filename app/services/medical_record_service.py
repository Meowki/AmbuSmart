# services/medical_record_service.py
from sqlalchemy.orm import Session
from models.check.check_relationship import CheckRelationship
from models.medicine.medicine_relationship import MedicineRelationship
from models.medical_record import MedicalRecord
from schemas.medical_record import MedicalRecordCreate
from crud.medical_record import crud_medical_record
from sqlalchemy.orm import joinedload

class MedicalRecordService:
    def get_all_medical_record(self, db: Session):
        return crud_medical_record.get_all(db)
    
    # 用db的时候是model的，上面括号里的属性才是schemas配置的
    def get_medical_record_by_patient(self, db: Session, patient_id: str):
        # 获取病历、相关的检查记录和用药记录
        result = db.query(MedicalRecord).options(
            # 使用 joinedload 加载检查记录和用药记录
            joinedload(MedicalRecord.check_relationship).joinedload(CheckRelationship.check_histories),
            joinedload(MedicalRecord.medicine_relationship).joinedload(MedicineRelationship.medicine_histories),
            joinedload(MedicalRecord.department),
            joinedload(MedicalRecord.health_personnel)
        ).filter(MedicalRecord.patient_id == patient_id).all()

        for record in result:
            print(f"Medical Record ID: {record.record_id}")
            for check_rel in record.check_relationship:
                print(f"Check ID: {check_rel.check_histories.check_id}, Check Remark: {check_rel.check_histories.remark}")
            for medicine_rel in record.medicine_relationship:
                print(f"Medicine ID: {medicine_rel.medicine_histories.mrid}, Medicine Remark: {medicine_rel.medicine_histories.orders}")

        # 将检查记录和用药记录整合
        medical_records_with_checks_and_medicines = []
        for record in result:
            medical_record_dict = record.__dict__  # 将 ORM 对象转换为字典
            medical_record_dict['check_histories'] = [
                check_rel.check_histories for check_rel in record.check_relationship
            ]
            
            medical_record_dict['medicine_histories'] = [
                medicine_rel.medicine_histories for medicine_rel in record.medicine_relationship
            ]
            # 添加科室信息
            if record.department:
                medical_record_dict['department'] = {
                    'dno': record.department.dno,
                    'dname': record.department.dname,
                    'type': record.department.type
                }
            else:
                medical_record_dict['department'] = None

            # 添加医生信息
            if record.health_personnel:
                medical_record_dict['doctor'] = {
                    'wid': record.health_personnel.wid,
                    'name': record.health_personnel.name,
                    'job': record.health_personnel.job
                }
            else:
                medical_record_dict['doctor'] = None
            medical_records_with_checks_and_medicines.append(medical_record_dict)
        
        return medical_records_with_checks_and_medicines

    def add_medical_record(self, db: Session, medical_record: MedicalRecordCreate):
        return crud_medical_record.create(db, medical_record)

    # 其他服务方法

medical_record_service = MedicalRecordService()