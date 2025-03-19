import openai
import os
import logging
from sqlalchemy.orm import Session
from crud.chat import create_chat_record
from openai import OpenAI

# 设置日志
logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger(__name__)


async def chat_with_ai(db: Session, operation_id: int, message: str):
    try:
        logger.info(f"发送 AI 请求：{message}")

        client = OpenAI(
            api_key=os.getenv("DASHSCOPE_API_KEY"), 
            base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
        )

        completion = client.chat.completions.create(
            model="qwen-max-0125", 
            messages=[
                {'role': 'system', 'content': '你是一个专业的医疗急救助手，请根据用户的问题提供帮助。'},
                {'role': 'user', 'content': message}  
            ],
        )

        ai_response = completion.choices[0].message.content  
        logger.info(f"AI 返回：{ai_response}")

        return { "operation_id": operation_id, "response": ai_response }

    except openai.OpenAIError as oe:
        logger.error(f"OpenAI API 错误: {oe}")
        return {"error": f"OpenAI API 错误: {str(oe)}"}

    except Exception as e:
        logger.exception("未知错误")
        return {"error": f"未知错误: {str(e)}"}
