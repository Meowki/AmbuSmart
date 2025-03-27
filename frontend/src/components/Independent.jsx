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
import React, { useEffect, useState, useRef } from "react";
import {
  PaperClipOutlined,
  UserOutlined,
  RobotOutlined,
  MedicineBoxOutlined,
  FileDoneOutlined,
  HeartOutlined,
  PlusCircleOutlined,
} from "@ant-design/icons";
import { Avatar, Badge, Button, Typography, message} from "antd";
import markdownit from "markdown-it";

// 头像与气泡位置
const userAvatar = { color: "#fff", backgroundColor: "#1677ff" }; // 用户头像
const robotAvatar = { color: "#f56a00", backgroundColor: "#fde3cf" }; // AI 头像

// 下一步：把患者的所有基本信息导进来，生成患者情况
// 加入患者主诉得到初步诊断并保存进数据库，message提示
// 如何能在vue timeline跳转之前，实现对 药物、操作流程的输出和保存，
// 还有最终结果的保存（让ai只能从一些范围内选择，不能长）
// 然后 chat就先到这里，后面再回头加数据集模拟优化。做Stats去。Stats后面就是最终报告生成。
// 再下面就是知识图谱，看能不能放到core页面。


// prompts 按钮
const items = [
  {
    key: "patient_basic_analysis",
    icon: <UserOutlined style={{ color: "#722ed1" }} />, // 可以换其他图标
    label: "分析患者基础信息", // 你可以自定义更贴切的文案
  },
  {
    key: "initial_diagnosis",
    icon: <MedicineBoxOutlined style={{ color: "#FF4D4F" }} />,
    label: "初步诊断",
  },
  {
    key: "procedures_medicine_summary",
    icon: <FileDoneOutlined style={{ color: "#1890FF" }} />,
    label: "整理急救操作与药物记录",
  },
  {
    key: "final_emergency_result",
    icon: <HeartOutlined style={{ color: "#52C41A" }} />,
    label: "生成最终急救结果总结",
  },
  // {
  //   key: "standard_advice",
  //   icon: <PlusCircleOutlined style={{ color: "#FAAD14" }} />,
  //   label: "快速生成标准急救建议",
  // },
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
  const [isAborted, setIsAborted] = useState(false);
  const md = markdownit({ html: true, breaks: true });

  //打断流式输出
  const abortControllerRef = useRef(new AbortController());
  useEffect(() => {
    return () => abortControllerRef.current.abort();
  }, []);

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
  const requestAI = async (payload, { onSuccess, onError }) => {
    const { message, prompt_type } = payload.message;
    let aiResponse = "";
    setLoading(true);
    setIsAborted(false);

    abortControllerRef.current = new AbortController();

    console.log("requestAI", { message, prompt_type });
    console.log("payload.message", payload.message);
    try {
      const response = await fetch(`/chat/`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          operation_id: parseInt(operationId, 10),
          message,
          prompt_type,
        }),
        signal: abortControllerRef.current.signal,
      });

      if (!response.body) throw new Error("后端无流式返回");

      const reader = response.body.getReader();
      const decoder = new TextDecoder("utf-8");

      // eslint-disable-next-line
      while (true) {
        const { done, value } = await reader.read();
        if (done || isAborted) break;

        const chunk = decoder.decode(value, { stream: true });
        const lines = chunk.split("\n\n").filter(Boolean);

        for (const line of lines) {
          if (isAborted) break;
          if (line.startsWith("data: ")) {
            const jsonStr = line.replace("data: ", "");
            try {
              const data = JSON.parse(jsonStr);
              if (data.response) {
                aiResponse += data.response;
                setMessages((prev) => {
                  if (isAborted) return prev;
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
      if (!isAborted) onSuccess(aiResponse);
    } catch (error) {
      if (error.name === "AbortError") {
        console.log("请求已取消");
        setMessages((prev) => {
          const lastMsg = prev[prev.length - 1];
          return [
            ...prev.slice(0, -1),
            { ...lastMsg, content: `${lastMsg.content}（请求已取消）` },
          ];
        });
      } else {
        console.error("API 请求失败:", error);
        onError();
      }
    } finally {
      setLoading(false);
    }
  };

  const [agent] = useXAgent({ request: requestAI });
  const { onRequest } = useXChat({
    agent,
    getMessage: (payload) => payload.message.message,
    getMeta: (payload) => ({ prompt_type: payload.message.prompt_type }),
  });
   
  const [currentPromptType, setCurrentPromptType] = useState("standard_advice");

  useEffect(() => {
    if (operationId) {
    setMessages([
      {
        role: "ai",
        content: "你好，我是你的医疗 AI 助手，请问有什么需要帮助的吗？",
      },
    ]);

    const triggerPatientBasicAnalysis = async () => {
      // 添加占位消息
      setMessages((prev) => [
        ...prev,
        { role: "ai", content: "正在自动分析患者基础信息..." },
      ]);
      setLoading(true);
      setIsAborted(false);
  
      try {
        const res = await fetch(`/chat/auto/${operationId}`);
        if (!res.ok) {
          const errorData = await res.json();
          if (res.status === 400) {
            message.warning("未录入患者信息，无法生成基础分析。");
          } else {
            message.warning(`AI 分析失败：${errorData.detail}`);
          }
          return;
        }
  
        const reader = res.body.getReader();
        const decoder = new TextDecoder("utf-8");
        let aiResponse = "";
  
        while (true) {
          const { done, value } = await reader.read();
          if (done || isAborted) break;
  
          const chunk = decoder.decode(value, { stream: true });
          const lines = chunk.split("\n\n").filter(Boolean);
  
          for (const line of lines) {
            if (line.startsWith("data: ")) {
              const jsonStr = line.replace("data: ", "");
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
            }
          }
        }
      } catch (error) {
        console.error("自动分析请求失败：", error);
        message.error("AI 自动分析失败，请稍后重试");
      } finally {
        setLoading(false);
      }
    };
  
    // 延迟触发更自然
    setTimeout(() => {
      triggerPatientBasicAnalysis();
    }, 600);
  }
  }, [operationId]);
   

  // 提交事件
  const onSubmit = (nextContent) => {
    if (!nextContent) return;

    setMessages((prev) => [
      ...prev,
      { role: "user", content: nextContent },
      { role: "ai", content: "..." },
    ]);


    onRequest({
      message: nextContent,
      prompt_type: currentPromptType || "standard_advice",
    });
        
    console.log(
      "nextContent:" + nextContent + "currentPromptType:" + currentPromptType 
    )

    setContent("");
  };
  

  // 新增 Prompt 按钮的选择事件
  const onPromptSelect = (item) => {
    const promptType = item.data.key;
    const promptDescription = item.data.label;
  
    setCurrentPromptType(promptType);

    console.log(
      "promptDescription:" + promptDescription + "promptType:" + promptType
    );
  
    if (!operationId) {
      console.error("operationId不存在，无法发送请求");
      return;
    }
  
    setMessages((prev) => [
      ...prev,
      { role: "user", content: promptDescription },
      { role: "ai", content: "..." },
    ]);
  
    onRequest({
      message: promptDescription,
      prompt_type: promptType,
    });    
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
            loading:
              msg.role === "ai" && index === messages.length - 1 && loading,
          }))}
          roles={roles}
          className={styles.messages}
          typing={{ step: 2, interval: 50 }}
        />

        <Prompts items={items} wrap onItemClick={onPromptSelect} />

        <Sender
          value={content}
          onSubmit={onSubmit}
          onChange={setContent}
          loading={loading} // 绑定明确的状态
          onCancel={() => {
            setIsAborted(true);
            abortControllerRef.current.abort();
            setLoading(false); // 明确停止loading动画
          }}
          className={styles.sender}
        />
      </div>
    </div>
  );
};

export default Independent;
