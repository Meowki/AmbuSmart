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
} from "@ant-design/icons";
import { Avatar, Badge, Button, Space, Flex, Typography } from "antd";
import markdownit from "markdown-it";

// 头像与气泡位置
const userAvatar = { color: "#fff", backgroundColor: "#1677ff" }; // 用户头像
const robotAvatar = { color: "#f56a00", backgroundColor: "#fde3cf" }; // AI 头像

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
  // 加载样式
  const [loading, setLoading] = useState(false);

  // Markdown 解析器
  const md = markdownit({
    html: true,
    breaks: true,
  });

  const renderMarkdown = (content) => (
    <Typography>
      <div
        dangerouslySetInnerHTML={{
          __html: md.render(content),
        }}
      />
    </Typography>
  );

  const [messages, setMessages] = useState([
    {
      role: "ai",
      content: "你好，我是你的医疗 AI 助手，请问有什么需要帮助的吗？",
    },
  ]);
  const [attachedFiles, setAttachedFiles] = useState([]);

  // AI 代理
  const [agent] = useXAgent({
    request: async ({ message }, { onSuccess, onUpdate, onError }) => {
      let aiResponse = "";
      setLoading(true); // 开启加载动画
      try {
        const response = await fetch(`/chat/`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ operation_id: operationId, message }),
        });
        const data = await response.json();
        if (data.response) {
          aiResponse = data.response;
          onSuccess(aiResponse);
          setMessages((prev) =>
            prev.map((msg, index) =>
              index === prev.length - 1 && msg.role === "ai"
                ? { role: "ai", content: aiResponse }
                : msg
            )
          );
        }
      } catch (error) {
        console.error("API 请求失败:", error);
        onError();
      }
      setLoading(false); // 关闭加载动画
    },
  });

  const { onRequest } = useXChat({ agent });

  // ✅ 监听 operationId 变化，清空历史对话
  // 1. 需要把开场白自动改成根据operation histories 生成的结果
  // 2. chat service 的prompt engineering
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

  // ✅ 处理用户提交
  const onSubmit = (nextContent) => {
    if (!nextContent) return;
    setMessages((prev) => [...prev, { role: "user", content: nextContent }]);
    // 立即添加 AI 占位气泡 (正在输入...)
    setMessages((prev) => [...prev, { role: "ai", content: "..." }]);
    onRequest(nextContent);
    setContent("");
  };

  // ✅ 处理提示词点击
  const onPromptsItemClick = (info) => {
    onRequest(info.data.description);
  };

  // ✅ 处理文件上传
  const handleFileChange = (info) => setAttachedFiles(info.fileList);

  // ✅ 附件上传按钮
  const attachmentsNode = (
    <Badge dot={attachedFiles.length > 0}>
      <Button type="text" icon={<PaperClipOutlined />} />
    </Badge>
  );

  return (
    <div className={styles.layout}>
      <div className={styles.chat}>
        {/* 🌟 消息列表 */}
        <Bubble.List
          items={messages.map((msg, index) => ({
            ...msg,
            messageRender: msg.role === "ai" ? renderMarkdown : undefined,
            loading:
              msg.role === "ai" && index === messages.length - 1 && loading, // ✅ 仅最后一个 AI 消息显示加载
          }))}
          roles={roles}
          className={styles.messages}
        />

        {/* 🌟 输入框 */}
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
