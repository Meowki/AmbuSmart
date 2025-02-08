from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class OperationHistoryBase(BaseModel):
    patient_id: Optional[str] = None
    informant: Optional[str] = None
    scene_address: Optional[str] = None
    dispatch_time: Optional[datetime] = None
    arrival_on_scene_time: Optional[datetime] = None
    departure_from_scene_time: Optional[datetime] = None
    arrival_at_hospital_time: Optional[datetime] = None
    destination: Optional[str] = None
    severity_level: Optional[str] = None
    emergency_type: Optional[str] = None
    chief_complaint: Optional[str] = None
    initial_diagnosis: Optional[str] = None
    procedures: Optional[str] = None
    medicine: Optional[str] = None
    outcome: Optional[str] = None
    physician: Optional[str] = None
    nurse: Optional[str] = None
    driver: Optional[str] = None
    paramedic: Optional[str] = None
    stretcher_bearer: Optional[str] = None
    recipient: Optional[str] = None
    initial_eid: Optional[int] = None
    final_eid: Optional[int] = None
    ti_score: Optional[str] = None
    ti_content: Optional[str] = None
    gcs_score: Optional[str] = None
    gcs_content: Optional[str] = None
    Killip_score: Optional[str] = None
    Killip_content: Optional[str] = None
    Killip_diagnosis: Optional[str] = None
    cerebral_stroke_content: Optional[str] = None

class OperationHistoryCreate(OperationHistoryBase):
    pass

class OperationHistory(OperationHistoryBase):
    operation_id: int

    class Config:
        orm_mode = True
