<template>
  <div class="emergency-record">
    <div class="header">
      <h2>院前急救记录单</h2>
      <div class="record-info">
        <span>急救号：{{ currentOperation.operation_id }}</span>  &nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;<span>日期：{{ currentOperation.dispatch_time.split(' ')[0] }}</span>
      </div>
    </div>

    <!-- 患者基本信息 -->
    <el-card class="section-card">
      <el-descriptions title="患者信息" :column="3" border>
        <el-descriptions-item label="姓名">{{ currentOperation.name }}</el-descriptions-item>
        <el-descriptions-item label="性别">{{ currentOperation.sex }}</el-descriptions-item>
        <el-descriptions-item label="年龄">{{ currentOperation.age }}</el-descriptions-item>
        <el-descriptions-item label="证件类型">{{ currentOperation.idType }}</el-descriptions-item>
        <el-descriptions-item label="证件号码" :span="2">{{ currentOperation.patient_id }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentOperation.telno }}</el-descriptions-item>
        <el-descriptions-item label="居住地址" :span="2">{{ currentOperation.address }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <!-- 急救时间轴 -->
    <el-card class="section-card">
      <el-descriptions title="时间节点" :column="2" border>
        <el-descriptions-item label="派车时间">{{ currentOperation.dispatch_time }}</el-descriptions-item>
        <el-descriptions-item label="到达现场">{{ currentOperation.arrival_on_scene_time }}</el-descriptions-item>
        <el-descriptions-item label="离开现场">{{ currentOperation.departure_from_scene_time}}</el-descriptions-item>
        <el-descriptions-item label="到达医院">{{ currentOperation.arrival_at_hospital_time }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <!-- 现场信息 -->
    <el-card class="section-card">
      <el-descriptions title="现场信息" :column="2" border>
        <el-descriptions-item label="供史者">{{ currentOperation.informant }}</el-descriptions-item>
        <el-descriptions-item label="现场地址">{{ currentOperation.scene_address }}</el-descriptions-item>
        <el-descriptions-item label="急救性质">{{ currentOperation.emergency_type }}</el-descriptions-item>
        <el-descriptions-item label="病情分级">{{ currentOperation.severity_level }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <div class="diagnosis-section">
        <h4>主诉症状：</h4>
        <el-alert :title="currentOperation.chief_complaint" type="warning" :closable="false" />
      </div>

       <div class="diagnosis-section">
        <h4>初步诊断：</h4>
        <el-alert :title="currentOperation.initial_diagnosis " type="warning" :closable="false" />
      </div>

    <!-- 医疗评估 -->
    <el-card class="section-card">
      <el-descriptions title="医疗评估" :column="2" border>
        <el-descriptions-item label="TI评分">{{ currentOperation.ti_score }}</el-descriptions-item>
        <el-descriptions-item label="GCS评分">{{ currentOperation.gcs_score }}</el-descriptions-item>
        <el-descriptions-item label="胸痛评估">{{ currentOperation.Killip_score }}</el-descriptions-item>
        <el-descriptions-item label="卒中评估">{{ currentOperation.cerebral_stroke_content }}</el-descriptions-item>
      </el-descriptions>
    </el-card>


    <!-- 检查记录 -->
    <el-card class="section-card">
      <div class="check-section">
        <el-descriptions title="初始检查" :column="3" >
          <el-descriptions-item >{{ currentOperation.initial_check?.timestamp }}</el-descriptions-item>
          <el-descriptions-item label="拒检">{{ currentOperation.initial_check?.reject === 1 ? '是' : '否' }}</el-descriptions-item>
          <el-descriptions-item label="神志">{{ currentOperation.initial_check?.consciousness }}</el-descriptions-item>
          <el-descriptions-item label="瞳孔（左/右）">{{ currentOperation.initial_check?.pupil }}</el-descriptions-item>
          <el-descriptions-item label="对光反射">{{ currentOperation.initial_check?.pupillary_light_reflex }}</el-descriptions-item>
          <el-descriptions-item label="血压（mmHg）">{{ currentOperation.initial_check?.blood_pressure }}</el-descriptions-item>
          <el-descriptions-item label="脉搏（次/分）">{{ currentOperation.initial_check?.pulse }}</el-descriptions-item>
          <el-descriptions-item label="呼吸（次/分）">{{ currentOperation.initial_check?.respiration }}</el-descriptions-item>
          <el-descriptions-item label="血氧（%）">{{ currentOperation.initial_check?.oxygen_saturation }}</el-descriptions-item>
        </el-descriptions>

        <el-descriptions title="最终检查" :column="3"  style="margin-top: 20px;" >
          <el-descriptions-item >{{ currentOperation.final_check?.timestamp }}</el-descriptions-item>
          <el-descriptions-item label="拒检">{{ currentOperation.final_check?.reject === 1 ? '是' : '否' }}</el-descriptions-item>
          <el-descriptions-item label="神志">{{ currentOperation.final_check?.consciousness }}</el-descriptions-item>
          <el-descriptions-item label="瞳孔（左/右）">{{ currentOperation.final_check?.pupil }}</el-descriptions-item>
          <el-descriptions-item label="对光反射">{{ currentOperation.final_check?.pupillary_light_reflex }}</el-descriptions-item>
          <el-descriptions-item label="血压（mmHg）">{{ currentOperation.final_check?.blood_pressure }}</el-descriptions-item>
          <el-descriptions-item label="脉搏（次/分）">{{ currentOperation.final_check?.pulse }}</el-descriptions-item>
          <el-descriptions-item label="呼吸（次/分）">{{ currentOperation.final_check?.respiration }}</el-descriptions-item>
          <el-descriptions-item label="血氧（%）">{{ currentOperation.final_check?.oxygen_saturation }}</el-descriptions-item>
        </el-descriptions>
      </div>
    </el-card>

    <!-- 处置信息 -->
    <el-card class="section-card">
      <el-descriptions title="处置记录" :column="1" border>
        <el-descriptions-item label="急救处理">{{ currentOperation.procedures }}</el-descriptions-item>
        <el-descriptions-item label="药物使用记录">{{ currentOperation.medicine }}</el-descriptions-item>
        <el-descriptions-item label="急救结果">{{ currentOperation.outcome }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

        <div class="treatment-plan">
        <h4>处理措施：</h4>
        <ul>
          <!-- 检查 measures 是否为非空字符串 -->
          <li v-for="(item, index) in (currentOperation.procedures ? currentOperation.procedures.split('，') : [])" :key="index">
            <el-icon><caret-right /></el-icon>
            {{ item }}
          </li>
        </ul>
      </div>

    <!-- 签名区 -->
    <div class="signature-area">
      <el-descriptions :column="3" border>
        <el-descriptions-item label="医师">{{ currentOperation.physician }}</el-descriptions-item>
        <el-descriptions-item label="护士">{{ currentOperation.nurse }}</el-descriptions-item>
        <el-descriptions-item label="司机">{{ currentOperation.driver }}</el-descriptions-item>
        <el-descriptions-item label="担架工">{{ currentOperation.stretcher_bearer }}</el-descriptions-item>
        <el-descriptions-item label="抢救员">{{ currentOperation.paramedic }}</el-descriptions-item>
        <el-descriptions-item label="院内接收员"> {{ currentOperation.recipient }}</el-descriptions-item>
      </el-descriptions>
    </div>
  </div>
</template>

<script setup>
import { CaretRight } from '@element-plus/icons-vue'
import { ref, defineProps, watch } from 'vue';

// 接收 records-----------------------------------------------
const props = defineProps({
  records: {
    type: Array,
    default: () => []
  }
});

const currentOperation = ref({});  
console.log("接收到的记录:", props.records);

watch(
  () => props.records,
  (newRecords) => {
    const rawRecords = JSON.parse(JSON.stringify(newRecords));
    console.log("解包后记录:", rawRecords);
    
    if (rawRecords) {
      currentOperation.value = rawRecords;
      console.log("当前记录:", currentOperation.value);
    } else {
      currentOperation.value = {};
    }
  },
  { immediate: true, deep: true } 
);

</script>

<style scoped>
.emergency-record {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  background-color: #fff;
}

.header {
  text-align: center;
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 2px solid #eee;
}

.record-info {
  margin-top: 15px;
  display: flex;
  justify-content: center;
  gap: 30px;
  color: #666;
}

.diagnosis-section h4 {
  color: #409eff;
  margin-bottom: 10px;
}

.section-card {
  margin-bottom: 20px;
}

.check-section {
  padding: 10px;
}

.treatment-plan ul {
  padding-left: 20px;
}

.signature-area {
  margin-top: 30px;
  padding: 15px;
  background: #f8f8f8;
  border-radius: 4px;
}

:deep(.el-descriptions__title) {
  font-size: 16px;
  color: #2c3e50;
  font-weight: 600;
}

:deep(.el-descriptions__label) {
  width: 120px;
  background-color: #fafafa !important;
}
</style>