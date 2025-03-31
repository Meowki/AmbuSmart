import os
import dashscope
from dashscope.audio.asr import *
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from dotenv import load_dotenv
import logging

load_dotenv()
dashscope.api_key = os.getenv("DASHSCOPE_API_KEY")

audio_router = APIRouter(prefix="/audio", tags=["Audio"])

class WebSocketCallback(RecognitionCallback):
    def __init__(self, websocket: WebSocket):
        super().__init__()
        self.websocket = websocket
        self.logger = logging.getLogger(__name__)

    async def on_open(self) -> None:
        self.logger.info("ASR connection opened")
        await self.websocket.send_text("RECORDING_START")

    async def on_close(self) -> None:
        self.logger.info("ASR connection closed")
        await self.websocket.send_text("RECORDING_STOP")

    async def on_event(self, result: RecognitionResult) -> None:
        sentence = result.get_sentence()
        if sentence and 'text' in sentence:
            text = sentence['text'].strip()
            if text:
                await self.websocket.send_json({
                    "type": "partial",
                    "text": text
                })
                if RecognitionResult.is_sentence_end(sentence):
                    await self.websocket.send_json({
                        "type": "final",
                        "text": text
                    })

    async def on_error(self, message) -> None:
        error_msg = f"ASR Error: {message.message}"
        self.logger.error(error_msg)
        await self.websocket.send_json({
            "type": "error",
            "message": error_msg
        })

@audio_router.websocket("/stream")
async def audio_stream(websocket: WebSocket):
    await websocket.accept()
    
    try:
        # 初始化语音识别
        callback = WebSocketCallback(websocket)
        recognition = Recognition(
            model='paraformer-realtime-v2',
            format='pcm',
            sample_rate=16000,
            callback=callback
        )
        
        recognition.start()
        await callback.on_open()

        # 实时处理音频流
        while True:
            audio_data = await websocket.receive_bytes()
            recognition.send_audio_frame(audio_data)

    except WebSocketDisconnect:
        logging.info("Client disconnected")
    except Exception as e:
        logging.error(f"Unexpected error: {str(e)}")
        await websocket.send_json({
            "type": "error",
            "message": str(e)
        })
    finally:
        recognition.stop()
        await callback.on_close()