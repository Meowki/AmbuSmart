# from fastapi import APIRouter, HTTPException
# from models.message import Message
# from services.gpt_service import get_gpt_response
# from utils.logger import setup_logger

# router = APIRouter()
# logger = setup_logger("chat_app")

# @router.post("/chat")
# async def chat(message: Message):
#     user_message = message.message
#     logger.info(f"收到用户消息: {user_message}")  # 记录用户输入
    
#     try:
#         reply = get_gpt_response(user_message)
#         logger.info(f"生成模型回复: {reply}")  # 记录模型回复
#         return {"message": reply}
#     except Exception as e:
#         logger.error(f"处理消息时出错: {e}")  # 记录错误信息
#         raise HTTPException(status_code=500, detail="内部服务器错误")
