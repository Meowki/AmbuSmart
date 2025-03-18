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
        # 若没有配置环境变量，请用百炼API Key将下行替换为：api_key="sk-xxx",
            api_key=os.getenv("DASHSCOPE_API_KEY"), 
            base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
        )
        completion = client.chat.completions.create(
            model="qwen-max-0125", # 此处以qwen-plus为例，可按需更换模型名称。模型列表：https://help.aliyun.com/zh/model-studio/getting-started/models
            messages=[
                {'role': 'system', 'content': 'You are a helpful assistant.'},
                {'role': 'user', 'content': '你是谁？'}],
            )
        
        print(completion.model_dump_json())

        # response = await openai.chat.completions.create(
        #      model="qwen-plus",     
        #      messages=[
        #         {'role': 'system', 'content': 'You are a helpful assistant.'},
        #         {'role': 'user', 'content': '你是谁？'}],
        #     )

        # ai_response = response["choices"][0]["message"]["content"]
        # logger.info(f" AI 返回：{ai_response}")

        # 存入数据库
        # chat_record = create_chat_record(db, operation_id, message, ai_response)

        # return {"operation_id": chat_record.operation_id, "response": ai_response}
        return { "response": completion.model_dump_json()}
    
    except openai.OpenAIError as oe:
        logger.error(f"OpenAI API 错误: {oe}")
        return {"error": f"OpenAI API 错误: {str(oe)}"}

    except Exception as e:
        logger.exception("未知错误")
        return {"error": f"未知错误: {str(e)}"}
