<template>
  <div>
    <el-button type="primary" @click="openDialog">查看患者信息</el-button>

    <!-- 患者信息弹出框 -->
    <el-dialog
      title="患者信息"
      v-model="dialogVisible"
      width="80%"
    >
      <el-tabs v-model="activeTab">
        <!-- Tab 1: 患者基本信息 -->
        <el-tab-pane label="患者信息">
          <el-form :model="patientInfo" label-width="120px">
            <!-- 身份证号 -->
            <el-row :gutter="20">
              <el-col :span="10">
                <el-form-item label="患者身份证号">
                  <el-input
                    v-model="originalPatientId"
                    @blur="validatePatientId"
                    placeholder="请输入患者身份证号（公安扫脸）"
                    maxlength="18"
                  />
                </el-form-item>
              </el-col>

              <!-- 证件类型 -->
              <el-col :span="10">
                <el-form-item label="证件类型">
                  <el-select v-model="patientInfo.idType" placeholder="请选择证件类型">
                    <el-option label="身份证" value="身份证"></el-option>
                    <el-option label="护照" value="护照"></el-option>
                    <el-option label="外国人永久居留身份证" value="外国人永久居留身份证"></el-option>
                    <el-option label="港澳居民来往内地通行证" value="港澳居民来往内地通行证"></el-option>
                    <el-option label="台湾居民来往大陆通行证" value="台湾居民来往大陆通行证"></el-option>
                    <el-option label="其他" value="其他"></el-option>
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>

            <el-row :gutter="20">
              <el-col :span="10">
            <el-form-item label="姓名">
              <el-input v-model="patientInfo.name" disabled></el-input>
            </el-form-item>
            </el-col>
            <el-col :span="10">
            <el-form-item label="性别">
              <el-input v-model="patientInfo.sex" disabled></el-input>
            </el-form-item>
            </el-col>
            </el-row>

             <el-row :gutter="20">
              <el-col :span="10">
            <el-form-item label="年龄">
              <el-input v-model="patientInfo.age" disabled></el-input>
            </el-form-item>
            </el-col>
            <el-col :span="10">
            <el-form-item label="电话">
              <el-input v-model="patientInfo.telno" disabled></el-input>
            </el-form-item>
            </el-col>
            </el-row>
            
             <el-row :gutter="20">
              <el-col :span="10">
            <el-form-item label="民族">
              <el-input v-model="patientInfo.ethnicity" disabled></el-input>
            </el-form-item>
            </el-col>
            <el-col :span="10">
            <el-form-item label="地址">
              <el-input v-model="patientInfo.address" disabled></el-input>
            </el-form-item>
            </el-col>
            </el-row>

          </el-form>

        <el-divider><h3>过敏信息</h3> </el-divider>
          <el-table :data="allergyInfo" style="width: 100%">
            <el-table-column label="过敏原" prop="allergy_name"></el-table-column>
            <el-table-column label="严重程度" prop="severity"></el-table-column>
            <el-table-column label="备注" prop="remark"></el-table-column>
          </el-table>

        <el-divider><h3>既往史</h3> </el-divider>
        <el-table :data="medicalHistories" style="width: 100%">
            <el-table-column label="病情名称" prop="condition_name"></el-table-column>
            <el-table-column label="诊断日期" prop="diagnosis_date"></el-table-column>
            <el-table-column label="备注" prop="remark"></el-table-column>
          </el-table>

        </el-tab-pane>

        <!-- Tab 2 -->
        <el-tab-pane label="门诊记录">
          <el-table :data="medicalRecords" style="width: 100%">
            <!-- 显示门诊记录的必要属性 -->
            <el-table-column label="就诊日期" prop="timestamp"></el-table-column>
            <el-table-column label="诊断结果" prop="assessment"></el-table-column>
            <el-table-column label="科室" prop="dname"></el-table-column>
            <el-table-column label="操作">
              <template #default="scope">
                <el-button @click="viewRecordDetails(scope.row)" size="mini">查看详情</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>

        <!-- Tab 3 -->
        <el-tab-pane label="住院记录">
          <el-table :data="medicalHistories" style="width: 100%">
            <el-table-column label="病情名称" prop="condition_name"></el-table-column>
            <el-table-column label="诊断日期" prop="diagnosis_date"></el-table-column>
            <el-table-column label="备注" prop="remark"></el-table-column>
          </el-table>
        </el-tab-pane>

        <!-- Tab 4 -->
        <el-tab-pane label="急救记录">
          <el-table :data="medicalHistories" style="width: 100%">
            <el-table-column label="病情名称" prop="condition_name"></el-table-column>
            <el-table-column label="诊断日期" prop="diagnosis_date"></el-table-column>
            <el-table-column label="备注" prop="remark"></el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
  </div>





  <!-- 门诊单的dialogue -->
   <!-- 完整内容展示弹框 -->
      <el-dialog v-model="dialogVisibleMedical" width="70%">
       <MedicalRecordTable :records="currentRecord" />
      </el-dialog>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { ElMessage } from 'element-plus';
import { useStore } from "vuex";
import api from "@/services/api";
import MedicalRecordTable from "@/components/CoreButtoms/medicalRecordTable.vue";

