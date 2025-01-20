import os
import requests
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from transformers import pipeline

load_dotenv()  # 加载 .env 文件

app = FastAPI()

# 配置 CORS 以允许前端访问
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],  # Vue 前端地址
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 定义请求体模型
class Message(BaseModel):
    message: str

# 初始化 HuggingFace 的 pipeline
try:
    generator = pipeline("text-generation", model="Qwen/Qwen-7B-Chat", trust_remote_code=True)
except Exception as e:
    raise RuntimeError(f"初始化模型失败: {e}")

@app.post("/api/chat")
async def chat(message: Message):
    try:
        # 使用 pipeline 生成文本，明确使用 max_new_tokens 控制生成长度
        outputs = generator(message.message, max_new_tokens=512, truncation=True, num_return_sequences=1)
        reply = outputs[0]['generated_text'].strip()
        return {"message": reply}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
