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
            <span>{{ sceneData.operation_id }}</span>
          </el-form-item>
        </div>
        <!-- 第一行 -->
        <el-row gutter="{20}">
          <!-- 身份证号 -->
          <el-col :span="12">
            <el-form-item label="患者身份证号">
              <el-input
                v-model="originalPatientId"
                @blur="validatePatientId"
                placeholder="请输入患者身份证号（预留公安扫脸接口）"
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

        <el-row gutter="{20}">
          <el-col :span="8">
            <el-form-item label="姓名">
              <el-input v-model="formData.name" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="性别">
              <el-input v-model="formData.sex" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="年龄">
              <el-input v-model="formData.age" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row gutter="{20}">
          <el-col :span="8">
            <el-form-item label="民族">
              <el-input
                v-model="formData.ethnicity"
                :disabled="true"
              ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="电话">
              <el-input v-model="formData.telno" :disabled="true"></el-input>
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-form-item label="地址">
              <el-input v-model="formData.address" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider></el-divider>

        <!-- 暂时放一下，后面可能考虑加高德api，并且通过计算得到最近的医院 -->
        <!-- 现场地址与医院选择模块 -->
        <el-row gutter="20">
          <el-col :span="12">
            <el-form-item label="现场地址">
              <!-- 添加地图搜索标记类名 -->
              <el-input
                v-model="sceneData.scene_address"
                placeholder="请输入或选择现场位置"
                class="map-search-input"
                @focus="handleAddressFocus"
              >
                <!-- 预留地图图标插槽 -->
                <template #suffix>
                  <img
                    src="/icon/map.png"
                    @click="openMapPicker('scene')"
                    class="map-icon"
                  />
                </template>
              </el-input>
            </el-form-item>
          </el-col>

          <el-col :span="12">
            <el-form-item label="目标医院">
              <!-- 改为可搜索的下拉框 -->
              <el-select
                v-model="sceneData.destination"
                filterable
                placeholder="请选择或搜索医院"
                :loading="hospitalLoading"
                @focus="fetchNearbyHospitals"
              >
                <el-option
                  v-for="hospital in hospitalOptions"
                  :key="hospital.id"
                  :label="hospital.name"
                  :value="hospital.id"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <!-- 隐藏的经纬度字段（后续API需要） -->
        <el-input v-model="sceneData.scene_lat" type="hidden" />
        <el-input v-model="sceneData.scene_lng" type="hidden" />

        <el-row gutter="20">
          <el-col :span="12">
            <el-form-item label="急救性质">
              <el-select
                v-model="sceneData.emergency_type"
                placeholder="请选择急救性质"
              >
                <el-option label="院前急救" value="院前急救"></el-option>
                <el-option label="转院" value="转院"></el-option>
                <el-option label="其他" value="其他"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="病情分级">
              <el-select
                v-model="sceneData.severity_level"
                placeholder="请选择病情分级"
              >
                <el-option
                  label="Ⅰ级（濒危）"
                  value="Ⅰ级（濒危）"
                  title="呼吸心跳骤停/严重创伤/大出血等需立即抢救"
                />
                <el-option
                  label="Ⅱ级（危重）"
                  value="Ⅱ级（危重）"
                  title="心梗/中风/严重烧伤等10分钟内需处置"
                />
                <el-option
                  label="Ⅲ级（急症）"
                  value="Ⅲ级（急症）"
                  title="骨折/哮喘发作等30分钟内需处置"
                />
                <el-option
                  label="Ⅳ级（非急症）"
                  value="Ⅳ级（非急症）"
                  title="感冒/轻微外伤等可等待处置"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider></el-divider>
        <el-row gutter={20}>
          <el-col :span="8">
            <el-form-item label="供史者">
            <el-select
                v-model="sceneData.informant"
                placeholder="请选择"
              >
                <el-option
                  label="本人"
                  value="本人"
                />
                <el-option
                  label="亲属"
                  value="亲属"
                />
                <el-option
                  label="目击者"
                  value="目击者"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>


        <el-form-item>
          <el-button type="primary" @click="nextStep">到达现场</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import { useStore } from "vuex";
