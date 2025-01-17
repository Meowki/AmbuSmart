from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# 配置 CORS 以允许前端访问
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],  # Vue 前端地址
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/message")
async def get_message():
    return {"message": "Hello from FastAPI!"}