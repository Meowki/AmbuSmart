<template>
  <div>
    <el-form :model="assessmentData" ref="assessmentForm">
      <!-- 1. 高危状态评估 -->
      <h3>高危状态评估</h3>
      <el-form-item label="高危状态评估">
        <el-checkbox-group v-model="assessmentData.highRisk">
          <el-row>
            <el-col v-for="option in highRiskOptions" :key="option.value" :span="8">
              <el-checkbox :label="option.value">{{ option.label }}</el-checkbox>
            </el-col>
          </el-row>
        </el-checkbox-group>
      </el-form-item>
      <!-- 如果选中“其它”，显示附加说明输入框 -->
      <el-form-item v-if="assessmentData.highRisk.includes('其它')" label="其它说明">
        <el-input v-model="assessmentData.otherHighRisk"></el-input>
      </el-form-item>

      <!-- 2. Killip 分级 -->
      <h3>Killip 分级</h3>
      <el-form-item label="Killip 分级">
        <el-select v-model="assessmentData.Killip_score" placeholder="请选择 Killip 分级">
          <el-option
            v-for="option in killipOptions"
            :key="option.value"
            :label="option.label + ' - ' + option.description"
            :value="option.value"
          />
        </el-select>
      </el-form-item>

      <!-- 3. 初步诊断，带自动补全 -->
      <h3>初步诊断</h3>
      <el-form-item label="初步诊断">
        <el-autocomplete
          v-model="assessmentData.Killip_diagnosis"
          :fetch-suggestions="querySearch"
          placeholder="请输入初步诊断"
        ></el-autocomplete>
      </el-form-item>

      <!-- 提交按钮 -->
      <el-button type="primary" @click="submitAssessment" style="margin-top: 20px;">提交评估</el-button>
    </el-form>
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import axios from "axios";
import { ElMessage } from "element-plus";
import { useStore } from "vuex";

export default {
  setup() {
    const store = useStore();
    const operation_id = store.state.operation_id || "20202";

    const assessmentData = ref({
      highRisk: [],               // 复选结果（数组）
      otherHighRisk: "",          // “其它”说明
      Killip_score: "",           // Killip 分级（下拉选项）
      Killip_diagnosis: ""        // 初步诊断（自动补全）
    });

    // 高危状态选项（仅显示选项名称）
    const highRiskOptions = [
      { value: "持续性胸闷/胸痛", label: "持续性胸闷/胸痛" },
      { value: "间断性胸闷/胸痛", label: "间断性胸闷/胸痛" },
      { value: "胸痛症状已缓解", label: "胸痛症状已缓解" },
      { value: "腹痛", label: "腹痛" },
      { value: "休克", label: "休克" },
      { value: "呼吸困难", label: "呼吸困难" },
      { value: "心衰", label: "心衰" },
      { value: "恶性心律失常", label: "恶性心律失常" },
      { value: "心肺复苏", label: "心肺复苏" },
      { value: "合并出血", label: "合并出血" },
      { value: "其它", label: "其它" }
    ];

    // Killip 分级选项（下拉框），每个选项带有具体说明
    const killipOptions = [
      { value: "Killip I", label: "Killip I", description: "无明显心衰迹象" },
      { value: "Killip II", label: "Killip II", description: "轻度心衰：少量肺部湿罗音" },
      { value: "Killip III", label: "Killip III", description: "重度心衰：大量湿罗音/肺水肿" },
      { value: "Killip IV", label: "Killip IV", description: "心源性休克" }
    ];

    // 初步诊断建议数据（静态示例，可动态获取）
    const diagnosisOptions = [
      { value: "急性心肌梗死" },
      { value: "不稳定型心绞痛" },
      { value: "胸膜炎" },
      { value: "食管痉挛" },
      { value: "其它" }
    ];

    // 辅助输入建议函数
    const querySearch = (queryString, cb) => {
      const results = diagnosisOptions.filter(item => {
        return item.value.toLowerCase().includes(queryString.toLowerCase());
      });
      cb(results);
    };

    // 提交评估时：Killip_content 保存高危状态和其它说明，格式为 JSON 字符串
    const submitAssessment = async () => {
      console.log("评估数据：", assessmentData.value);
      try {
        await axios.put(`/operation_histories/update/${operation_id}`, {
          Killip_content: {
            highRisk: assessmentData.value.highRisk,
            otherHighRisk: assessmentData.value.otherHighRisk
          },
          Killip_score: assessmentData.value.Killip_score,
          Killip_diagnosis: assessmentData.value.Killip_diagnosis
        });
        ElMessage.success("评估提交成功");
      } catch (error) {
        console.error("submitAssessment error:", error);
        ElMessage.error("评估提交失败");
      }
    };

    // 从后端获取数据并展示到前端
    const fetchScoreData = async () => {
      try {
        const response = await axios.get(`/operation_histories/operationId/${operation_id}`);
        const data = response.data;
        console.log("fetchData:"+data.Killip_content);

        // 如果后端返回了 Killip_content，则解析并填充高危状态部分
        if (data.Killip_content) {
          const content = data.Killip_content;
          // 只有存在的内容才会被选中
          assessmentData.value.highRisk = content.highRisk || [];
          assessmentData.value.otherHighRisk = content.otherHighRisk || "";
        }
        // 填充 Killip_score
        if (data.Killip_score) {
          // 如果返回的 Killip_score 与下拉选项匹配，则直接赋值；否则依然赋值，但下拉框可能只显示值而无描述
          const found = killipOptions.find(option => option.value === data.Killip_score);
          assessmentData.value.Killip_score = found ? found.value : data.Killip_score;
        }
        // 填充初步诊断
        assessmentData.value.Killip_diagnosis = data.Killip_diagnosis || "";
      } catch (error) {
        console.error("fetchScoreData error:", error);
      }
    };

    // 初始化数据
    onMounted(() => {
      fetchScoreData();
    });

    return {
      assessmentData,
      highRiskOptions,
      killipOptions,
      querySearch,
      submitAssessment,
    };
  }
};
</script>

<style scoped>
.assessment-form {
  margin-top: 20px;
}
</style>
