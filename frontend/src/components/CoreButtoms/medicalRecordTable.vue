<template>
  <div class="medical-record">
    <!-- 标题区 -->
    <div class="header">
      <h2>常熟市第二人民医院门诊病历</h2>
      <div class="hospital-info">
        <span>病历号：{{ record.record_id }}</span>
        <span>门诊编号：{{ record.outpatient_id }}</span>
      </div>
    </div>

    <!-- 基本信息 -->
    <el-descriptions :column="3" border>
      <el-descriptions-item label="姓名">{{ record.name }}</el-descriptions-item>
      <el-descriptions-item label="性别">{{ record.gender }}</el-descriptions-item>
      <el-descriptions-item label="民族">{{ record.ethnicity }}</el-descriptions-item>
      <el-descriptions-item label="证件号" :span="2">{{ record.id_number }}</el-descriptions-item>
      <el-descriptions-item label="就诊时间">{{ formatDateTime(record.timestamp) }}</el-descriptions-item>
    </el-descriptions>

    <!-- 诊断主区域 -->
    <div class="diagnosis-area">
      <div class="diagnosis-row">
        <label>初诊/复诊/急诊：</label>
        <el-tag type="danger">{{ record.type }}</el-tag>
      </div>
      
      <div class="diagnosis-section">
        <h4>主要症状和体征：</h4>
        <p>{{ record.chief_complaint }}</p>
      </div>

      <div class="diagnosis-section">
        <h4>现病史：</h4>
        <pre>{{ record.present_illness }}</pre>
      </div>

      <div class="diagnosis-grid">
        <div class="grid-item">
          <h4>体格检查：</h4>
          <p>{{ record.physical_exam }}</p>
        </div>
        <div class="grid-item">
          <h4>辅助检查：</h4>
          <p>{{ record.auxiliary_exam }}</p>
        </div>
      </div>

      <div class="diagnosis-section">
        <h4>诊断：</h4>
        <el-alert :title="record.diagnosis" type="warning" :closable="false"/>
      </div>

      <div class="treatment-plan">
        <h4>处理措施：</h4>
        <ul>
          <li v-for="(item,index) in record.measures.split('，')" :key="index">
            <el-icon><caret-right /></el-icon>
            {{ item }}
          </li>
        </ul>
      </div>
    </div>

    <!-- 医师信息 -->
    <div class="signature-area">
      <div class="signature-row">
        <span>是否留观：{{ record.observation }}</span>
        <span>医师签名：{{ record.doctor }}</span>
      </div>
      <div class="signature-line"></div>
    </div>
  </div>
</template>

<script setup>
import { CaretRight } from '@element-plus/icons-vue'
import dayjs from 'dayjs'

const record = {
  record_id: 14991264,
  name: '陈乐',
  gender: '女',
  ethnicity: '汉族',
  id_number: '320581200308281686',
  outpatient_id: 14991264,
  type: '急诊',
  timestamp: '2024-02-18T15:10:00',
  chief_complaint: '右足外伤2小时',
  present_illness: '患者自述右足外伤2h，否认其他外伤。',
  physical_exam: '神清，精神可，右足轻压痛。',
  auxiliary_exam: '尿常规++，胸片正常。',
  diagnosis: '右足骰骨外侧缘撕脱骨折可能',
  measures: '休息，左肢石膏固定，每日换药，观察伤口',
  observation: '否',
  doctor: '彭陈瑶'
}

const formatDateTime = (val) => {
  return dayjs(val).format('YYYY年MM月DD日 HH时mm分')
}
</script>

<style scoped>
.medical-record {
  width: 794px; /* A4纸宽度 */
  min-height: 1123px;
  padding: 40px;
  background: white;
  box-shadow: 0 2px 12px rgba(0,0,0,0.1);
}

.header {
  text-align: center;
  margin-bottom: 30px;
  h2 {
    font-size: 24px;
    color: #1c3e6e;
    margin: 20px 0;
  }
  .hospital-info {
    display: flex;
    justify-content: space-between;
    padding: 0 50px;
  }
}

.diagnosis-area {
  margin-top: 30px;
  .diagnosis-row {
    display: flex;
    align-items: center;
    margin: 15px 0;
    label {
      width: 120px;
      font-weight: bold;
    }
  }
  h4 {
    color: #409eff;
    margin: 12px 0;
  }
}

.diagnosis-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  margin: 20px 0;
}

.treatment-plan {
  ul {
    padding-left: 30px;
    li {
      margin: 8px 0;
      display: flex;
      align-items: center;
      .el-icon {
        color: #67c23a;
        margin-right: 8px;
      }
    }
  }
}

.signature-area {
  margin-top: 50px;
  .signature-row {
    display: flex;
    justify-content: space-between;
    padding: 0 60px;
  }
  .signature-line {
    width: 200px;
    border-bottom: 2px solid #000;
    margin: 30px auto;
  }
}

pre {
  white-space: pre-wrap;
  background: #f8f8f8;
  padding: 10px;
  border-radius: 4px;
}
</style>