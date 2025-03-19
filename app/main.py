import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
# from api import chat_router, users
# from api import users
from core.logger import setup_logger
from core.config import Config
from api.patient.patient_routers import router as patient_routers
from api.patient.allergy_routers import router as allergy_routers
from api.patient.medical_history_routers import router as medical_history_routers
from api.personnel.department_routers import router as department_routers
from api.personnel.health_personnel_router import router as health_personnel_routers    
from api.record.medical_record_routers import router as medical_record_routers
from api.record.case_history_routers import router as case_history_routers
from api.check.check_routers import router as check_routers
from api.check.check_histories_routers import router as check_histories_routers
from api.medicine.medicine_routers import router as medicine_routers
from api.medicine.medicine_histories_routers import router as medicine_histories_routers
from api.ambulance.ambulance_routers import router as ambulance_routers
from api.ambulance.basic_check_routers import router as basic_check_routers
from api.ambulance.operation_histories_routers import router as operation_history_routers
from api.chat_router import chat_router


from db.base import Base
from db.session import engine

app = FastAPI(
    title="医疗项目API",
    # 其他参数...
)

# 配置 CORS 以允许前端访问
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],  # Vue 前端地址
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 配置日志记录
logging.basicConfig(level=logging.DEBUG)
logger = setup_logger("chat_app")
logger.info("应用启动中...")

# 包含所有路由
# app.include_router(chat_router, prefix="/api")
# app.include_router(users.router, prefix="/api")
app.include_router(patient_routers, prefix="/api")
app.include_router(allergy_routers, prefix="/api")
app.include_router(medical_history_routers, prefix="/api")

app.include_router(department_routers, prefix="/api")
app.include_router(health_personnel_routers, prefix="/api")

app.include_router(medical_record_routers, prefix="/api")
app.include_router(case_history_routers, prefix="/api")

app.include_router(check_routers, prefix="/api")
app.include_router(check_histories_routers, prefix="/api")

app.include_router(medicine_routers, prefix="/api")
app.include_router(medicine_histories_routers, prefix="/api")

# app.include_router(ambulance_routers, prefix="/api")
app.include_router(basic_check_routers, prefix="/api")
app.include_router(operation_history_routers, prefix="/api")

# 注册 AI 对话 API
app.include_router(chat_router, prefix="/api")


# 记录应用启动事件
# @app.on_event("startup")
# def startup_event():
#     logger.info("Chat 应用已启动")


@app.get("/")
def read_root():
    return {"message": "欢迎使用 AmbuSmart API"}
