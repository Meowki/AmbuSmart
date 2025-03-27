import asyncio
import json
from fastapi import HTTPException, Request
from fastapi.encoders import jsonable_encoder
import openai
import os
import logging
from sqlalchemy.orm import Session
from crud.chat import create_chat_record, get_chat_history, get_operation_data, get_patient_history
from models.operation_history import OperationHistory
from openai import AsyncOpenAI, OpenAI
from utils.prompts import get_prompt_by_type

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

openai.api_key = os.getenv("DASHSCOPE_API_KEY")
openai.api_base = "https://dashscope.aliyuncs.com/compatible-mode/v1"

async def chat_with_ai(db: Session, request: Request, operation_id: int, message: str, prompt_type: str):
    operation = db.query(OperationHistory).filter(OperationHistory.operation_id == operation_id).first()
    patient_id = operation.patient_id if operation and operation.patient_id else None
    client = None
    disconnect_task = None
    stream_completed = False  # 新增流完成标记

    try:
        logger.info(f"[BACKEND] 收到请求: operation_id={operation_id}, prompt_type={prompt_type}")

        # 初始化客户端
        client = AsyncOpenAI(
            api_key=os.getenv("DASHSCOPE_API_KEY"),
            base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
        )

        should_abort = asyncio.Event()

        # 增强版连接监听
        async def watch_disconnect():
            logger.debug("[BACKEND] 启动连接状态监听器")
            while not should_abort.is_set() and not stream_completed:
                try:
                    # 实时连接检查
                    if await request.is_disconnected():
                        logger.warning("[BACKEND] 🔴 检测到客户端断开连接!")
                        should_abort.set()
                        break
                    await asyncio.sleep(0.3)  # 300ms检测间隔
                except Exception as e:
                    logger.error(f"[BACKEND] 监听异常: {str(e)}")
                    break
            logger.debug("[BACKEND] 退出连接监听")

        disconnect_task = asyncio.create_task(watch_disconnect())


        # 1. 根据患者目前情况总结出初步诊断
        # 2. 根据历史记录获取急救处理和用药记录
        # 3. 生成最终急救结果
        # ---> 添加prompt key

         # 获取当前 `operation_id` 相关的对话历史和急救数据
        chat_history = get_chat_history(db, operation_id)
        operation_data = get_operation_data(db, operation_id)

        # 统一管理 Prompt
        system_prompt = get_prompt_by_type(prompt_type) 
        logger.info(f"使用的prompt: operation_id={prompt_type}")


         # 特殊逻辑：患者基础分析 prompt
        if prompt_type == "patient_basic_analysis" and patient_id:
            logger.info(f"operation_id {operation_id} 是患者基础分析场景")
            patient_data = get_patient_history(db, patient_id)

            if patient_data:
                formatted_data = json.dumps(patient_data, ensure_ascii=False)
            else:
                raise HTTPException(status_code=404, detail="无法获取患者历史数据")
        else:
            # 其他所有场景
            formatted_data = f"""
            患者基本信息：{operation_data['patient_info']}, 
            主诉：{operation_data['chief_complaint']}。
            急救类型：{operation_data['emergency_type']}，病情分级：{operation_data['severity_level']}。
            初步诊断：{operation_data['initial_diagnosis']}，急救处理：{operation_data['procedures']}，用药：{operation_data['medicine']}。
            初检：{operation_data['initial_check']}
            终检：{operation_data['final_check']}
            TI 内容：{operation_data['ti_content']}
            GCS 评分：{operation_data['gcs_score']}，GCS 内容：{operation_data['gcs_content']}
            Killip 分级：{operation_data['Killip_score']}，Killip 内容：{operation_data['Killip_content']}，Killip 诊断：{operation_data['Killip_diagnosis']}
            脑卒中评估：{operation_data['cerebral_stroke_content']}
            """
        
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

        # 调用 AI 接口
        logger.debug(f"[BACKEND] 开始调用AI接口，prompt长度: {len(str(messages))}")
        completion = await client.chat.completions.create(
            model="qwen-max-0125",
            messages=messages,
            stream=True,
        )

        # 流处理
        full_response = ""
        # if operation_id in abort_requests:
        #     abort_requests.remove(operation_id)
        #     logger.warning(f"[BACKEND] 请求已被标记为终止 operation_id={operation_id}")
        #     yield f"data: {json.dumps({'error': '请求已终止'})}\n\n"
        #     return
        
        async for chunk in completion:
            if should_abort.is_set():
                logger.warning("[BACKEND] ⚠️ 收到终止信号，中止流式传输")
                break

            if chunk.choices and chunk.choices[0].delta.content:
                content = chunk.choices[0].delta.content
                full_response += content
                logger.debug(f"[BACKEND] 发送数据块 size={len(content)}")
                yield f"data: {json.dumps({'response': content}, ensure_ascii=False)}\n\n"
                await asyncio.sleep(0.03)

        stream_completed = True

        # 数据库存储 (仅在正常完成时保存)
        if not should_abort.is_set():
            logger.info(f"[BACKEND] 准备保存数据，长度: {len(full_response)}")
            await save_chat_record(db, operation_id, message, full_response)
            logger.debug("[BACKEND] 数据保存完成")
        else:
            logger.warning("[BACKEND] 请求已中止，跳过数据保存")

    except Exception as e:
        logger.error(f"[BACKEND] 处理异常: {str(e)}")
        yield f"data: {json.dumps({'error': '处理失败'})}\n\n"
    finally:
        # 资源清理
        if disconnect_task:
            disconnect_task.cancel()
        if client:
            await client.close()
        logger.debug("[BACKEND] 资源清理完成")
    
# 异步保存记录
async def save_chat_record(db: Session, operation_id: int, message: str, response: str):
    try:
        # 假设create_chat_record是同步函数，需用线程池包装
        loop = asyncio.get_event_loop()
        await loop.run_in_executor(
            None, 
            lambda: create_chat_record(db, operation_id, message, response)
        )
    except Exception as e:
        logger.error(f"异步保存失败: {str(e)}")