<template>
  <div class="operation-form">
    <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />

    <el-card class="form-card">
      <el-form :model="formData" label-width="120px">
        <!-- 病人信息部分 -->
        <el-row gutter={20}>
          <el-col :span="8">
            <el-form-item label="身份证号">
              <el-input v-model="originalPatientId" 
                        @blur="validatePatientId"
                        placeholder="请输入患者身份证号" 
                        style="width:260px"/>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item label="姓名">
              <span>{{ formData.name }}</span>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item label="性别">
              <span>{{ formData.sex }}</span>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row gutter={20}>
          <el-col :span="8">
            <el-form-item label="电话">
              <span>{{ formData.telno }}</span>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item label="地址">
              <span>{{ formData.address }}</span>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item label="民族">
              <span>{{ formData.ethnicity }}</span>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 新增字段部分 -->
        <el-row gutter={20}>
          <el-col :span="12">
            <el-form-item label="目的地">
              <el-input v-model="sceneData.scene_address" placeholder="请输入目的地" style="width:260px"/>
            </el-form-item>
          </el-col>

          <el-col :span="12">
            <el-form-item label="目标医院">
              <el-input v-model="sceneData.destination" placeholder="请输入目标医院" style="width:260px"/>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row gutter={20}>
          <el-col :span="12">
            <el-form-item label="急救性质">
              <el-select v-model="sceneData.emergency_type" placeholder="请选择急救性质" style="width:260px">
                <el-option label="紧急" value="emergency"></el-option>
                <el-option label="非紧急" value="non-emergency"></el-option>
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="12">
            <el-form-item label="病情分级">
              <el-select v-model="sceneData.severity_level" placeholder="请选择病情分级" style="width:260px">
                <el-option label="轻度" value="mild"></el-option>
                <el-option label="中度" value="moderate"></el-option>
                <el-option label="重度" value="severe"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="到达现场时间">
          <el-input v-model="sceneData.arrival_on_scene_time" placeholder="请输入到达现场时间" style="width:260px"/>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="nextStep">下一步</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useStore } from 'vuex';
import api from "@/services/api";
import NavigationBar from '@/components/NavigationBars.vue';
import { ElMessage } from 'element-plus';

const currentStep = ref('信息采集');
const store = useStore();

const formData = ref({
  patient_id: store.state.patient_id || '', // 从store获取patient_id，若没有则为空
  name: '',
  sex: '',
  telno: '',
  address: '',
  ethnicity: ''
});

const sceneData = ref({
  scene_address: '',
  destination: '',
  emergency_type: '',
  severity_level: '',
  arrival_on_scene_time: ''
});

const originalPatientId = ref(formData.value.patient_id); // 用于暂存patient_id的值

// 获取患者信息
const fetchPatientInfo = async () => {
  const patientId = formData.value.patient_id;
  if (patientId) {
    try {
      const response = await api.get(`/patients/${patientId}`);
      console.log('获取患者信息成功:', response.data[0]);
      const patientData = response.data[0];
      formData.value.name = patientData.name || '';
      formData.value.sex = patientData.sex || '';
      formData.value.telno = patientData.telno || '';
      formData.value.address = patientData.address || '';
      formData.value.ethnicity = patientData.ethnicity || '';
    } catch (error) {
      console.error('获取患者信息失败:', error);
    }
  }
};

// 验证patient_id
const validatePatientId = async () => {
  const patientId = originalPatientId.value;

  // 确保 patient_id 不为 null 或 undefined
  if (patientId && patientId.length === 18) {
    try {
      const response = await api.get(`/patients/${patientId}`);
      if (response.data.length === 0) {
        ElMessage.error('该患者不存在');
      } else {
        formData.value.patient_id = originalPatientId.value;
        // 若患者存在，重新加载患者信息
        fetchPatientInfo();
      }
    } catch (error) {
      ElMessage.error('检查患者失败，请稍后再试');
    }
  } else if (patientId && patientId.length !== 18) {
    ElMessage.error('请输入有效的18位身份证号');
  }
};

// 页面加载时预加载患者信息
onMounted(() => {
  if (formData.value.patient_id) {
    fetchPatientInfo();
  }
});

// 下一步处理函数
const nextStep = () => {
  console.log("患者信息：", formData.value);
  console.log("目的地信息：", sceneData.value);
};
</script>

<style scoped>
.operation-form {
  max-width: 800px;
  margin: 0 auto;
}

.form-card {
  margin-top: 20px;
}

.el-form-item {
  margin-bottom: 10px;
}

.el-button {
  margin-top: 20px;
}
</style>
