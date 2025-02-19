<template>
  <div class="medical-record">
    <!-- 标题区 -->
    <div class="header">
      <h2>住院病历</h2>
      <div class="hospital-info">
        <span>病历号：{{ currentRecord.case_id }}</span>
      </div>
    </div>

    <!-- 基本信息 -->
    <el-card class="basic-info-card">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="姓名">{{ currentRecord.name }}</el-descriptions-item>
        <el-descriptions-item label="性别">{{ currentRecord.sex }}</el-descriptions-item>
        <el-descriptions-item label="民族">{{ currentRecord.ethnicity }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentRecord.telno }}</el-descriptions-item>
        <el-descriptions-item label="证件号" :span="1">{{ currentRecord.patient_id }}</el-descriptions-item>
        <el-descriptions-item label="证件类型">{{ currentRecord.idType }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <!-- 病历信息 -->
    <el-card class="medical-record-card">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="所在医院">{{ currentRecord.hospital }}</el-descriptions-item>
        <el-descriptions-item label="科室">{{ currentRecord.dname }}</el-descriptions-item>
        <el-descriptions-item label="主治医师">{{ currentRecord.wname }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ currentRecord.remark }}</el-descriptions-item>
        <el-descriptions-item label="入院时间">{{ formatDateTime(currentRecord.admission_time) }}</el-descriptions-item>
        <el-descriptions-item label="出院时间">{{ formatDateTime(currentRecord.discharge_time) }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-divider></el-divider>

    <!-- 诊断主区域 -->
    <div class="diagnosis-area">
      <div class="diagnosis-section">
        <h4>入院病情：</h4>
        <p>{{ currentRecord.in_assessment }}</p>
      </div>
      
      <div class="diagnosis-section">
        <h4>出院诊断：</h4>
        <p>{{ currentRecord.out_result }}</p>
      </div>
    </div>

    <!-- 相关的medicine/check没有放进来,后面有空可以再加 -->

  </div>
</template>

<script setup>
import { ref, defineProps, watch } from 'vue';
import dayjs from 'dayjs'

// 接收父组件传来的 records
const props = defineProps({
  records: {
    type: Array,
    default: () => []
  }
});

// 获取当前门诊记录
const currentRecord = ref({});  // 初始为空对象

console.log("接收到的门诊记录:", props.records);
// 监听 records 的变化
watch(
  () => props.records,
  (newRecords) => {
    // 解包 Proxy 对象
    const rawRecords = JSON.parse(JSON.stringify(newRecords));
    console.log("解包后记录:", rawRecords);
    
    if (rawRecords) {
      currentRecord.value = rawRecords;
      console.log("当前门诊记录:", currentRecord.value);
    } else {
      currentRecord.value = {};
    }
  },
  { immediate: true, deep: true } // 添加深度监听
);



// 日期格式化
const formatDateTime = (val) => {
  return dayjs(val).format('YYYY年MM月DD日 HH时mm分')
}
</script>


<style scoped>
/* 样式优化部分 */
.medical-record {
  padding: 20px;
}

.header {
  text-align: center;
  margin-bottom: 20px;
}

.hospital-info {
  text-align: center;
}

.basic-info-card,
.signature-card {
  margin-top: 20px;
}

.diagnosis-area {
  margin-top: 30px;
}

.diagnosis-row {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.diagnosis-section h4 {
  color: #409eff;
  margin-bottom: 10px;
}

.diagnosis-grid {
  display: grid;
  gap: 20px;
}

.treatment-plan ul {
  padding-left: 20px;
}

.signature-area {
  text-align: center;
  margin-top: 30px;
}

.signature-line {
  width: 200px;
  border-bottom: 2px solid #000;
  margin: 20px auto;
}

.el-tag {
  font-weight: bold;
}

.el-descriptions-item {
  font-size: 14px;
}
</style>