<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />

  <div class="main-container">
    <!-- 左侧功能区 -->
    <div class="sidebar">
      <el-button @click="handleAction('action1')" type="primary">查看患者历史</el-button>
      <el-button @click="handleAction('action2')" type="success">添加药物记录</el-button>
      <el-button @click="handleAction('action3')" type="info">获取急救建议</el-button>
    </div>

    <!-- 右侧聊天区 -->
    <div class="chat-area">
      <h3>before</h3>
      <div class="react-container">
        <!-- 使用 applyReactInVue 包裹 React 组件 -->
        <ChatComponentInVue />
      </div>
      <h3>later</h3>
    </div>
  </div>
</template>

<script>
import { applyReactInVue } from 'veaury'; // 引入 veaury 的工具
import NavigationBar from "@/components/NavigationBars.vue";
// import MyReactComponent from '@/components/MyReactComponent.jsx'; // 确保使用正确的文件扩展名
import ChatComponent from '@/components/ChatWindow.jsx';

const ChatComponentInVue = applyReactInVue(ChatComponent);

// 使用 applyReactInVue 将 React 组件转换为 Vue 组件
// console.log("output:"+MyReactComponent);
// const MyReactComponentInVue = applyReactInVue(MyReactComponent);

export default {
  data() {
    return {
      currentStep: "决策系统",
    };
  },
  methods: {
    handleAction(action) {
      console.log("执行动作:", action);
    },
  },
  components: {
    // MyReactComponentInVue, // 注册转换后的组件
    NavigationBar,
    ChatComponentInVue,
  },
};
</script>

<style scoped>
.main-container {
  display: flex;
  height: 100vh;
}

.sidebar {
  width: 25%;
  padding: 20px;
  background-color: #f5f5f5;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
}

.chat-area {
  width: 75%;
  padding: 10px;
  background-color: #fff;
  overflow-y: auto;
}

.el-button {
  margin-bottom: 15px;
  font-size: 1em;
}

.react-container {
  margin: 20px 0;
}

@media (max-width: 768px) {
  .main-container {
    flex-direction: column;
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
