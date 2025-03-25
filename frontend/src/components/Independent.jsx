/* eslint-disable no-unused-vars */
import {
  Attachments,
  Bubble,
  Prompts,
  Sender,
  useXAgent,
  useXChat,
} from "@ant-design/x";
import { createStyles } from "antd-style";
import React, { useEffect, useState } from "react";
import {
  PaperClipOutlined,
  UserOutlined,
  RobotOutlined,
  MedicineBoxOutlined,
  FileDoneOutlined,
  HeartOutlined,
  PlusCircleOutlined,
} from "@ant-design/icons";
import { Avatar, Badge, Button, Typography } from "antd";
import markdownit from "markdown-it";

// 头像与气泡位置
const userAvatar = { color: "#fff", backgroundColor: "#1677ff" }; // 用户头像
const robotAvatar = { color: "#f56a00", backgroundColor: "#fde3cf" }; // AI 头像

// prompts 按钮
const items = [
  {
    key: "initial_diagnosis",
    icon: (<MedicineBoxOutlined style={{ color: "#FF4D4F" }} />),
    label: "初步诊断",
  },
  {
    key: "procedures_medicine_summary",
    icon: (<FileDoneOutlined style={{ color: "#1890FF" }} />),
    label: "整理急救操作与药物记录",
  },
  {
    key: "final_emergency_result",
    icon: (<HeartOutlined style={{ color: "#52C41A" }} />),
    label: "生成最终急救结果总结",
  },
  {
    key: "standard_advice",
    icon: (<PlusCircleOutlined style={{ color: "#FAAD14" }} />),
    label: "快速生成标准急救建议",
  },
];

// 样式定义
const useStyle = createStyles(({ token, css }) => ({
  layout: css`
    width: 100%;
    min-width: 800px;
    height: 550px;
    border-radius: ${token.borderRadius}px;
    display: flex;
    flex-direction: column;
    background: ${token.colorBgContainer};
    font-family: AlibabaPuHuiTi, ${token.fontFamily}, sans-serif;
  `,
  chat: css`
    height: 100%;
    width: 100%;
    max-width: 800px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    padding: 10px;
    gap: 16px;
  `,
  messages: css`
    flex: 1;
    overflow-y: auto;
    padding-bottom: 10px;
  `,
  sender: css`
    box-shadow: ${token.boxShadow};
  `,
}));

// 角色设定
const roles = {
  ai: {
    placement: "start",
    typing: { step: 5, interval: 20 },
    avatar: <Avatar icon={<RobotOutlined />} style={robotAvatar} />,
  },
  user: {
    placement: "end",
    variant: "shadow",
    avatar: <Avatar icon={<UserOutlined />} style={userAvatar} />,
  },
};

const Independent = ({ operationId }) => {
  const { styles } = useStyle();
  const [content, setContent] = useState("");
  const [loading, setLoading] = useState(false);
  const md = markdownit({ html: true, breaks: true });

  const renderMarkdown = (content) => (
    <Typography>
      <div dangerouslySetInnerHTML={{ __html: md.render(content) }} />
    </Typography>
  );

  const [messages, setMessages] = useState([
    {
      role: "ai",
      content: "你好，我是你的医疗 AI 助手，请问有什么需要帮助的吗？",
    },
  ]);
  const [attachedFiles, setAttachedFiles] = useState([]);

  // AI 请求函数
  const requestAI = async ({ message, prompt_type }, { onSuccess, onError }) => {
    let aiResponse = "";
    setLoading(true);

    const payload = {
      operation_id: parseInt(operationId, 10),
      message: message,
      prompt_type: prompt_type || "standard",
    };

    console.log("payload:"+ JSON.stringify(payload));

    try {
      const response = await fetch(`/chat/`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (!response.body) throw new Error("后端无流式返回");

      const reader = response.body.getReader();
      const decoder = new TextDecoder("utf-8");

      // eslint-disable-next-line
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        const chunk = decoder.decode(value, { stream: true });
        const lines = chunk.split("\n\n").filter(Boolean);

        for (const line of lines) {
          if (line.startsWith("data: ")) {
            const jsonStr = line.replace("data: ", "");
            try {
              const data = JSON.parse(jsonStr);
              if (data.response) {
                aiResponse += data.response;
                setMessages((prev) => {
                  const lastMsg = prev[prev.length - 1];
                  return [
                    ...prev.slice(0, -1),
                    { ...lastMsg, content: aiResponse },
                  ];
                });
              }
            } catch (e) {
              console.error("流解析错误:", e);
            }
          }
        }
      }
      onSuccess(aiResponse);
    } catch (error) {
      console.error("API 请求失败:", error);
      onError();
    }
    setLoading(false);
  };

  const [agent] = useXAgent({ request: requestAI });
  const { onRequest } = useXChat({ agent });

  useEffect(() => {
    if (operationId) {
      setMessages([
        {
          role: "ai",
          content: "你好，我是你的医疗 AI 助手，请问有什么需要帮助的吗？",
        },
      ]);
    }
  }, [operationId]);

  const onSubmit = (nextContent) => {
    if (!nextContent) return;
  
    setMessages((prev) => [
      ...prev, 
      { role: "user", content: nextContent },
      { role: "ai", content: "..." },
    ]);
  
    // 确保消息更新完毕后再发送请求
    setTimeout(() => {
      onRequest(nextContent, "standard_advice" );
    }, 0);
  
    setContent("");
  };
  

  // 新增 Prompt 按钮的选择事件
  const onPromptSelect = (item) => {
    const promptType = item.data.key;
    const promptDescription = item.data.label;
  
    if (!operationId) {
      console.error("operationId不存在，无法发送请求");
      return;
    }

    console.log("promptDescription:"+ promptDescription +"promptType:"+ promptType);

    // 1. 先更新用户气泡和AI占位气泡
    setMessages((prev) => [
      ...prev,
      { role: "user", content: promptDescription },
      { role: "ai", content: "..." },
    ]);
  
    // 2. 确保state已更新后再发送请求
    setTimeout(() => {
      onRequest(
        item.data.label,item.data.key,
      );
    }, 0);
  };
  
  
  
  // 暂停键不生效

  const handleFileChange = (info) => setAttachedFiles(info.fileList);
  const attachmentsNode = (
    <Badge dot={attachedFiles.length > 0}>
      <Button type="text" icon={<PaperClipOutlined />} />
    </Badge>
  );

  return (
    <div className={styles.layout}>
      <div className={styles.chat}>
        <Bubble.List
          items={messages.map((msg, index) => ({
            ...msg,
            messageRender: msg.role === "ai" ? renderMarkdown : undefined,
            loading: msg.role === "ai" && index === messages.length - 1 && loading,
          }))}
          roles={roles}
          className={styles.messages}
          typing={{ step: 2, interval: 50 }}
        />

        <Prompts
          title="✨ Inspirational Sparks and Marvelous Tips"
          items={items}
          wrap
          onItemClick={onPromptSelect} 
        />

        <Sender
          value={content}
          onSubmit={onSubmit}
          onChange={setContent}
          prefix={attachmentsNode}
          loading={agent.isRequesting()}
          className={styles.sender}
        />
      </div>
    </div>
  );
};

export default Independent;
