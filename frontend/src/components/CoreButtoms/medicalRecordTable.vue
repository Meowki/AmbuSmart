<template>
  <div class="medical-record">
    <!-- 标题区 -->
    <div class="header">
      <h2>门诊病历</h2>
      <div class="hospital-info">
        <span>病历号：{{ currentRecord.record_id }}</span>
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
        <el-descriptions-item label="证件类型" >{{ currentRecord.idType }}</el-descriptions-item>
        <el-descriptions-item label="就诊科室">{{ currentRecord.dname }}</el-descriptions-item>
        <el-descriptions-item label="就诊时间">{{ currentRecord.timestamp }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <!-- 诊断主区域 -->
    <div class="diagnosis-area">
      <div class="diagnosis-row">
        <label><b>初诊/复诊/急诊：</b></label>
        <el-tag type="danger">{{ currentRecord.type }}</el-tag>
      </div>
      
      <div class="diagnosis-section">
        <h4>主要症状和体征：</h4>
        <p>{{ currentRecord.chief_complaint }}</p>
      </div>

      <div class="diagnosis-section">
        <h4>现病史：</h4>
        <pre>{{ currentRecord.present_illness }}</pre>
      </div>

      <div class="diagnosis-grid">
        <div class="grid-item">
          <h4>体征信息：</h4>
          <el-descriptions :column="3" border>
            <el-descriptions-item label="体温（℃）">{{ currentRecord.temperature }}</el-descriptions-item>
            <el-descriptions-item label="脉搏（次/分）">{{ currentRecord.pulse }}</el-descriptions-item>
            <el-descriptions-item label="收缩压（mmHg）">{{ currentRecord.sbp }}</el-descriptions-item>
            <el-descriptions-item label="舒张压（mmHg）">{{ currentRecord.dbp }}</el-descriptions-item>
            <el-descriptions-item label="呼吸（次/分）">{{ currentRecord.pulmonary }}</el-descriptions-item>
          </el-descriptions>
        </div>
      </div>

      <el-divider></el-divider>

      <div class="diagnosis-section">
        <h4>诊断：</h4>
        <el-alert :title="currentRecord.assessment" type="warning" :closable="false" />
      </div>

      <div class="treatment-plan">
        <h4>处理措施：</h4>
        <ul>
          <!-- 检查 measures 是否为非空字符串 -->
          <li v-for="(item, index) in (currentRecord.measures ? currentRecord.measures.split('，') : [])" :key="index">
            <el-icon><caret-right /></el-icon>
            {{ item }}
          </li>
        </ul>
      </div>
    </div>

    <!-- 医师信息 -->
    <el-card class="signature-card">
      <div class="signature-area">
        <div class="signature-row">
          <span>是否留观：{{ currentRecord.observation }}</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <span>医师签名：{{ currentRecord.wname }}</span>
        </div>
        <div class="signature-line"></div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { CaretRight } from '@element-plus/icons-vue'
import { ref, defineProps, watch } from 'vue';

// 接收父组件传来的 records
const props = defineProps({
  records: {
    type: Array,
    default: () => []
  }
});

// 获取当前门诊记录
const currentRecord = ref({});  

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