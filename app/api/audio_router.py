import os
import asyncio
import dashscope
from dashscope.audio.asr import Recognition, RecognitionCallback
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from fastapi.responses import HTMLResponse
from starlette.websockets import WebSocketState
from dotenv import load_dotenv
import logging

load_dotenv()
dashscope.api_key = os.getenv("DASHSCOPE_API_KEY")

audio_router = APIRouter(prefix="/audio", tags=["Audio"])

# 配置日志记录
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

class WebSocketCallback(RecognitionCallback):
    def __init__(self, websocket: WebSocket):
        super().__init__()
        self.websocket = websocket
        self.loop = asyncio.get_event_loop()
        self.active = True  # 连接状态标志

    def on_open(self) -> None:
        """同步回调转换为异步任务"""
        self.loop.create_task(self._async_on_open())

    async def _async_on_open(self):
        logger.info("ASR connection opened")
        try:
            if self.websocket.client_state == WebSocketState.CONNECTED:
                await self.websocket.send_text("RECORDING_START")
                logger.info("成功发送 RECORDING_START")
        except Exception as e:
            logger.error(f"发送 RECORDING_START 失败: {str(e)}")

    def on_event(self, result) -> None:
        """事件处理桥接"""
        if self.active:
            self.loop.create_task(self._async_on_event(result))

    async def _async_on_event(self, result):
        try:
            sentence = result.get_sentence()
            if sentence and 'text' in sentence:
                text = sentence['text'].strip()
                if text:
                    logger.debug(f"识别到文本: {text}")
                    
                    # 发送中间结果
                    await self.websocket.send_json({
                        "type": "partial",
                        "text": text
                    })
                    
                    # 发送最终结果
                    if result.is_sentence_end(sentence):
                        await self.websocket.send_json({
                            "type": "final",
                            "text": text
                        })
        except WebSocketDisconnect:
            self.active = False
            logger.warning("客户端连接已断开")
        except Exception as e:
            logger.error(f"处理识别结果异常: {str(e)}")

    def on_error(self, message) -> None:
        """错误处理桥接"""
        self.loop.create_task(self._async_on_error(message))

    async def _async_on_error(self, message):
        error_msg = f"ASR Error: {message.message}"
        logger.error(error_msg)
        try:
            if self.websocket.client_state == WebSocketState.CONNECTED:
                await self.websocket.send_json({
                    "type": "error",
                    "message": error_msg
                })
        except Exception as e:
            logger.error(f"发送错误信息失败: {str(e)}")

    def on_close(self) -> None:
        """关闭连接桥接"""
        self.loop.create_task(self._async_on_close())

    async def _async_on_close(self):
        self.active = False
        logger.info("ASR connection closing...")
        try:
            if self.websocket.client_state == WebSocketState.CONNECTED:
                await self.websocket.send_text("RECORDING_STOP")
                logger.info("成功发送 RECORDING_STOP")
        except Exception as e:
            logger.error(f"发送 RECORDING_STOP 失败: {str(e)}")
        finally:
            logger.info("ASR连接已完全关闭")

@audio_router.websocket("/stream")
async def audio_stream(websocket: WebSocket):
    await websocket.accept()
    logger.info("客户端已连接")
    
    recognition = None
    callback = None
    
    try:
        # 初始化语音识别
        callback = WebSocketCallback(websocket)
        recognition = Recognition(
            model='paraformer-realtime-v2',
            format='pcm',
            sample_rate=16000,
            callback=callback
        )
        
        # 启动识别服务
        recognition.start()

        # 实时处理音频流
        while True:
            audio_data = await websocket.receive_bytes()
            logger.debug(f"接收到音频数据: {len(audio_data)} bytes")
            
            # 动态音频校验（兼容不同帧长度）
            if len(audio_data) % 3200 != 0:
                logger.warning(f"非标准帧长度: {len(audio_data)}，尝试继续处理")
                
            try:
                recognition.send_audio_frame(audio_data)
            except RuntimeError as e:
                logger.error(f"发送音频失败: {str(e)}")
                break

    except WebSocketDisconnect:
        logger.info("客户端主动断开连接")
    except Exception as e:
        logger.error(f"处理音频流时出现错误: {str(e)}")
        try:
            await websocket.send_json({
                "type": "error",
                "message": str(e)
            })
        except:
            pass
    finally:
        if recognition:
            recognition.stop()
        if callback:
            await callback._async_on_close()
        logger.info("语音识别服务已终止")

# 修正后的测试页面（关键前端适配）
@audio_router.get("/demo", response_class=HTMLResponse)
def demo_page():
    return """
    <html>
        <body>
            <button onclick="startRecording()">开始录音</button>
            <button onclick="stopRecording()">停止</button>
            <div id="result"></div>
            <script>
                let mediaRecorder;
                const socket = new WebSocket('ws://localhost:8000/audio/stream');
                
                // 新增音频处理上下文
                const audioContext = new (window.AudioContext || window.webkitAudioContext)({
                    sampleRate: 16000
                });

                socket.onmessage = (event) => {
                    const data = JSON.parse(event.data);
                    if(data.type === 'partial') {
                        document.getElementById('result').innerHTML = data.text;
                    }
                };

                async function startRecording() {
                    const stream = await navigator.mediaDevices.getUserMedia({ 
                        audio: {
                            sampleRate: 16000,
                            channelCount: 1
                        } 
                    });
                    
                    // 新增音频处理节点
                    const source = audioContext.createMediaStreamSource(stream);
                    const processor = audioContext.createScriptProcessor(4096, 1, 1);
                    
                    source.connect(processor);
                    processor.connect(audioContext.destination);

                    mediaRecorder = new MediaRecorder(stream);
                    
                    // 实时转换PCM格式（关键修复）
                    processor.onaudioprocess = (e) => {
                        const input = e.inputBuffer.getChannelData(0);
                        const pcm = new Int16Array(input.length);
                        for (let i = 0; i < input.length; i++) {
                            pcm[i] = input[i] * 32767;
                        }
                        socket.send(pcm.buffer);
                    };

                    mediaRecorder.start();
                }

                function stopRecording() {
                    mediaRecorder?.stop();
                    audioContext.close();
                }
            </script>
        </body>
    </html>
    """