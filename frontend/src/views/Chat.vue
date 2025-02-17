<template>
  <div class="chat-wrapper">
    <div class="chat-container">
      <transition-group name="message" tag="div" class="chat-messages" ref="messages">
        <div
          class="message"
          :class="message.sender === 'user' ? 'user-message' : 'gpt-message'"
          v-for="(message, index) in messages"
          :key="index"
        >
          <p>{{ message.text }}</p>
        </div>
      </transition-group>
      <div class="chat-input">
        <input
          type="text"
          v-model="userInput"
          @keyup.enter="sendMessage"
          placeholder="输入你的消息..."
        />
        <button @click="sendMessage">发送</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ChatWindow',
  data() {
    return {
      userInput: '',
      messages: [
        { text: '你好，GPT！', sender: 'user' },
        { text: '你好！有什么我可以帮助你的吗？', sender: 'gpt' },
      ],
      loading: false,
    };
  },
  methods: {
    async sendMessage() {
      if (this.userInput.trim() === '') return;

      // 添加用户消息
      this.messages.push({ text: this.userInput, sender: 'user' });

      const messageToSend = this.userInput;
      this.userInput = '';
      this.loading = true;

      try {
        const response = await axios.post('http://localhost:8000/api/chat', {
          message: messageToSend
        });

        const gptMessage = response.data.message;
        this.messages.push({ text: gptMessage, sender: 'gpt' });
      } catch (error) {
        console.error("Error fetching GPT response:", error);
        this.messages.push({ text: '抱歉，发生了错误。', sender: 'gpt' });
      } finally {
        this.loading = false;
        // 自动滚动到底部
        this.$nextTick(() => {
          this.$refs.messages.scrollTop = this.$refs.messages.scrollHeight;
        });
      }
    },
  },
};
</script>

<style scoped>
.chat-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  background-color: #f0f4f8;
  min-height: 100vh;
}

.chat-container {
  width: 100%;
  max-width: 800px;
  height: 600px;
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  padding: 20px;
}

.chat-messages {
  flex: 1;
  padding: 8px;
  overflow-y: auto;
  background-color: #eef3f7;
  margin-bottom: 10px;
}

.message {
  margin-bottom: 15px;
  padding: 10px 15px;
  max-width: 70%;
  word-wrap: break-word;
  font-size: 0.8em;
  line-height: 1.4;
}

.user-message {
  background-color: #d1e7ff;
  align-self: flex-end;
  color: #003366;
  border-radius: 12px;
}

.gpt-message {
  background-color: #f1f1f1;
  align-self: flex-start;
  color: #333333;
  border-radius: 12px;
}

.chat-input {
  display: flex;
  justify-content: space-between;
  padding: 12px;
  border-top: 1px solid #ddd;
  background-color: #fafafa;
}

.chat-input input {
  flex: 1;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 25px;
  outline: none;
  font-size: 0.9em;
  transition: border-color 0.3s;
}

.chat-input input:focus {
  border-color: #4a90e2;
}

.chat-input button {
  margin-left: 10px;
  padding: 10px 20px;
  background-color: #4a90e2;
  color: #ffffff;
  border: none;
  border-radius: 25px;
  cursor: pointer;
  font-size: 0.9em;
  transition: background-color 0.3s;
}

.chat-input button:hover {
  background-color: #357ab8;
}

@media (max-width: 600px) {
  .chat-container {
    height: 85vh;
  }

  .chat-header {
    font-size: 1.2em;
  }

  .message {
    max-width: 95%;
    font-size: 0.8em;
  }

  .chat-input input {
    font-size: 0.8em;
  }

  .chat-input button {
    font-size: 0.85em;
    padding: 8px 16px;
  }
}

.message-enter-active, .message-leave-active {
  transition: all 0.5s;
}

.message-enter-from, .message-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

.message-enter-to, .message-leave-from {
  opacity: 1;
  transform: translateY(0);
}
</style>
