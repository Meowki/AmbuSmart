<template>
<!-- 创伤指数（TI）：是以患者生命体征为基础研究的创伤计分法，它包括受伤部位、损伤类型、循环、呼吸和意识5个方面的评定。
该评分方法根据每个方面的异常程度计以1、3、5或6分，5项计分相加即为TI总分：
注:TI≤9为轻度或中度伤，需普通急诊治疗；
10-16为中度伤，需住院治疗，多为单一系统损伤，无生命危险；
>17为极重伤，常为多发伤，有死亡可能。-->
<!-- 考虑根据分数进行提醒 -->
  <el-form :model="scoreData.ti" ref="tiForm" label-width="120px">
    <!-- 受伤部位 -->
    <el-row>
      <el-col :span="12">
        <el-form-item label="受伤部位" prop="injury_site">
          <el-select v-model="scoreData.ti.injury_site" @change="updateInjurySiteScore" placeholder="请选择">
            <el-option label="无" value="无"></el-option>
            <el-option label="四肢" value="四肢"></el-option>
            <el-option label="背部" value="背部"></el-option>
            <el-option label="胸部" value="胸部"></el-option>
            <el-option label="头、颈、腹" value="头、颈、腹"></el-option>
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
            <el-option label="无" value="无"></el-option>
            <el-option label="撕裂伤" value="撕裂伤"></el-option>
            <el-option label="挫伤" value="挫伤"></el-option>
            <el-option label="刺伤" value="刺伤"></el-option>
            <el-option label="钝器伤、子弹伤" value="钝器伤、子弹伤"></el-option>
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
            <el-option label="嗜睡" value="嗜睡"></el-option>
            <el-option label="恍惚" value="恍惚"></el-option>
            <el-option label="半昏迷" value="半昏迷"></el-option>
            <el-option label="深昏迷" value="深昏迷"></el-option>
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
            <el-option label="常规" value="常规"></el-option>
            <el-option label="外出血" value="外出血"></el-option>
            <el-option label="收缩压 70~100" value="收缩压 70~100"></el-option>
            <el-option label="收缩压 50~70" value="收缩压 50~70"></el-option>
            <el-option label="收缩压 <50" value="收缩压 <50"></el-option>
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
            <el-option label="胸痛" value="胸痛"></el-option>
            <el-option label="呼吸困难" value="呼吸困难"></el-option>
            <el-option label="发绀" value="发绀"></el-option>
            <el-option label="无呼吸" value="无呼吸"></el-option>
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
        "头、颈、腹": 6,
        "胸部": 5,
        "背部": 3,
        "四肢": 1,
        "无": 0
      };
      scoreData.value.ti.injury_site_score = injurySiteScoreMapping[scoreData.value.ti.injury_site] || 0;
      updateTotalScore();
    };

    const updateInjuryTypeScore = () => {
      const injuryTypeScoreMapping = {
        "钝器伤、子弹伤": 6,
        "刺伤": 5,
        "挫伤": 3,
        "撕裂伤": 1,
        "无": 0
      };
      scoreData.value.ti.injury_type_score = injuryTypeScoreMapping[scoreData.value.ti.injury_type] || 0;
      updateTotalScore();
    };

    const updateConsciousnessScore = () => {
      const consciousnessScoreMapping = {
        "深昏迷": 6,
        "半昏迷": 5,
        "恍惚": 3,
        "嗜睡": 1,
        "清醒": 0
      };
      scoreData.value.ti.consciousness_score = consciousnessScoreMapping[scoreData.value.ti.consciousness] || 0;
      updateTotalScore();
    };

    const updateCirculationScore = () => {
      const circulationScoreMapping = {
        "收缩压 <50": 6,
        "收缩压 50~70": 5,
        "收缩压 70~100": 3,
        "外出血": 1,
        "常规": 0
      };
      scoreData.value.ti.circulation_score = circulationScoreMapping[scoreData.value.ti.circulation] || 0;
      updateTotalScore();
    };

    const updateRespirationScore = () => {
      const respirationScoreMapping = {
        "无呼吸": 6,
        "发绀": 5,
        "呼吸困难": 3,
        "胸痛": 1,
        "正常": 0
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
