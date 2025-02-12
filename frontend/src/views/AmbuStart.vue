<template>
  <div class="operation-form">
    <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />
    
    <el-card class="form-card">
      <el-form :model="formData" label-width="120px">
        <div class="form-row">
          <el-form-item label="急救单">
            <span>{{ operationId }}</span>
          </el-form-item>
          
          <el-form-item label="患者身份证号">
            <el-input v-model="formData.patient_id" placeholder="若未知请先进入下一步" style="width:260px"/>
          </el-form-item>
        </div>

        <!-- 使用 el-row 和 el-col 控制布局 -->
        <el-row gutter={20}>
          <el-col :span="12">
            <el-form-item label="司机">
              <el-select v-model="formData.driver" filterable placeholder="请选择司机" @change="fetchDrivers">
                <el-option
                  v-for="driver in driverList"
                  :key="driver.id"
                  :label="driver.name"
                  :value="driver.name">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="12">
            <el-form-item label="医师">
              <el-select v-model="formData.physician" filterable placeholder="请选择医师" @change="fetchPhysicians">
                <el-option
                  v-for="physician in physicianList"
                  :key="physician.id"
                  :label="physician.name"
                  :value="physician.name">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row gutter={20}>
          <el-col :span="12">
            <el-form-item label="护士">
              <el-select v-model="formData.nurse" filterable placeholder="请选择护士" @change="fetchNurses">
                <el-option
                  v-for="nurse in nurseList"
                  :key="nurse.id"
                  :label="nurse.name"
                  :value="nurse.name">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="12">
            <el-form-item label="抢救员">
              <el-select v-model="formData.paramedic" filterable placeholder="请选择抢救员" @change="fetchParamedics">
                <el-option
                  v-for="paramedic in paramedicList"
                  :key="paramedic.id"
                  :label="paramedic.name"
                  :value="paramedic.name">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row gutter={20}>
          <el-col :span="12">
            <el-form-item label="担架工">
              <el-select v-model="formData.stretcher_bearer" filterable placeholder="请选择担架工" @change="fetchStretcherBearers">
                <el-option
                  v-for="stretcherBearer in stretcherBearerList"
                  :key="stretcherBearer.id"
                  :label="stretcherBearer.name"
                  :value="stretcherBearer.name">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="特殊处理">
          <el-checkbox-group v-model="formData.specialHandling">
            <el-checkbox label="中毒">中毒</el-checkbox>
            <el-checkbox label="传染病">传染病</el-checkbox>
          </el-checkbox-group>
        </el-form-item>

        <el-divider>救护车设备与药品检查</el-divider>
        <el-checkbox-group v-model="formData.equipmentCheck">
          <el-checkbox v-for="item in equipmentList" :key="item" :label="item">{{ item }}</el-checkbox>
        </el-checkbox-group>

        <el-form-item>
          <el-button type="primary" @click="submitForm">提交</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import api from "@/services/api";
import NavigationBar from '@/components/NavigationBars.vue';
import { ElMessage } from 'element-plus';

const store = useStore();
const currentStep = ref('出车准备');
const operationId = computed(() => store.state.operation_id);

const formData = ref({
  driver: '',
  physician: '',
  nurse: '',
  paramedic: '',
  stretcher_bearer: '',
  patient_id: '',
  specialHandling: [],
  equipmentCheck: []
});

const driverList = ref([]);
const physicianList = ref([]);
const nurseList = ref([]);
const paramedicList = ref([]);
const stretcherBearerList = ref([]);

const fetchDrivers = async () => {
  try {
    const response = await api.get(`/health_personnel/dno/h1`);
    driverList.value = response.data.map(person => ({
      id: person.id,
      name: person.name
    }));
  } catch (error) {
    console.error('Error fetching drivers:', error);
  }
};

const fetchPhysicians = async () => {
  try {
    const response = await api.get(`/health_personnel`);
    physicianList.value = response.data.map(person => ({
      id: person.id,
      name: person.name
    }));
  } catch (error) {
    console.error('Error fetching physicians:', error);
  }
};

const fetchNurses = async () => {
  try {
    const response = await api.get(`/health_personnel/dno/h2`);
    nurseList.value = response.data.map(person => ({
      id: person.id,
      name: person.name
    }));
  } catch (error) {
    console.error('Error fetching nurses:', error);
  }
};

const fetchParamedics = async () => {
  try {
    const response = await api.get(`/health_personnel/dno/q1`);
    paramedicList.value = response.data.map(person => ({
      id: person.id,
      name: person.name
    }));
  } catch (error) {
    console.error('Error fetching paramedics:', error);
  }
};

const fetchStretcherBearers = async () => {
  try {
    const response = await api.get(`/health_personnel/dno/h3`);
    stretcherBearerList.value = response.data.map(person => ({
      id: person.id,
      name: person.name
    }));
  } catch (error) {
    console.error('Error fetching stretcher bearers:', error);
  }
};

onMounted(() => {
  fetchDrivers();
  fetchPhysicians();
  fetchNurses();
  fetchParamedics();
  fetchStretcherBearers();
});

const equipmentList = [
  '氧气瓶', '呼吸机', '心电监护仪', '急救药品', '担架床'
];

const submitForm = () => {
  console.log('提交数据:', formData.value);
  ElMessage.success('数据已提交');
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

.form-row {
  margin-bottom: 20px;
}

.el-form-item {
  margin-bottom: 10px;
}

.el-button {
  margin-top: 20px;
}
</style>
