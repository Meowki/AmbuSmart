import openai
import os
import logging
from sqlalchemy.orm import Session
from crud.chat import create_chat_record, get_chat_history
from openai import OpenAI
from utils.prompts import get_prompt

# 设置日志
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# 读取 OpenAI API 配置
openai.api_key = os.getenv("DASHSCOPE_API_KEY")
openai.api_base = "https://dashscope.aliyuncs.com/compatible-mode/v1"

async def chat_with_ai(db: Session, operation_id: int, message: str):
    try:
        logger.info(f"用户输入：{message} (operation_id: {operation_id})")

        client = OpenAI(
            api_key=os.getenv("DASHSCOPE_API_KEY"),
            base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
        )

        # 获取当前 `operation_id` 相关的对话历史
        chat_history = get_chat_history(db, operation_id)

        # 获取 AI 系统 Prompt
        system_prompt = get_prompt()  # 统一管理的 Prompt
        
         # 如果没有历史记录，初始化会话
        if not chat_history:
            logger.info(f"operation_id {operation_id} 是新的会话，初始化对话")
            messages = [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": message}  # 第一轮用户输入
            ]
        else:
            # 如果有历史记录，加载历史对话
            logger.info(f"operation_id {operation_id} 载入历史记录")
            messages = [{"role": "system", "content": system_prompt}]
            for chat in chat_history:
                messages.append({"role": "user", "content": chat.user_message})
                messages.append({"role": "assistant", "content": chat.ai_response})

            # 追加当前用户输入
            messages.append({"role": "user", "content": message})

        # 调用 AI 获取回复
        completion = client.chat.completions.create(
            model="qwen-max-0125",
            messages=messages,
        )

        ai_response = completion.choices[0].message.content
        logger.info(f"AI 回复: {ai_response}")

        # 存入数据库
        chat_record = create_chat_record(db, operation_id, message, ai_response)

        return {"operation_id": operation_id, "response": ai_response}

    except openai.OpenAIError as oe:
        logger.error(f"OpenAI API 错误: {oe}")
        return {"error": f"OpenAI API 错误: {str(oe)}"}

    except Exception as e:
        logger.exception("未知错误")
        return {"error": f"未知错误: {str(e)}"}