<template>
  <div class="operation-form">
    <NavigationBar
      :activeStep="currentStep"
      @exit="() => console.log('退出')"
    />

    <el-card class="form-card">
      <el-form :model="formData" label-width="120px">
        <div class="form-row">
          <!-- 急救单独占一行 -->
          <el-form-item label="急救单">
            <span>{{ operationId }}</span>
          </el-form-item>
        </div>

        <!-- 第二行：身份证号和证件类型 -->
        <el-row gutter="{20}">
          <!-- 身份证号 -->
          <el-col :span="12">
            <el-form-item label="患者身份证号">
              <el-input
                v-model="originalPatientId"
                @blur="validatePatientId"
                placeholder="若未知请先进入下一步"
                maxlength="18"
              />
            </el-form-item>
          </el-col>
          <!-- 证件类型 -->
          <el-col :span="12">
            <el-form-item label="证件类型">
              <el-select v-model="formData.idType" placeholder="请选择证件类型">
                <el-option label="身份证" value="身份证"></el-option>
                <el-option label="护照" value="护照"></el-option>
                <el-option
                  label="外国人永久居留身份证"
                  value="外国人永久居留身份证"
                ></el-option>
                <el-option
                  label="港澳居民来往内地通行证"
                  value="港澳居民来往内地通行证"
                ></el-option>
                <el-option
                  label="台湾居民来往大陆通行证"
                  value="台湾居民来往大陆通行证"
                ></el-option>
                <el-option label="其他" value="其他"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 选择人员 -->
        <el-row gutter="{20}">
          <el-col :span="12">
            <el-form-item label="司机">
              <el-select
                v-model="formData.driver"
                filterable
                placeholder="请选择司机"
                @change="fetchDrivers"
              >
                <el-option
                  v-for="driver in driverList"
                  :key="driver.id"
                  :label="driver.name"
                  :value="driver.name"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="12">
            <el-form-item label="医师">
              <el-select
                v-model="formData.physician"
                filterable
                placeholder="请选择医师"
                @change="fetchPhysicians"
              >
                <el-option
                  v-for="physician in physicianList"
                  :key="physician.id"
                  :label="physician.name"
                  :value="physician.name"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 选择其他人员 -->
        <el-row gutter="{20}">
          <el-col :span="12">
            <el-form-item label="护士">
              <el-select
                v-model="formData.nurse"
                filterable
                placeholder="请选择护士"
                @change="fetchNurses"
              >
                <el-option
                  v-for="nurse in nurseList"
                  :key="nurse.id"
                  :label="nurse.name"
                  :value="nurse.name"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>

          <el-col :span="12">
            <el-form-item label="抢救员">
              <el-select
                v-model="formData.paramedic"
                filterable
                placeholder="请选择抢救员"
                @change="fetchParamedics"
              >
                <el-option
                  v-for="paramedic in paramedicList"
                  :key="paramedic.id"
                  :label="paramedic.name"
                  :value="paramedic.name"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row gutter="{20}">
          <el-col :span="12">
            <el-form-item label="担架工">
              <el-select
                v-model="formData.stretcher_bearer"
                filterable
                placeholder="请选择担架工"
                @change="fetchStretcherBearers"
              >
                <el-option
                  v-for="stretcherBearer in stretcherBearerList"
                  :key="stretcherBearer.id"
                  :label="stretcherBearer.name"
                  :value="stretcherBearer.name"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 特殊处理 -->
        <el-form-item label="特殊处理">
          <el-checkbox-group
            v-model="formData.specialHandling"
            @change="handleSpecialHandlingChange"
          >
            <el-checkbox label="中毒">中毒</el-checkbox>
            <el-checkbox label="传染病">传染病</el-checkbox>
          </el-checkbox-group>
        </el-form-item>

        <el-divider>救护车设备与药品检查</el-divider>

        <!-- 折叠面板展示设备和药品 -->
        <el-collapse>
          <el-collapse-item
            v-for="(category, index) in categorizedEquipment"
            :key="index"
            :name="category.name"
          >
            <template #title>{{ category.name }}</template>
            <el-checkbox-group
              v-model="formData.equipmentCheck[category.name]"
              :disabled="category.disabled"
            >
              <el-checkbox
                v-for="item in category.items"
                :key="item"
                :label="item"
                >{{ item }}</el-checkbox
              >
            </el-checkbox-group>
          </el-collapse-item>
        </el-collapse>

        <el-form-item>
          <!-- 修改按钮为"下一步" -->
          <el-button type="primary" @click="nextStep">确认出车</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router"; // 引入路由
import { useStore } from "vuex";
import api from "@/services/api";
import NavigationBar from "@/components/NavigationBars.vue";
import { ElMessage } from "element-plus";

const router = useRouter(); // 用于跳转
const store = useStore();
const currentStep = ref("出车准备");
const operationId = computed(() => store.state.operation_id);

const originalPatientId = ref(""); // 用于临时保存用户输入的patient_id
const formData = ref({
  idType: "身份证",
  driver: "",
  physician: "",
  nurse: "",
  paramedic: "",
  stretcher_bearer: "",
  patient_id: null,
  specialHandling: [],
  equipmentCheck: {
    基础设备: [],
    基础药品: [],
    中毒处理: [],
    传染病隔离: [],
  },
});

const driverList = ref([]);
const physicianList = ref([]);
const nurseList = ref([]);
const paramedicList = ref([]);
const stretcherBearerList = ref([]);