import api from "@/services/api";
import NavigationBar from "@/components/NavigationBars.vue";
import { ElMessage } from "element-plus";
import { useRouter } from "vue-router"; // 引入路由

const currentStep = ref("信息采集");
const store = useStore();
const router = useRouter(); // 用于跳转

const formData = ref({
  patient_id: store.state.patient_id || null, // 从store获取patient_id，若没有则为空
  idType: "身份证",
  name: "",
  sex: "",
  telno: "",
  address: "",
  ethnicity: "",
  age: "",
});

const sceneData = ref({
  patient_id: store.state.patient_id || null,
  operation_id: store.state.operation_id, // 从store获取operation_id
  scene_address: "",
  destination: "",
  emergency_type: "",
  severity_level: "",
  arrival_on_scene_time: new Date().toISOString(), // 设置当前时间
  informant:"",
  scene_lat: null, // 预留纬度
  scene_lng: null, // 预留经度
});

const originalPatientId = ref(formData.value.patient_id); // 用于暂存patient_id的值

// 获取患者信息
const fetchPatientInfo = async () => {
  const patientId = formData.value.patient_id;
  if (patientId) {
    try {
      const response = await api.get(`/patients/${patientId}`);
      console.log("获取患者信息成功:", response.data[0]);
      const patientData = response.data[0];
      formData.value.name = patientData.name || "";
      formData.value.sex = patientData.sex || "";
      formData.value.telno = patientData.telno || "";
      formData.value.address = patientData.address || "";
      formData.value.ethnicity = patientData.ethnicity || "";
    } catch (error) {
      console.error("获取患者信息失败:", error);
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
        ElMessage.error("该患者不存在");
      } else {
        formData.value.patient_id = originalPatientId.value;
        // 若患者存在，重新加载患者信息
        fetchPatientInfo();
        sceneData.value.patient_id = originalPatientId.value;
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
  if (formData.value.patient_id) {
    fetchPatientInfo();
  }
});
const hospitalOptions = ref([]); // 医院选项列表
const hospitalLoading = ref(false);

// 方法部分（当前模拟实现）
const fetchNearbyHospitals = async () => {
  hospitalLoading.value = true;
  // TODO: 后续替换为高德API请求
  hospitalOptions.value = [
    { id: 1, name: "第一人民医院" },
    { id: 2, name: "中心医院急诊部" },
    { id: 3, name: "协和医院分院" },
  ];
  hospitalLoading.value = false;
};

const openMapPicker = (type) => {
  // TODO: 后续实现地图选择器弹窗
  console.log("打开地图选择器:", type);
};

// 伪代码示例
// const fetchNearbyHospitals = async () => {
//   const { lng, lat } = sceneData.value
//   const res = await AMap.placesSearch({
//     type: '医院',
//     location: [lng, lat]
//   })
//   hospitalOptions.value = res.pois.map(p => ({
//     id: p.id,
//     name: p.name
//   }))
// }

// 更新operation_histories
const updateOperationHistory = async () => {
  const operationHistoryData = {
    patient_id: formData.value.patient_id,
    operation_id: store.state.operation_id,
    scene_address: sceneData.value.scene_address,
    destination: "",
    emergency_type: "",
    severity_level: "",
    arrival_on_scene_time: new Date().toISOString(), // 设置当前时间
  };

  try {
    const response = await api.put(
      `/operation_histories/update/${store.state.operation_id}`,
      operationHistoryData
    );
    console.log("OperationHistoryData:" + operationHistoryData);
    console.log("更新成功:", response);
    return true;
  } catch (error) {
    console.error("更新失败:", error);
    return false;
  }
};

// 下一步处理函数
const nextStep = () => {
  const updateSuccess = updateOperationHistory();
  if (updateSuccess) {
    router.push("/AmbuCore"); // 跳转到/AmbuInfo页面
  } else {
    ElMessage.error("更新操作历史失败，请稍后再试。");
  }
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

/* 地图图标交互优化 */
.map-icon {
  width: 24px;
  height: 24px;
  &:hover {
    color: #66b1ff;
  }
}
</style>