const store = useStore();

//保存的时候记得也要把patient_id存起来，有可能被改了
const dialogVisible = ref(false); 
const dialogVisibleMedical = ref(false);
const activeTab = ref("1"); // 默认显示的 tab
const originalPatientId = ref(""); // 身份证号
const patientInfo = ref({
  patient_id: store.state.patient_id || null,
  name: "",
  sex: "",
  idType: "身份证",
  telno: "",
  address: "",
  ethnicity: "",
  age:""
});
const allergyInfo = ref([
  { allergy_name: "", severity: "", remark: "" },
]);
const medicalHistories = ref([
  { condition_name: "", diagnosis_date: "", remark: "" },
]);
// 门诊记录
const medicalRecords = ref([
  {
    record_id: null,
    timestamp: "",
    dname:"",
    wname:"", //对应doctor name
    chief_complaint: "",
    remark: "",
    hospital: "",
    type: "",
    companion: "",
    present_illness: "",
    temperature: "",
    pulse: "",
    sbp: "",
    dbp: "",
    pulmonary: "",
    consciousness: "",
    measures: "",
    observation: "",
    assessment: "",
  },
]);

// 当前查看的门诊记录详情
const currentRecord = ref({});



// 查看记录详情
const viewRecordDetails = (record) => {
  currentRecord.value = { ...record };
  dialogVisibleMedical.value = true;
};

// 打开 Dialog
const openDialog = () => {
  dialogVisible.value = true;
};

// 获取患者信息
const fetchPatientInfo = async () => {
  const patientId = patientInfo.value.patient_id;
  if (patientId) {
    try {
      const response = await api.get(`/patients/${patientId}`);
      console.log("获取患者信息成功:", response.data[0]);
      const patientData = response.data[0];
      patientInfo.value.name = patientData.name || "";
      patientInfo.value.sex = patientData.sex || "";
      patientInfo.value.telno = patientData.telno || "";
      patientInfo.value.address = patientData.address || "";
      patientInfo.value.ethnicity = patientData.ethnicity || "";

      // 如果证件类型是身份证，计算年龄
      if (patientInfo.value.idType === "身份证" && patientId) {
        const age = calculateAge(patientId);
        patientInfo.value.age = age;
      }

      // 获取并设置过敏信息
      allergyInfo.value = patientData.allergies || [];
      // 获取并设置既往史信息
      medicalHistories.value = patientData.medical_histories || [];
      // 获取并设置门诊记录
      // 填充门诊记录
      try{
        const response = await api.get(`/record/medical-records/patientId/${patientId}`);
        console.log(response)
        medicalRecords.value = response.data.map(record => ({
        record_id: record.record_id || null,
        timestamp: record.timestamp || "",
        dname: record.department?.dname || "", // 科室名称
        wname: record.doctor?.name || "", // 医生姓名
        chief_complaint: record.chief_complaint || "",
        remark: record.remark || "",
        hospital: record.hospital || "",
        type: record.type || "",
        companion: record.companion || "",
        present_illness: record.present_illness || "",
        temperature: record.temperature || "",
        pulse: record.pulse || "",
        sbp: record.sbp || "",
        dbp: record.dbp || "",
        pulmonary: record.pulmonary || "",
        consciousness: record.consciousness || "",
        measures: record.measures || "",
        observation: record.observation || "",
        assessment: record.assessment || "",
      }));
      }catch (error) {
      console.error("获取门诊记录失败:", error);
    }
      
    } catch (error) {
      console.error("获取患者信息失败:", error);
    }
  }
};


// 计算年龄的函数
const calculateAge = (idNumber) => {
  const birthDateStr = idNumber.substring(6, 14);
  const birthYear = parseInt(birthDateStr.substring(0, 4), 10);
  const birthMonth = parseInt(birthDateStr.substring(4, 6), 10);
  const birthDay = parseInt(birthDateStr.substring(6, 8), 10);

  const today = new Date();
  const birthDate = new Date(birthYear, birthMonth - 1, birthDay);

  let age = today.getFullYear() - birthDate.getFullYear();
  const m = today.getMonth() - birthDate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }

  return age;
};

// 验证身份证号
const validatePatientId = async () => {
  const patientId = originalPatientId.value;

  if (patientId && patientId.length === 18) {
    try {
      const response = await api.get(`/patients/${patientId}`);
      if (response.data.length === 0) {
        ElMessage.error("该患者不存在");
      } else {
        if (response.data[0].idType === patientInfo.value.idType) {
          ElMessage.success("患者信息验证成功");
          patientInfo.value.patient_id = originalPatientId.value;
          fetchPatientInfo();
        } else {
          ElMessage.error("请校验患者证件类型");
        }
      }
    } catch (error) {
      ElMessage.error("检查患者失败，请稍后再试");
    }
  } else if (patientId && patientId.length !== 18) {
    ElMessage.error("请输入有效的18位身份证号");
  }
};

// 页面加载时预加载患者信息
onMounted(() => {
  if (patientInfo.value.patient_id) {
    fetchPatientInfo();
  }
});
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}
</style>
