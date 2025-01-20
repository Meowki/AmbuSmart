import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import chat_router  # 导入路由
from utils.logger import setup_logger
from utils.config import Config

app = FastAPI()

# 配置 CORS 以允许前端访问
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],  # Vue 前端地址
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 配置日志记录
logger = setup_logger("chat_app")
logger.info("应用启动中...")

# 包含所有路由
app.include_router(chat_router, prefix="/api")

# 记录应用启动事件
@app.on_event("startup")
def startup_event():
    logger.info("Chat 应用已启动")

# 你可以在这里包含更多的路由，例如：
# from routers import other_router
# app.include_router(other_router, prefix="/api")
