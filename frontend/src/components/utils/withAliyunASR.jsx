import React, { useEffect, useState, useRef } from "react";
import { message } from "antd";

// HOC：withAliyunASR
const withAliyunASR = (WrappedComponent) => (props) => {
  const [interimText, setInterimText] = useState('');  // 用于存储实时识别的文本
  const [finalText, setFinalText] = useState('');      // 用于存储最终的识别结果
  const wsRef = useRef(null);
  const mediaStreamRef = useRef(null);
  const audioContextRef = useRef(null);
  const processorRef = useRef(null);

  // 合并实时文本和最终文本
  // useEffect(() => {
  //   if (finalText || interimText) {
  //     props.onChange?.(finalText + " " + interimText);  // 实时更新最终显示的文本
  //   }
  // }, [interimText, finalText]);

  // useEffect(() => {
  //   if (finalText || interimText) {
  //     props.onChange?.((prev) => (prev || '') + ' ' + finalText + ' ' + interimText);
  //   }
  // }, [interimText, finalText]);
  useEffect(() => {
    if (finalText) {
      props.onChange?.((prev) => (prev || '') + ' ' + finalText);
      setFinalText(''); // append 之后立即清空，避免反复追加
    }
  }, [finalText]);
  


  // 处理录音状态变化
  const handleRecordingChange = async (nextRecording) => {
    try {
      console.log(`handleRecordingChange: ${nextRecording ? "开始录音" : "停止录音"}`);
      
      if (nextRecording) {
        // 初始化录音
        console.log("请求麦克风权限...");
        const stream = await navigator.mediaDevices.getUserMedia({
          audio: {
            sampleRate: 16000,
            channelCount: 1,
            noiseSuppression: true,
          },
        });
        console.log("麦克风已连接");

        // 初始化WebSocket
        if (!wsRef.current || wsRef.current.readyState !== WebSocket.OPEN) {
          console.log("尝试连接到WebSocket...");
          wsRef.current = new WebSocket('ws://localhost:8000/api/audio/stream');

          wsRef.current.onopen = () => {
            console.log("WebSocket连接成功");
          };

          wsRef.current.onerror = (error) => {
            console.error("WebSocket连接错误:", error);
            message.error("WebSocket连接失败");
          };

          wsRef.current.onclose = (event) => {
            console.log("WebSocket连接关闭", event);
          };
        }

        // 配置音频处理
        const audioContext = new (window.AudioContext || window.webkitAudioContext)({
          sampleRate: 16000,
        });

        const source = audioContext.createMediaStreamSource(stream);
        const processor = audioContext.createScriptProcessor(4096, 1, 1);

        processor.onaudioprocess = (e) => {
          if (wsRef.current?.readyState === WebSocket.OPEN) {
            const pcmData = convertFloat32ToInt16(e.inputBuffer.getChannelData(0));
            wsRef.current.send(pcmData);
            console.log("音频数据已发送");
          } else {
            console.log("WebSocket尚未连接或已关闭");
          }
        };

        // 处理识别结果
        wsRef.current.onmessage = (event) => {
          console.log("接收到 WebSocket 消息:", event.data);  // 输出原始数据，帮助调试

          try {
            const data = JSON.parse(event.data);  // 尝试解析JSON数据

            // 处理 `partial` 类型的消息：实时更新中间文本
            if (data && data.type === 'partial') {
              setInterimText(data.text);  // 更新实时文本
              console.log("实时识别文本:", data.text);  // 输出实时识别文本
            }

            // 处理 `final` 类型的消息：累加最终文本
            else if (data && data.type === 'final') {
              setFinalText((prevText) => prevText + " " + data.text);  // 累加最终文本
              setInterimText('');  // 清空中间文本
              console.log("最终识别文本:", data.text);  // 输出最终识别文本
            } else {
              console.log("未处理的数据类型:", data);  // 处理其他类型的数据
            }
          } catch (error) {
            // 处理非 JSON 格式的数据
            console.log("接收到非JSON消息:", event.data);
          }
        };

        source.connect(processor);
        processor.connect(audioContext.destination);

        mediaStreamRef.current = stream;
        audioContextRef.current = audioContext;
        processorRef.current = processor;
        message.info('录音开始');
        console.log("音频流处理器已启动");
      } else {
        // 停止录音
        console.log("停止录音...");
        if (mediaStreamRef.current) {
          mediaStreamRef.current.getTracks().forEach(track => track.stop());
        }
        audioContextRef.current?.close();
        processorRef.current?.disconnect();

        // 确保 WebSocket 关闭
        if (wsRef.current) {
          wsRef.current.close();
          console.log("WebSocket已关闭");
        }

        message.info('录音结束');
        console.log("录音已停止，WebSocket连接关闭");
      }
    } catch (error) {
      console.error('录音错误:', error);
      message.error('无法启动录音');
    }
  };

  // 音频格式转换
  const convertFloat32ToInt16 = (buffer) => {
    const int16Buffer = new Int16Array(buffer.length);
    for (let i = 0; i < buffer.length; i++) {
      int16Buffer[i] = Math.min(1, buffer[i]) * 0x7FFF;
    }
    return int16Buffer.buffer;
  };

  // 合并原有allowSpeech配置
  const mergedAllowSpeech = {
    ...props.allowSpeech,
    onRecordingChange: (nextRecording) => {
      props.allowSpeech?.onRecordingChange?.(nextRecording);
      handleRecordingChange(nextRecording);
    }
  };

  return (
    <WrappedComponent
  {...props}
  value={props.value + (interimText ? ' ' + interimText : '')}
  allowSpeech={mergedAllowSpeech}
  />
  );
};

export default withAliyunASR;
