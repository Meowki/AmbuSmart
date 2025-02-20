<template>
  <div>
    <el-button  type="success" :loading="loading" @click="handleButtonClick">{{ buttonText }}</el-button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElNotification } from 'element-plus';
import api from "@/services/api";
import { useStore } from "vuex";

// 状态管理
const loading = ref(false);
const buttonText = ref('NA');
const currentOperation = ref({
  dispatch_time: null,
  arrival_on_scene_time: null,
  departure_from_scene_time: null,
  arrival_at_hospital_time: null,
});

const router = useRouter();
const store = useStore();

// 获取操作历史记录
const fetchOperationHistory = async () => {
  try {
    const operationId = store.state.operation_id;
    console.log("operationId:" + operationId);
    const response = await api.get(`/operation_histories/operationId/${operationId}`);
    console.log(response);
    currentOperation.value.dispatch_time = response.data.dispatch_time;
    currentOperation.value.arrival_on_scene_time = response.data.arrival_on_scene_time;
    currentOperation.value.departure_from_scene_time = response.data.departure_from_scene_time;
    currentOperation.value.arrival_at_hospital_time = response.data.arrival_at_hospital_time;
    console.log("timeLine:" + JSON.stringify(currentOperation.value));

    // 根据记录状态初始化按钮文本
    setButtonText();
  } catch (error) {
    console.log(error);
    ElNotification.error({
      title: '错误',
      message: '获取事件记录失败',
      duration: 3000,
    });
  }
};

// 设置按钮文本
const setButtonText = () => {
  if (!currentOperation.value.dispatch_time) {
    buttonText.value = "确认发车";
  } else if (!currentOperation.value.arrival_on_scene_time) {
    buttonText.value = "确认到达现场";
  } else if (!currentOperation.value.departure_from_scene_time) {
    buttonText.value = "确认离开现场";
  } else if (!currentOperation.value.arrival_at_hospital_time) {
    buttonText.value = "确认到达医院";
  } else {
    buttonText.value = "NA"; // 处理完所有步骤
  }
};

// 更新操作历史记录接口调用
const updateOperationHistory = async () => {
  try {
    const operationId = store.state.operation_id;
    const response = await api.put(`/operation_histories/update/${operationId}`, {
      dispatch_time: currentOperation.value.dispatch_time,
      arrival_on_scene_time: currentOperation.value.arrival_on_scene_time,
      departure_from_scene_time: currentOperation.value.departure_from_scene_time,
      arrival_at_hospital_time: currentOperation.value.arrival_at_hospital_time,
    });
    console.log("更新后的操作记录:", response.data);
  } catch (error) {
    console.log(error);
    ElNotification.error({
      title: '错误',
      message: '更新操作记录失败',
      duration: 3000,
    });
  }
};

// 按钮点击处理
const handleButtonClick = async () => {
  loading.value = true;

  // 如果事件记录状态不符合要求，弹出错误提示
  if (
    (currentOperation.value.dispatch_time && currentOperation.value.arrival_on_scene_time && currentOperation.value.departure_from_scene_time && currentOperation.value.arrival_at_hospital_time) ||
    (!currentOperation.value.dispatch_time && !currentOperation.value.arrival_on_scene_time && !currentOperation.value.departure_from_scene_time && !currentOperation.value.arrival_at_hospital_time)
  ) {
    ElNotification.error({
      title: '错误',
      message: '时间记录状态有误',
      duration: 3000,
    });
    buttonText.value = 'NA'; // 错误状态下按钮显示NA
    loading.value = false;
    return;
  }

  // 更新当前时间
  const currentTime = new Date().toISOString();

  if (!currentOperation.value.dispatch_time) {
    currentOperation.value.dispatch_time = currentTime;
    setButtonText(); // 更新按钮文本
    ElNotification.success({
      title: '成功',
      message: '发车时间已记录',
      duration: 2000,
    });
  } else if (!currentOperation.value.arrival_on_scene_time) {
    currentOperation.value.arrival_on_scene_time = currentTime;
    setButtonText(); // 更新按钮文本
    ElNotification.success({
      title: '成功',
      message: '到达现场时间已记录',
      duration: 2000,
    });
  } else if (!currentOperation.value.departure_from_scene_time) {
    currentOperation.value.departure_from_scene_time = currentTime;
    setButtonText(); // 更新按钮文本
    ElNotification.success({
      title: '成功',
      message: '离开现场时间已记录',
      duration: 2000,
    });
  } else if (!currentOperation.value.arrival_at_hospital_time) {
    currentOperation.value.arrival_at_hospital_time = currentTime;
    // 跳转到AmbuStat页面
    router.push('/AmbuStat');
    ElNotification.success({
      title: '成功',
      message: '到达医院时间已记录，跳转中...',
      duration: 2000,
    });
  }

  // 更新操作历史记录
  updateOperationHistory();

  loading.value = false;
};

// 页面加载时获取操作历史记录
onMounted(() => {
  fetchOperationHistory();
});
</script>

<style scoped>
/* 按钮样式 */
.el-button {
  margin: 20px;
}
</style>
