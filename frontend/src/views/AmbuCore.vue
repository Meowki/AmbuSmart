<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />

  <div class="main-container">
    <!-- 左侧功能区 -->
    <div class="sidebar">
      <!--患者信息、基础检查、量化评估、时间线-->
      <el-card class="sidebar-card">
      <div class="button-container">
        <PatientInfo /> 
        <CheckPage />
        <ScoreTableDialogue />
        <KeywordsGraph />
        <TimeLineButtom />
      </div>
    </el-card>
    </div>

  


    <!-- 右侧聊天区 -->
    <div class="chat-area">
      <div class="react-container">
        <IndependentInVue :operationId="operationIdFromStore" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref } from "vue";
import { useStore } from "vuex"; // Vuex 版
import { applyReactInVue } from "veaury"; 
import NavigationBar from "@/components/NavigationBars.vue";
import Independent from "@/components/Independent.jsx"; 
import PatientInfo from "@/components/CoreButtoms/PatientInfo.vue";
import TimeLineButtom from "@/components/CoreButtoms/timeLineButtom.vue";
import CheckPage from "@/components/CoreButtoms/basicCheckDialogue.vue";
import ScoreTableDialogue from "@/components/CoreButtoms/scoreTableDialogue.vue";
import KeywordsGraph from "@/components/CoreButtoms/KeywordsGraph.vue"

const IndependentInVue = applyReactInVue(Independent); 

const currentStep = ref('决策系统')

const store = useStore();
const operationIdFromStore = computed(() => store.state.operation_id || "20250");

// const handleAction = (action) => {
//   console.log("执行动作:", action);
// };
</script>

<style scoped>
html, body {
  overflow: hidden; /* 禁止整个页面的滚动条 */
  height: 100%;
}


.main-container {
  display: flex;
  height: 86vh; /* 使用整个视窗 */
  overflow: hidden; /* 禁止主容器的滚动 */
}

.sidebar {
  width: 20%;
  padding: 20px;
  background: linear-gradient(135deg, #f5f5f5, #e0e0e0); /* 渐变背景 */
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1); /* 添加阴影效果 */
  border-radius: 12px; /* 左侧栏圆角 */
}

.sidebar-card {
  padding: 10px;
  background-color: transparent;
}

.sidebar-button {
  margin-bottom: 15px;
  font-size: 1em;
  border-radius: 6px; /* 按钮圆角 */
  transition: background-color 0.3s ease; /* 添加按钮 hover 动画 */
}

.sidebar-button:hover {
  background-color: #1677ff; /* hover 时的背景色 */
  color: white;
}

.chat-area {
  width: 100%; /* 右侧区域 */
  height: 85vh; /* 保证其高度填满页面 */
  background-color: #fff;
  padding:5px;
  border-radius: 12px; /* 圆角效果 */
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* 卡片阴影效果 */
  overflow: hidden; /* 防止溢出内容 */
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

.button-container {
  display: flex;
  flex-direction: column;
  gap: 15px; /* 设置组件之间的统一间距 */
}

</style>

