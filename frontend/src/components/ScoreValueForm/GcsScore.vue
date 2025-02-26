<template>
  <el-form :model="scoreData.ti" ref="tiForm" label-width="120px">
    <!-- 受伤部位 -->
    <el-row>
      <el-col :span="12">
        <el-form-item label="受伤部位" prop="injury_site">
          <el-select v-model="scoreData.ti.injury_site" @change="updateInjurySiteScore" placeholder="请选择">
            <el-option label="头部" value="头部"></el-option>
            <el-option label="胸部" value="胸部"></el-option>
            <el-option label="腹部" value="腹部"></el-option>
            <el-option label="四肢" value="四肢"></el-option>
            <el-option label="其他" value="其他"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="得分" prop="injury_site_score">
          <el-input v-model="scoreData.ti.injury_site_score" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 损伤类型 -->
    <el-row>
      <el-col :span="12">
        <el-form-item label="损伤类型" prop="injury_type">
          <el-select v-model="scoreData.ti.injury_type" @change="updateInjuryTypeScore" placeholder="请选择">
            <el-option label="创伤" value="创伤"></el-option>
            <el-option label="出血" value="出血"></el-option>
            <el-option label="骨折" value="骨折"></el-option>
            <el-option label="其他" value="其他"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="得分" prop="injury_type_score">
          <el-input v-model="scoreData.ti.injury_type_score" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 意识状态 -->
    <el-row>
      <el-col :span="12">
        <el-form-item label="意识状态" prop="consciousness">
          <el-select v-model="scoreData.ti.consciousness" @change="updateConsciousnessScore" placeholder="请选择">
            <el-option label="清醒" value="清醒"></el-option>
            <el-option label="昏迷" value="昏迷"></el-option>
            <el-option label="嗜睡" value="嗜睡"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="得分" prop="consciousness_score">
          <el-input v-model="scoreData.ti.consciousness_score" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 循环状态 -->
    <el-row>
      <el-col :span="12">
        <el-form-item label="循环状态" prop="circulation">
          <el-select v-model="scoreData.ti.circulation" @change="updateCirculationScore" placeholder="请选择">
            <el-option label="正常" value="正常"></el-option>
            <el-option label="低血压" value="低血压"></el-option>
            <el-option label="休克" value="休克"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="得分" prop="circulation_score">
          <el-input v-model="scoreData.ti.circulation_score" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 呼吸状态 -->
    <el-row>
      <el-col :span="12">
        <el-form-item label="呼吸状态" prop="respiration">
          <el-select v-model="scoreData.ti.respiration" @change="updateRespirationScore" placeholder="请选择">
            <el-option label="正常" value="正常"></el-option>
            <el-option label="呼吸急促" value="呼吸急促"></el-option>
            <el-option label="呼吸衰竭" value="呼吸衰竭"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="得分" prop="respiration_score">
          <el-input v-model="scoreData.ti.respiration_score" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 总得分 -->
    <el-row>
      <el-col :span="12">
        <el-form-item label="总得分" prop="total_score">
          <el-input v-model="scoreData.ti_total_score" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 提交按钮 -->
    <el-button type="primary" @click="submitTI" style="margin-top: 20px;">
      提交创伤指数评分
    </el-button>
  </el-form>
</template>

<script>
import { defineComponent, ref, onMounted } from "vue"; 
import axios from "axios"; 
import { ElMessage } from "element-plus"; 
import { useStore } from "vuex";

