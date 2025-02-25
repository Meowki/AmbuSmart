<template>
  <!-- 触发弹窗按钮 -->
  <el-button type="primary" @click="openScoreDialog">评估评分</el-button>

  <!-- 评估评分的对话框 -->
  <el-dialog
    title="评分评估"
    v-model="dialogVisibleScore"
    width="70%"
    :close-on-click-modal="false"  
  >
    <el-collapse v-model="activeNames" accordion>
    <!-- 创伤指数评分折叠项 -->
  <el-collapse-item title="创伤指数评分 (TI)" name="1">
    
  </el-collapse-item>

      <!-- GCS评分折叠项 -->
      <el-collapse-item title="GCS评分" name="2">
        <el-form :model="scoreData.gcs" ref="gcsForm" label-width="120px">
          <el-row>
            <el-col :span="12">
              <el-form-item label="GCS评分" prop="gcs_score">
                <el-input v-model="scoreData.gcs.gcs_score"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="GCS具体内容" prop="gcs_content">
                <el-input v-model="scoreData.gcs.gcs_content"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-button type="primary" @click="submitGCS" style="margin-top: 20px;">
            提交GCS评分
          </el-button>
        </el-form>
      </el-collapse-item>

      <!-- Killip评分折叠项 -->
      <el-collapse-item title="Killip评分" name="3">
        <el-form :model="scoreData.killip" ref="killipForm" label-width="120px">
          <el-row>
            <el-col :span="12">
              <el-form-item label="Killip评分" prop="killip_score">
                <el-input v-model="scoreData.killip.killip_score"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="胸痛高危状态" prop="killip_content">
                <el-input v-model="scoreData.killip.killip_content"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="胸痛初步判断" prop="killip_diagnosis">
                <el-input v-model="scoreData.killip.killip_diagnosis"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-button type="primary" @click="submitKillip" style="margin-top: 20px;">
            提交Killip评分
          </el-button>
        </el-form>
      </el-collapse-item>

      <!-- 脑卒中评估折叠项 -->
      <el-collapse-item title="脑卒中评估" name="4">
        <el-form :model="scoreData.stroke" ref="strokeForm" label-width="120px">
          <el-row>
            <el-col :span="24">
              <el-form-item label="脑卒中评估" prop="cerebral_stroke_content">
                <el-input v-model="scoreData.stroke.cerebral_stroke_content"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-button type="primary" @click="submitStroke" style="margin-top: 20px;">
            提交脑卒中评估
          </el-button>
        </el-form>
      </el-collapse-item>
    </el-collapse>

    <el-button @click="dialogVisibleScore = false" style="margin-top: 20px;">关闭</el-button>
  </el-dialog>
</template>

<script>
import { ref } from "vue";
import axios from "axios";
import { ElMessage } from "element-plus";
import { useStore } from "vuex";

export default {
  setup() {
    const activeNames = ref(["1"]);
    const store = useStore();
    const operation_id = store.state.operation_id || "20202";

    // 控制对话框显示与否
    const dialogVisibleScore = ref(false);

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
      gcs: {
        gcs_score: "",
        gcs_content: "",
      },
      killip: {
        killip_score: "",
        killip_content: "",
        killip_diagnosis: "",
      },
      stroke: {
        cerebral_stroke_content: "",
      },
    });

    const openScoreDialog = () => {
      dialogVisibleScore.value = true;
      // 此处可以填充已有数据
      fetchScoreData();
    };

    const fetchScoreData = async () => {
      try {
        const response = await axios.get(`/operation_histories/operationId/${operation_id}`);
        const data = response.data;
        // 填充表单数据
        scoreData.value.ti = {
          ti_score: data.ti_score || "",
          ti_content: data.ti_content || "",
        };
        scoreData.value.gcs = {
          gcs_score: data.gcs_score || "",
          gcs_content: data.gcs_content || "",
        };
        scoreData.value.killip = {
          killip_score: data.killip_score || "",
          killip_content: data.killip_content || "",
          killip_diagnosis: data.killip_diagnosis || "",
        };
        scoreData.value.stroke = {
          cerebral_stroke_content: data.cerebral_stroke_content || "",
        };
      } catch (error) {
        console.error("fetchScoreData error:", error);
      }
    };

    // 更新TI评分，计算每个部分的得分-----------------------------------------------
   // 更新总得分
    const updateTotalScore = () => {
      // 每个部分的得分通过选项的值直接给定
      scoreData.value.ti.injury_site_score = Number(scoreData.value.ti.injury_site);
      scoreData.value.ti.injury_type_score = Number(scoreData.value.ti.injury_type);
      scoreData.value.ti.consciousness_score = Number(scoreData.value.ti.consciousness);
      scoreData.value.ti.circulation_score = Number(scoreData.value.ti.circulation);
      scoreData.value.ti.respiration_score = Number(scoreData.value.ti.respiration);

      // 计算总得分
      scoreData.value.ti_total_score =
        scoreData.value.ti.injury_site_score +
        scoreData.value.ti.injury_type_score +
        scoreData.value.ti.consciousness_score +
        scoreData.value.ti.circulation_score +
        scoreData.value.ti.respiration_score;
    };

    // 提交TI评分数据
    const submitTI = async () => {
      try {
        // 使用JSON格式存储所有评分
        updateTotalScore();
        const jsonData = JSON.stringify(scoreData.value.ti);
        console.log(operation_id)
        console.log("TI_jsonData:" + jsonData);
        await axios.put(`/operation_histories/update/{operation_id}`, {
          ti_score: scoreData.value.ti_total_score,
          ti_content: jsonData,
        });
        ElMessage.success("创伤指数评分提交成功");
      } catch (error) {
        console.error("submitTI error:", error);
        ElMessage.error("创伤指数评分提交失败");
      }
    };
    //--------------------------------------------------------

    const submitGCS = async () => {
      try {
        await axios.put(`/operation_histories/update/${operation_id}`, scoreData.value.gcs);
        ElMessage.success("GCS评分提交成功");
      } catch (error) {
        console.error("submitGCS error:", error);
        ElMessage.error("GCS评分提交失败");
      }
    };

    const submitKillip = async () => {
      try {
        await axios.put(`/operation_histories/update/${operation_id}`, scoreData.value.killip);
        ElMessage.success("Killip评分提交成功");
      } catch (error) {
        console.error("submitKillip error:", error);
        ElMessage.error("Killip评分提交失败");
      }
    };

    const submitStroke = async () => {
      try {
        await axios.put(`/operation_histories/update/${operation_id}`, scoreData.value.stroke);
        ElMessage.success("脑卒中评估提交成功");
      } catch (error) {
        console.error("submitStroke error:", error);
        ElMessage.error("脑卒中评估提交失败");
      }
    };

    return {
      dialogVisibleScore,
      activeNames,
      scoreData,
      openScoreDialog,
      submitTI,
      submitGCS,
      submitKillip,
      submitStroke,
    };
  },
};
</script>

<style scoped>
.score-form {
  margin-top: 20px;
}
</style>