// 验证patient_id
const validatePatientId = async () => {
  const patientId = originalPatientId.value;

  // 确保 patient_id 不为 null 或 undefined
  if (patientId && patientId.length === 18) {
    try {
      const response = await api.get(`/patients/${patientId}`);
      if (response.data.length === 0) {
        ElMessage.error("该患者不存在");
      } else {
        if (response.data[0].idType === formData.value.idType) {
          ElMessage.success("患者信息验证成功");
          formData.value.patient_id = originalPatientId.value;
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

const fetchDrivers = async () => {
  const response = await api.get(`/health_personnel/dno/h1`);
  driverList.value = response.data.map((person) => ({
    id: person.id,
    name: person.name,
  }));
};

const fetchPhysicians = async () => {
  const response = await api.get(`/health_personnel`);
  physicianList.value = response.data.map((person) => ({
    id: person.id,
    name: person.name,
  }));
};

const fetchNurses = async () => {
  const response = await api.get(`/health_personnel/dno/h2`);
  nurseList.value = response.data.map((person) => ({
    id: person.id,
    name: person.name,
  }));
};

const fetchParamedics = async () => {
  const response = await api.get(`/health_personnel/dno/q1`);
  paramedicList.value = response.data.map((person) => ({
    id: person.id,
    name: person.name,
  }));
};

const fetchStretcherBearers = async () => {
  const response = await api.get(`/health_personnel/dno/h3`);
  stretcherBearerList.value = response.data.map((person) => ({
    id: person.id,
    name: person.name,
  }));
};

onMounted(() => {
  fetchDrivers();
  fetchPhysicians();
  fetchNurses();
  fetchParamedics();
  fetchStretcherBearers();
});

// 设备和药品的分类数据
// 设备和药品的分类数据
const categorizedEquipment = ref([
  {
    name: "基础设备",
    items: [
      "氧气瓶（压力≥1000psi）",
      "便携式呼吸气囊",
      "心电监护仪/除颤仪",
      "脊柱板/铲式担架",
      "负压吸引器",
    ],
    disabled: false,
  },
  {
    name: "基础药品",
    items: ["肾上腺素", "阿托品", "硝酸甘油片", "50%葡萄糖", "生理盐水"],
    disabled: false,
  },
  {
    name: "中毒处理",
    items: [
      "活性炭（口服解毒剂）",
      "纳洛酮（阿片类过量）",
      "阿托品（有机磷中毒）",
      "洗胃包",
    ],
    disabled: true,
  },
  {
    name: "传染病隔离",
    items: ["三级防护服", "N95口罩", "护目镜/面屏", "含氯消毒剂", "医疗废物袋"],
    disabled: true,
  },
]);

// 根据特殊处理选项更新设备和药品
const handleSpecialHandlingChange = () => {
  categorizedEquipment.value.forEach((category) => {
    if (
      formData.value.specialHandling.includes("中毒") &&
      category.name === "中毒处理"
    ) {
      category.disabled = false;
    } else if (
      formData.value.specialHandling.includes("传染病") &&
      category.name === "传染病隔离"
    ) {
      category.disabled = false;
    } else {
      // 中毒和传染病处理未选中时，保留其他设备类别可用
      if (category.name === "中毒处理" || category.name === "传染病隔离") {
        category.disabled = true;
      }
    }
  });
};

// 校验当前勾选的设备和药品
const checkSelectedItems = () => {
  // 只检查当前启用的类别
  const allSelected = categorizedEquipment.value.every((category) => {
    if (category.disabled) return true; // 跳过已禁用的类别
    return (
      formData.value.equipmentCheck[category.name] &&
      formData.value.equipmentCheck[category.name].length > 0
    );
  });
  return allSelected;
};

// 更新operation_histories
const updateOperationHistory = async () => {
  const operationHistoryData = {
    operation_id: operationId.value,
    driver: formData.value.driver,
    physician: formData.value.physician,
    nurse: formData.value.nurse,
    paramedic: formData.value.paramedic,
    stretcher_bearer: formData.value.stretcher_bearer,
    patient_id: formData.value.patient_id,
    dispatch_time: new Date().toISOString(), // 设置当前时间
  };

  try {
    const response = await api.put(
      `/operation_histories/update/${operationId.value}`,
      operationHistoryData
    );
    console.log("OperationHistoryData:" + operationHistoryData);
    if (formData.value.patient_id) {
      // 记录到 Vuex 中
      store.commit("setPatientId", formData.value.patient_id); // 使用 useStore 来提交 mutation
      console.log("Patient ID stored in Vuex:", store.state.patient_id);
    }
    console.log("更新成功:", response);
    ElMessage.success("急救信息已更新");
    return true;
  } catch (error) {
    console.error("更新失败:", error);
    ElMessage.error("更新急救信息失败");
    return false;
  }
};

// 下一步处理函数
const nextStep = async () => {
  if (checkSelectedItems()) {
    const updateSuccess = await updateOperationHistory();
    if (updateSuccess) {
      router.push("/AmbuInfo"); // 跳转到/AmbuInfo页面
    } else {
      ElMessage.error("更新操作历史失败，请稍后再试。");
    }
  } else {
    ElMessage.error("请勾选所有必选项！");
  }
};
</script>

<style scoped>
.operation-form {
  max-width: 1000px;
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
