import asyncio
import json
import os
import logging
from typing import AsyncGenerator
from fastapi import HTTPException, Request
from sqlalchemy.orm import Session
from openai import AsyncOpenAI
from crud.chat import create_chat_record, get_chat_history, get_operation_data, get_patient_history
from models.operation_history import OperationHistory
from utils.prompts import get_prompt_by_type

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# 1. 根据患者目前情况总结出初步诊断
# 2. 根据历史记录获取急救处理和用药记录
# 3. 生成最终急救结果
# ---> 添加prompt key

async def chat_with_ai(
    db: Session,
    request: Request,
    operation_id: int,
    message: str,
    prompt_type: str,
    abort_queue: asyncio.Queue
) -> AsyncGenerator[str, None]:
    logger.info(f"🎬 开始处理操作 {operation_id}")

    operation = db.query(OperationHistory).filter(OperationHistory.operation_id == operation_id).first()
    patient_id = operation.patient_id if operation and operation.patient_id else None
    
    # 初始化 OpenAI 客户端
    client = AsyncOpenAI(
        api_key=os.getenv("DASHSCOPE_API_KEY"),
        base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
    )

    # 获取操作记录
    operation = db.query(OperationHistory).filter(
        OperationHistory.operation_id == operation_id
    ).first()
    if not operation:
        yield "event: error\ndata: 操作记录不存在\n\n"
        return

    # 准备数据
    chat_history = get_chat_history(db, operation_id)
    system_prompt = get_prompt_by_type(prompt_type) 
    logger.info(f"使用的prompt: operation_id={prompt_type}")
    operation_data = get_operation_data(db, operation_id)
    formatted_data = format_patient_data(db, operation_data, patient_id, prompt_type)
    
     # 如果没有历史记录，初始化会话
    if not chat_history:
        logger.info(f"operation_id {operation_id} 是新的会话，初始化对话")
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "system", "content": formatted_data},  # 传递患者及急救相关数据
            {"role": "user", "content": message}  # 第一轮用户输入
        ]
    else:
         # 如果有历史记录，加载历史对话
        logger.info(f"operation_id {operation_id} 载入历史记录")
        messages = [{"role": "system", "content": system_prompt}]
        messages.append({"role": "system", "content": formatted_data})  # 传递急救数据
        for chat in chat_history:
            messages.append({"role": "user", "content": chat.user_message})
            messages.append({"role": "assistant", "content": chat.ai_response})

        # 追加当前用户输入
        messages.append({"role": "user", "content": message})
    
    logger.info(f"[BACKEND] 生成消息 {messages}")

    # 创建监听任务
    abort_flag = asyncio.Event()
    disconnect_flag = asyncio.Event()
    
    async def watch_abort():
        try:
            while True:
                signal = await abort_queue.get()
                if signal == "ABORT":
                    logger.info(f"🔴 收到终止信号 {operation_id}")
                    abort_flag.set()
                    break
                if signal is StopAsyncIteration:
                    return
        except Exception as e:
            logger.error(f"中止监听异常: {str(e)}")

    async def watch_disconnect():
        try:
            while not abort_flag.is_set():
                if await request.is_disconnected():
                    logger.info(f"🔌 客户端断开连接 {operation_id}")
                    disconnect_flag.set()
                    break
                await asyncio.sleep(0.1)
        except Exception as e:
            logger.error(f"连接监听异常: {str(e)}")

    # 启动监听任务
    abort_task = asyncio.create_task(watch_abort())
    disconnect_task = asyncio.create_task(watch_disconnect())

    try:
        # 发送AI请求
        completion = await client.chat.completions.create(
            model="qwen-max-0125",
            messages=messages,
            stream=True,
        )

        # 处理响应流
        full_response = ""
        async for chunk in completion:
            # 检查终止条件
            if abort_flag.is_set() or disconnect_flag.is_set():
                logger.warning(f"⏹️ 终止生成 {operation_id}")
                yield "event: abort\ndata: 操作已终止\n\n"
                break

            # 处理有效响应
            if chunk.choices and chunk.choices[0].delta.content:
                content = chunk.choices[0].delta.content
                full_response += content
                yield f"data: {json.dumps({'response': content}, ensure_ascii=False)}\n\n"
                await asyncio.sleep(0.03)  # 控制流速度

        # 保存记录（仅在正常完成时）
        if not (abort_flag.is_set() or disconnect_flag.is_set()):
            await save_chat_record(db, operation_id, message, full_response)
            logger.info(f"💾 保存聊天记录 {operation_id}")

    except Exception as e:
        logger.error(f"AI处理异常: {str(e)}")
        yield f"event: error\ndata: {str(e)}\n\n"
    finally:
        # 清理资源
        logger.debug(f"🧹 清理资源 {operation_id}")
        abort_flag.set()
        abort_task.cancel()
        disconnect_task.cancel()
        await asyncio.gather(
            abort_task,
            disconnect_task,
            return_exceptions=True
        )
        logger.info(f"✅ 完成操作 {operation_id}")

# 生成格式化的患者数据
def format_patient_data(db: Session, operation_data: dict, patient_id:str, prompt_type: str) -> str:

    logger.info(f"[BACKEND] 获取 propmt {prompt_type} 的数据")
    if prompt_type == "patient_basic_analysis" and patient_id:
        logger.info(f"[BACKEND] 获取患者 {patient_id} 的历史数据")
        patient_data = get_patient_history(db, patient_id)
        if not patient_data:
            raise HTTPException(status_code=404, detail="无法获取患者历史数据")
        return json.dumps(patient_data, ensure_ascii=False)

    return f"""
    患者信息：{operation_data['patient_info']}
    主诉：{operation_data['chief_complaint']}
    急救类型：{operation_data['emergency_type']}，病情分级：{operation_data['severity_level']}
    初步诊断：{operation_data['initial_diagnosis']}
    处理措施：{operation_data['procedures']}，用药情况：{operation_data['medicine']}
    初检：{operation_data['initial_check']}
    终检：{operation_data['final_check']}
    TI 评分：{operation_data['ti_content']}
    GCS 评分：{operation_data['gcs_score']}，内容：{operation_data['gcs_content']}
    Killip 分级：{operation_data['Killip_score']}，内容：{operation_data['Killip_content']}，诊断：{operation_data['Killip_diagnosis']}
    脑卒中评估：{operation_data['cerebral_stroke_content']}
    """

# 异步保存聊天记录
async def save_chat_record(db: Session, operation_id: int, message: str, response: str):
    try:
        loop = asyncio.get_event_loop()
        await loop.run_in_executor(None, lambda: create_chat_record(db, operation_id, message, response))
    except Exception as e:
        logger.error(f"[BACKEND] 保存聊天记录失败: {str(e)}")
