import torch
from transformers import pipeline, AutoTokenizer, AutoModelForCausalLM
from utils.config import Config
from utils.logger import setup_logger

logger = setup_logger("chat_app")  # 使用与 main.py 中相同的日志记录器

# 初始化模型和分词器
logger.info(f"加载模型: {Config.HUGGINGFACE_MODEL_NAME}")
tokenizer = AutoTokenizer.from_pretrained(Config.HUGGINGFACE_MODEL_NAME)
model = AutoModelForCausalLM.from_pretrained(Config.HUGGINGFACE_MODEL_NAME)

# 如果有GPU可用，使用GPU
device = 0 if torch.cuda.is_available() else -1
logger.info(f"使用设备: {'GPU' if device == 0 else 'CPU'}")

# 初始化文本生成管道
text_generator = pipeline(
    "text-generation",
    model=model,
    tokenizer=tokenizer,
    device=device,
    truncation=True  # 显式启用截断
)

def get_gpt_response(user_message: str) -> str:
    # 构建提示
    prompt = f"User: {user_message}\nAI:"
    logger.info(f"生成提示: {prompt}")

    # 生成回复
    responses = text_generator(
        prompt,
        max_length=150,
        num_return_sequences=1,
        no_repeat_ngram_size=2,
        temperature=0.7,
        top_p=0.9,
        do_sample=True
    )

    # 提取回复文本
    if responses:
        reply = responses[0]['generated_text'].split("AI:")[-1].strip()
        logger.info(f"生成回复: {reply}")
        return reply
    else:
        logger.warning("模型未生成回复")
        return "抱歉，我无法生成回复。"
