<template>
  <NavigationBar :activeStep="currentStep" @exit="handleExit" />
  <div class="container">
    <el-card class="end-card" shadow="hover">
      <h2>急救记录结束</h2>
      <p>您的急救记录已成功结束，感谢您的使用！</p>
      <div class="button-group">
        <el-button type="primary" @click="goHome">返回首页</el-button>
        <el-button type="success" @click="showRecordDialog">查看急救记录单</el-button>
      </div>
    </el-card>
  </div>


  <el-dialog v-model="dialogVisibleOperation" width="70%" title="院前急救电子记录单">
    <template #header>
    <div class="dialog-header">
      <el-button type="primary" @click="exportPDF">导出PDF</el-button>
    </div>
  </template>

    <div ref="printContent">
      <OperationHistoryTable :records="[currentOperation]" />
    </div>
  </el-dialog>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useStore } from "vuex";
import api from "@/services/api";
import dayjs from 'dayjs';
import html2pdf from 'html2pdf.js';
import NavigationBar from '@/components/NavigationBars.vue';
import OperationHistoryTable from '@/components/CoreButtoms/operationHistoryTable.vue';


const currentStep = ref('急救结束');
const router = useRouter();
const store = useStore();
const dialogVisibleOperation = ref(false);
const printContent = ref(null);

// 导出PDF功能
const exportPDF = () => {
  const element = printContent.value;
  
  const options = {
    margin: 5,
    filename: `急救记录单_${dayjs().format('YYYYMMDD_HHmmss')}.pdf`,
    image: { type: 'jpeg', quality: 0.98 },
    html2canvas: { scale: 2 },
    jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
  };

  html2pdf().set(options).from(element).save().catch(err => {
    console.error("PDF生成失败：", err);
  });
};

// 基本患者信息
const patientInfo = ref({
  patient_id: store.state.patient_id || "123123200308281234",
  name: "",
  sex: "",
  idType: "身份证",
  telno: "",
  address: "",
  ethnicity: "",
  age: "",
});

// 当前急救记录
const currentOperation = ref({});

// 页面加载时同时获取患者信息和急救记录
onMounted(async () => {
  try {
    const patientId = patientInfo.value.patient_id;
    const operationId = store.state.operation_id || "20250";

    // 获取患者信息
    const patientResponse = await api.get(`/patients/${patientId}`);
    const patientData = patientResponse.data[0] || {};

    patientInfo.value = {
      ...patientInfo.value,
      name: patientData.name || "",
      sex: patientData.sex || "",
      telno: patientData.telno || "",
      address: patientData.address || "",
      ethnicity: patientData.ethnicity || "",
      age: patientInfo.value.idType === "身份证" ? calculateAge(patientId) : "",
    };

    // 获取急救记录 (单条记录)
    const operationResponse = await api.get(`/operation_histories/operationId/${operationId}`);
    const record = operationResponse.data || {};
    console.log("record",operationResponse.data)

    currentOperation.value = {
      ...record,
      patient_id: patientInfo.value.patient_id,
      idType: patientInfo.value.idType,
      name: patientInfo.value.name,
      sex: patientInfo.value.sex,
      telno: patientInfo.value.telno,
      address: patientInfo.value.address,
      ethnicity: patientInfo.value.ethnicity,
      age: patientInfo.value.age,
      // 日期统一格式化
          informant: record.informant || "",
          scene_address: record.scene_address || "",
          dispatch_time: formatDateTime(record.dispatch_time) || "",
          arrival_on_scene_time: formatDateTime(record.arrival_on_scene_time) || "",
          departure_from_scene_time: formatDateTime(record.departure_from_scene_time) || "",
          arrival_at_hospital_time: formatDateTime(record.arrival_at_hospital_time) || "",
          destination: record.destination || "", 
          severity_level: record.severity_level || "",
          emergency_type: record.emergency_type || "",
          chief_complaint: record.chief_complaint || "",
          initial_diagnosis: record.initial_diagnosis || "",
          procedures: record.procedures || "",
          medicine: record.medicine || "",
          outcome: record.outcome || "",
          physician: record.physician || "",
          nurse: record.nurse || "",
          driver: record.driver || "",
          paramedic: record.paramedic || "",
          stretcher_bearer: record.stretcher_bearer || "",
          recipient: record.recipient || "",
          initial_eid: record.initial_eid || null,
          final_eid: record.final_eid || null,
          ti_score: record.ti_score || "",
          ti_content: record.ti_content || "",
          gcs_score: record.gcs_score || "",
          gcs_content: record.gcs_content || "",
          Killip_score: record.Killip_score || "",
          Killip_content: record.Killip_content || "",
          Killip_diagnosis: record.Killip_diagnosis || "",
          cerebral_stroke_content: record.cerebral_stroke_content || "",
          initial_check: record.initial_check ? {
            timestamp: formatDateTime(record.initial_check.timestamp) || "",
            reject: record.initial_check.reject || null,
            consciousness: record.initial_check.consciousness || "",
            pupil: record.initial_check.pupil || "",
            pupillary_light_reflex: record.initial_check.pupillary_light_reflex || "",
            blood_pressure: record.initial_check.blood_pressure || "",
            pulse: record.initial_check.pulse || "",
            respiration: record.initial_check.respiration || "",
            oxygen_saturation: record.initial_check.oxygen_saturation || "",
            eid: record.initial_check.eid || null
          } : {},

          final_check: record.final_check ? {
            timestamp: formatDateTime(record.final_check.timestamp) || "",
            reject: record.final_check.reject || null,
            consciousness: record.final_check.consciousness || "",
            pupil: record.final_check.pupil || "",
            pupillary_light_reflex: record.final_check.pupillary_light_reflex || "",
            blood_pressure: record.final_check.blood_pressure || "",
            pulse: record.final_check.pulse || "",
            respiration: record.final_check.respiration || "",
            oxygen_saturation: record.final_check.oxygen_saturation || "",
            eid: record.final_check.eid || null
            } : {}
    };
    console.log("日期：", JSON.stringify(currentOperation.value));
  } catch (error) {
    console.error("加载数据失败:", error);
  }
});

// 显示对话框
function showRecordDialog() {
  dialogVisibleOperation.value = true;
}

// 计算年龄（身份证）
function calculateAge(idNumber) {
  const birthDateStr = idNumber.substring(6, 14);
  const birthYear = parseInt(birthDateStr.substring(0, 4));
  const birthMonth = parseInt(birthDateStr.substring(4, 6)) - 1;
  const birthDay = parseInt(birthDateStr.substring(6, 8));
  const today = new Date();
  let age = today.getFullYear() - birthYear;
  if (
    today.getMonth() < birthMonth ||
    (today.getMonth() === birthMonth && today.getDate() < birthDay)
  ) {
    age--;
  }
  return age;
}

// 格式化日期
function formatDateTime(val) {
  return val ? dayjs(val).format('YYYY年MM月DD日 HH时mm分') : '';
}

function goHome() {
  router.push('/');
}

function handleExit() {
  console.log('退出');
}
</script>


<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 60px);
}

.end-card {
  text-align: center;
}

.button-group {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  gap: 16px;
}


.dialog-header {
  width: 100%;
  display: flex;
  justify-content: flex-end;
  padding-right: 40px; /* 避免与默认关闭按钮重叠 */
}
</style>
