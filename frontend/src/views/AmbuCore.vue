<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />

  <div class="main-container">
    <!-- 左侧功能区 -->
    <div class="sidebar">
      <el-button @click="handleAction('action1')" type="primary"
        >查看患者历史</el-button
      >
      <el-button @click="handleAction('action2')" type="success"
        >添加药物记录</el-button
      >
      <el-button @click="handleAction('action3')" type="info"
        >获取急救建议</el-button
      >
      <!-- 更多按钮... -->
    </div>

    <!-- 右侧聊天区 -->
    <div class="chat-area">
      <ChatWindow />
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import NavigationBar from "@/components/NavigationBars.vue";
import ChatWindow from "@/components/ChatWindow.vue";


const currentStep = ref("决策系统");

const handleAction = (action) => {
  console.log("执行动作:", action);
};
</script>

<style scoped>
.main-container {
  display: flex;
  height: 100vh;
}

.sidebar {
  width: 25%; /* 左侧1/4 */
  padding: 20px;
  background-color: #f5f5f5;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.chat-area {
  width: 75%; /* 右侧3/4 */
  padding: 10px;
  background-color: #fff;
  overflow-y: auto;
}

.el-button {
  margin-bottom: 15px;
  font-size: 1em;
}

@media (max-width: 768px) {
  .main-container {
    flex-direction: column; /* 在小屏幕上堆叠 */
  }

  .sidebar {
    width: 100%;
    margin-bottom: 20px;
  }

  .chat-area {
    width: 100%;
  }
}
</style>
