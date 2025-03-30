<template>
  <div class="operation-form">
    <NavigationBar
      :activeStep="currentStep"
      @exit="() => console.log('退出')"
    />
    <div class="container">
      <!-- 1. 急救记录录入表单（含 AI 优化按钮） -->
      <FormSection />

      <!-- 2. AI 建议 -->
      <SmartAdvice />

      <!-- 3. 词云图 -->
      <ChatWordCloud />
      
      <div class="confirm-button">
        <el-button type="success" @click="handleConfirm">确认结束</el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import NavigationBar from "@/components/NavigationBars.vue";
import FormSection from "@/components/Stat/FormSection.vue";
import SmartAdvice from "@/components/Stat/SmartAdvice.vue";
import ChatWordCloud from "@/components/Stat/ChatWordCloud.vue";
import api from "@/services/api";
import { useStore } from "vuex";


const currentStep = ref("统计分析");
const store = useStore();

const operationIdFromStore = computed(
  () => store.state.operation_id || "20250"
);


const router = useRouter();
function handleConfirm() {
  // 跳转到 AmbuEnd 页面（路由地址根据实际情况配置）
  router.push("/AmbuEnd");
}
</script>

<style scoped>
.operation-form {
  max-width: 1000px;
  margin: 0 auto;
}

.form-card >>> .el-form-item {
  margin-bottom: 18px;
}

.container {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.form-card,
.summary-card,
.table-card {
  padding: 20px;
}
.summary {
  display: flex;
  justify-content: space-around;
  text-align: center;
}
.summary-item {
  flex: 1;
}
.summary-number {
  font-size: 2em;
  font-weight: bold;
}
.summary-label {
  color: #888;
}
.confirm-button {
  display: flex;
  justify-content: center;
}
</style>
