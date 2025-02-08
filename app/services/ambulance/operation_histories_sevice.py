from sqlalchemy.orm import Session
from schemas.ambulance.operation_history import OperationHistoryCreate
from crud.ambulance.crud_operation_history import crud_operation_histories
from models.operation_history import OperationHistory
from models.basic_check import BasicCheck


class OperationHistoryService:
    def get_by_patient_id(self, db: Session, patient_id: str):
        # return crud_operation_histories.get_by_patient_id(db, patient_id)
          # 查询操作历史记录
        operation_histories = db.query(OperationHistory).filter(OperationHistory.patient_id == patient_id).all()

        # 遍历每个操作历史记录，手动关联 initial_eid 和 final_eid 对应的 BasicCheck 数据
        for operation_history in operation_histories:
            if operation_history.initial_eid:
                operation_history.initial_check = db.query(BasicCheck).filter(BasicCheck.eid == operation_history.initial_eid).first()
            if operation_history.final_eid:
                operation_history.final_check = db.query(BasicCheck).filter(BasicCheck.eid == operation_history.final_eid).first()
    
        return operation_histories
        

    def get_all(self, db: Session, skip: int = 0, limit: int = 100):
        return crud_operation_histories.get_all(db, skip, limit)

    def create_operation_history(self, db: Session, operation: OperationHistoryCreate):
        return crud_operation_histories.create(db, operation)


operation_histories_service = OperationHistoryService()