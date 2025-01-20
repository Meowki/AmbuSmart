import os
from dotenv import load_dotenv

# 加载 .env 文件中的环境变量
load_dotenv()

class Config:
    # HuggingFace 配置
    HUGGINGFACE_MODEL_NAME: str = os.getenv("HUGGINGFACE_MODEL_NAME", "Qwen/Qwen2.5-7B-Instruct")
    HUGGINGFACE_API_KEY: str = os.getenv("HUGGINGFACE_API_KEY", "")

    # 数据库配置
    DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///./test.db")

    # 应用配置
    DEBUG: bool = os.getenv("DEBUG", "False").lower() in ("true", "1", "t")

    # 其他配置变量
    # 可以根据需要添加更多变量
    # EXAMPLE_VAR: str = os.getenv("EXAMPLE_VAR", "default_value")