export default defineComponent({ 
  name: "TiScore", 
  setup() {
    const store = useStore();
    const operation_id = store.state.operation_id || "20202";

    const scoreData = ref({
      ti: {
        injury_site: "",
        injury_site_score: 0,
        injury_type: "",
        injury_type_score: 0,
        consciousness: "",
        consciousness_score: 0,
        circulation: "",
        circulation_score: 0,
        respiration: "",
        respiration_score: 0,
      },
      ti_total_score: 0,
    });

    // 获取评分数据
    const fetchScoreData = async () => {
      try {
        const response = await axios.get(`/operation_histories/operationId/${operation_id}`);
        const data = response.data;

        // 填充评分项
        scoreData.value.ti = {
          injury_site: data.ti_content.injury_site || "",
          injury_site_score: data.ti_content.injury_site_score || 0,
          injury_type: data.ti_content.injury_type || "",
          injury_type_score: data.ti_content.injury_type_score || 0,
          consciousness: data.ti_content.consciousness || "",
          consciousness_score: data.ti_content.consciousness_score || 0,
          circulation: data.ti_content.circulation || "",
          circulation_score: data.ti_content.circulation_score || 0,
          respiration: data.ti_content.respiration || "",
          respiration_score: data.ti_content.respiration_score || 0,
        };

        // 计算总得分
        updateTotalScore();

      } catch (error) {
        console.error("fetchScoreData error:", error);
      }
    };

    // 更新scoreData的得分
    const updateInjurySiteScore = () => {
      const injurySiteScoreMapping = {
        "头部": 5,
        "胸部": 4,
        "腹部": 3,
        "四肢": 2,
        "其他": 1
      };
      scoreData.value.ti.injury_site_score = injurySiteScoreMapping[scoreData.value.ti.injury_site] || 0;
      updateTotalScore();
    };

    const updateInjuryTypeScore = () => {
      const injuryTypeScoreMapping = {
        "创伤": 5,
        "出血": 4,
        "骨折": 3,
        "其他": 2
      };
      scoreData.value.ti.injury_type_score = injuryTypeScoreMapping[scoreData.value.ti.injury_type] || 0;
      updateTotalScore();
    };

    const updateConsciousnessScore = () => {
      const consciousnessScoreMapping = {
        "清醒": 5,
        "昏迷": 2,
        "嗜睡": 3
      };
      scoreData.value.ti.consciousness_score = consciousnessScoreMapping[scoreData.value.ti.consciousness] || 0;
      updateTotalScore();
    };

    const updateCirculationScore = () => {
      const circulationScoreMapping = {
        "正常": 5,
        "低血压": 3,
        "休克": 1
      };
      scoreData.value.ti.circulation_score = circulationScoreMapping[scoreData.value.ti.circulation] || 0;
      updateTotalScore();
    };

    const updateRespirationScore = () => {
      const respirationScoreMapping = {
        "正常": 5,
        "呼吸急促": 3,
        "呼吸衰竭": 1
      };
      scoreData.value.ti.respiration_score = respirationScoreMapping[scoreData.value.ti.respiration] || 0;
      updateTotalScore();
    };

    // 更新总得分
    const updateTotalScore = () => {
      scoreData.value.ti_total_score =
        scoreData.value.ti.injury_site_score +
        scoreData.value.ti.injury_type_score +
        scoreData.value.ti.consciousness_score +
        scoreData.value.ti.circulation_score +
        scoreData.value.ti.respiration_score;
    };

    // 提交TI评分
    const submitTI = async () => {
      try {
        updateTotalScore();
        await axios.put(`/operation_histories/update/${operation_id}`, {
          ti_score: scoreData.value.ti_total_score.toString(),
          ti_content: scoreData.value.ti,
        });
        ElMessage.success("创伤指数评分提交成功");
      } catch (error) {
        console.error("submitTI error:", error);
        ElMessage.error("创伤指数评分提交失败");
      }
    };

    // 初始化数据
    onMounted(() => {
      fetchScoreData();
    });

    return {
      scoreData,
      submitTI,
      updateInjurySiteScore,
      updateInjuryTypeScore,
      updateConsciousnessScore,
      updateCirculationScore,
      updateRespirationScore,
    };
  },
});
</script>

<style scoped>
.score-form {
  margin-top: 20px;
}
</style>
