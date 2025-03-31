import React, { useEffect, useState, useRef } from "react";
import { message } from 'antd';

const withAliyunASR = (WrappedComponent) => (props) => {
  const [interimText, setInterimText] = useState('');
  const wsRef = useRef(null);
  const mediaStreamRef = useRef(null);
  const audioContextRef = useRef(null);
  const processorRef = useRef(null);

  // 合并识别结果到主输入框
  useEffect(() => {
    if (props.value !== interimText) {
      props.onChange?.(props.value + interimText);
    }
  }, [interimText]);

  // 处理录音状态变化
  const handleRecordingChange = async (nextRecording) => {
    try {
      if (nextRecording) {
        // 初始化录音
        const stream = await navigator.mediaDevices.getUserMedia({ 
          audio: { 
            sampleRate: 16000,
            channelCount: 1,
            noiseSuppression: true 
          }
        });
        
        // 初始化WebSocket
        wsRef.current = new WebSocket('wss://localhost:8000/api/audio/stream');
        
        // 配置音频处理
        const audioContext = new (window.AudioContext || window.webkitAudioContext)({
          sampleRate: 16000
        });
        
        const source = audioContext.createMediaStreamSource(stream);
        const processor = audioContext.createScriptProcessor(4096, 1, 1);

        processor.onaudioprocess = (e) => {
          if (wsRef.current?.readyState === WebSocket.OPEN) {
            const pcmData = convertFloat32ToInt16(e.inputBuffer.getChannelData(0));
            wsRef.current.send(pcmData);
          }
        };

        // 处理识别结果
        wsRef.current.onmessage = (event) => {
          const data = JSON.parse(event.data);
          if (data.type === 'partial') {
            setInterimText(data.text);
          } else if (data.type === 'final') {
            props.onChange?.(props.value + data.text + ' ');
            setInterimText('');
          }
        };

        source.connect(processor);
        processor.connect(audioContext.destination);

        mediaStreamRef.current = stream;
        audioContextRef.current = audioContext;
        processorRef.current = processor;
        message.info('录音开始');
      } else {
        // 停止录音
        mediaStreamRef.current?.getTracks().forEach(track => track.stop());
        audioContextRef.current?.close();
        processorRef.current?.disconnect();
        wsRef.current?.close();
        message.info('录音结束');
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
      value={props.value + interimText}
      allowSpeech={mergedAllowSpeech}
    />
  );
};

export default withAliyunASR;