<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />

  <div class="main-container">
    <!-- 左侧功能区 -->
    <div class="sidebar">
      <el-button @click="handleAction('action1')" type="primary">患者信息</el-button>
      <el-button @click="handleAction('action2')" type="success">量化评估</el-button>
      <el-button @click="handleAction('action3')" type="info">智能总结</el-button>
      <el-button @click="handleAction('action4')" type="info">时间节点</el-button>
    </div>

    <!-- 右侧聊天区 -->
    <div class="chat-area">
      <div class="react-container">
        <!-- 使用 applyReactInVue 包裹 React 组件 -->
        <!--<ChatComponentInVue />-->
        <IndependentInVue />
      </div>
    </div>
  </div>
</template>

<script>
import { applyReactInVue } from 'veaury'; // 引入 veaury 的工具
import NavigationBar from "@/components/NavigationBars.vue";
// import ChatComponent from '@/components/ChatWindow.jsx';
import Independent from '@/components/Independent.jsx'; // 引入新的 React 组件

// const ChatComponentInVue = applyReactInVue(ChatComponent);
const IndependentInVue = applyReactInVue(Independent); // 引入新的 React 组件


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
    NavigationBar,
    // ChatComponentInVue,
    IndependentInVue, 
  },
};
</script>

<style scoped>
html, body {
  overflow: hidden; /* 禁止整个页面的滚动条 */
  height: 100%;
}

.main-container {
  display: flex;
  height: 86vh;
  overflow: hidden; /* 禁止主容器的滚动 */
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
  width: 90%; /* 右侧区域 */
  height: 100vh; /* 保证其高度填满页面 */
  background-color: #fff;
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
