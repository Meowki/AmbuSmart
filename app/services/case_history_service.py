from sqlalchemy.orm import Session
from models.check.check_relationship import CheckRelationship
from models.medicine.medicine_relationship import MedicineRelationship
from models.case_history import CaseHistory
from schemas.case_history import CaseHistoryCreate
from crud.case_history import crud_case_history
from sqlalchemy.orm import joinedload

class CaseHistoryService:
    def get_all_case_history(self, db: Session):
        return crud_case_history.get_all(db)
    
    def get_case_history_by_patient(self, db: Session, patient_id: str):
        result = db.query(CaseHistory).options(
            joinedload(CaseHistory.check_relationship).joinedload(CheckRelationship.check_histories),
            joinedload(CaseHistory.medicine_relationship).joinedload(MedicineRelationship.medicine_histories)
        ).filter(CaseHistory.patient_id == patient_id).all()

        for case in result:
            print(f"Case History ID: {case.case_id}")
            for check_rel in case.check_relationship:
                print(f"Check ID: {check_rel.check_histories.check_id}, Check Remark: {check_rel.check_histories.remark}")
            for medicine_rel in case.medicine_relationship:
                print(f"Medicine ID: {medicine_rel.medicine_histories.mrid}, Medicine Remark: {medicine_rel.medicine_histories.orders}")

        # 将检查记录和用药记录整合
        case_histories_with_checks_and_medicines = []
        for record in result:
            case_history_dict = record.__dict__  # 将 ORM 对象转换为字典
            case_history_dict['check_histories'] = [
                check_rel.check_histories for check_rel in record.check_relationship
            ]
            
            case_history_dict['medicine_histories'] = [
                medicine_rel.medicine_histories for medicine_rel in record.medicine_relationship
            ]
            
            case_histories_with_checks_and_medicines.append(case_history_dict)
        
        return case_histories_with_checks_and_medicines

    def add_case_history(self, db: Session, case_history: CaseHistoryCreate):
        return crud_case_history.create(db, case_history)

    # 其他服务方法

case_history_service = CaseHistoryService()