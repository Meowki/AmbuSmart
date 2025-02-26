<template>
<!-- 记录方式:如果在晚上六点半测得评分为9分，其中E2分，V4分，M3分，则记作为:GCS 9(2+4+3)18:30或者GCS 9=E2+V4+M3 at 18:30
选评判时的最好反应计分。注意运动评分左侧右侧可能不同,用较高的分数进行评分。
只有惠者 GCS 评分达到 15 分时才有可能配合检查者进行认知功能评定。
最高分为15分，最低分为3分，分数越低则意识障碍越重。
3~8分以下为重度损伤，预后差:9~12分中度损伤;13~15分轻度损伤 -->
  <el-form :model="scoreData.gcs" ref="gcsForm" label-width="120px">
    <!-- 睁眼 -->
    <el-row>
      <el-col :span="14">
        <el-form-item label="睁眼" prop="gcs_e">
          <el-select
            v-model="scoreData.gcs.gcs_e"
            @change="updateEScore"
            placeholder="请选择"
          >
            <el-option label="自己睁眼" value="自发"></el-option>
            <el-option label="呼叫时睁眼" value="语言"></el-option>
            <el-option label="疼痛刺激时睁眼" value="刺激睁眼"></el-option>
            <el-option label="任何刺激不睁眼" value="不睁眼"></el-option>
            <el-option label="因眼肿、骨折等不能睁眼" value="因素闭眼"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="10">
        <el-form-item label="得分" prop="gcs_e_score">
          <el-input
            v-model="scoreData.gcs.gcs_e_score"
            disabled
          ></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 言语反应 -->
    <el-row>
      <el-col :span="14">
        <el-form-item label="言语反应" prop="gcs_v">
          <el-select
            v-model="scoreData.gcs.gcs_v"
            @change="updateVScore"
            placeholder="请选择"
          >
            <el-option label="能正确会话" value="正常"></el-option>
            <el-option label="语言错乱，定向障碍" value="语言错乱"></el-option>
            <el-option label="说话能被理解，但无意义" value="语言无意义"></el-option>
            <el-option label="能发出声音，但不能被理解" value="仅发声"></el-option>
            <el-option label="不发声" value="不发声"></el-option>
            <el-option label="因气管插管或切开而无法正常发声" value="气管因素"></el-option>
            <el-option label="平素有言语障碍史" value="言语障碍"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="10">
        <el-form-item label="得分" prop="gcs_v_score">
          <el-input
            v-model="scoreData.gcs.gcs_v_score"
            disabled
          ></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 运动反应 -->
    <el-row>
      <el-col :span="14">
        <el-form-item label="运动反应" prop="gcs_m">
          <el-select
            v-model="scoreData.gcs.gcs_m"
            @change="updateMScore"
            placeholder="请选择"
          >
            <el-option label="能执行简单的命令" value="执行口令"></el-option>
            <el-option label="疼痛时能拨开医生的手" value="疼痛反应强"></el-option>
            <el-option label="对疼痛刺激有反应，肢体会回缩" value="疼痛反应中"></el-option>
            <el-option label="对疼痛刺激有反应，肢体会弯曲，呈去皮质强直姿势" value="疼痛反应较弱"></el-option>
            <el-option label="对疼痛刺激有反应，肢体会伸直，呈去大脑强直姿势" value="疼痛反应弱"></el-option>
            <el-option label="对疼痛无任何反应" value="无疼痛反应"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="10">
        <el-form-item label="得分" prop="gcs_m_score">
          <el-input
            v-model="scoreData.gcs.gcs_m_score"
            disabled
          ></el-input>
        </el-form-item>
      </el-col>
    </el-row>


    <!-- 总得分 -->
    <el-row>
      <el-col :span="14">
        <el-form-item label="总得分" prop="total_score">
          <el-input v-model="scoreData.gcs_total_score" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>

    <!-- 提交按钮 -->
    <el-button type="primary" @click="submitGCS" style="margin-top: 20px">
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
  name: "GcsScore",
  setup() {
    const store = useStore();
    const operation_id = store.state.operation_id || "20202";

    const scoreData = ref({
      gcs: {
        gcs_e: "",
        gcs_e_score: 0,
        gcs_v: "",
        gcs_v_score: 0,
        gcs_m: "",
        gcs_m_score: 0,
      },
      gcs_total_score: 0,
    });

    // 获取评分数据
    const fetchScoreData = async () => {
      try {
        const response = await axios.get(
          `/operation_histories/operationId/${operation_id}`
        );
        const data = response.data;

        // 填充评分项
        scoreData.value.gcs = {
          gcs_e: data.gcs_content.gcs_e || "",
          gcs_e_score: data.gcs_content.gcs_e_score || "",
          gcs_v: data.gcs_content.gcs_v || "",
          gcs_v_score: data.gcs_content.gcs_v_score || "",
          gcs_m: data.gcs_content.gcs_m || "",
          gcs_m_score: data.gcs_content.gcs_m_score || "",
        };

        // 计算总得分
        updateTotalScore();
      } catch (error) {
        console.error("fetchScoreData error:", error);
      }
    };

    // 更新scoreData的得分
    const updateEScore = () => {
      const EScoreMapping = {
        "自发": 4,
        "语言": 3,
        "刺激睁眼": 2,
        "不睁眼": 1,
        "因素闭眼": 'C',
      };
      console.log("gcs_e_score: " + scoreData.value.gcs.gcs_e_score);
      scoreData.value.gcs.gcs_e_score =
        EScoreMapping[scoreData.value.gcs.gcs_e] || 0;
      updateTotalScore();
    };

    const updateVScore = () => {
      const VScoreMapping = {
        "正常": 5,
        "语言错乱": 4, 
        "语言无意义": 3,
        "仅发声": 2,
        "不发声": 1,
        "气管因素": 'T',
        "言语障碍": 'D',
      };
      scoreData.value.gcs.gcs_v_score =
        VScoreMapping[scoreData.value.gcs.gcs_v] || 0;
      updateTotalScore();
    };

    const updateMScore = () => {
      const MScoreMapping = {
        "执行口令": 6,
        "疼痛反应强": 5,
        "疼痛反应中": 4,
        "疼痛反应较弱": 3,
        "疼痛反应弱": 2,
        "无疼痛反应": 1,
      };
      scoreData.value.gcs.gcs_m_score =
        MScoreMapping[scoreData.value.gcs.gcs_m] || 0;
      updateTotalScore();
    };

    // 更新总得分
    // const updateTotalScore = () => {
    //   scoreData.value.gcs_total_score =
    //     scoreData.value.gcs.gcs_e_score +
    //     scoreData.value.gcs.gcs_m_score +
    //     scoreData.value.gcs.gcs_v_score;
    // };

    function updateTotalScore() {
        console.log("raw data of gcs:"+JSON.stringify(scoreData.value.gcs));
      // 提取数字部分并计算总分
      const eScore =  String(scoreData.value.gcs.gcs_e_score).replace(/\D/g, ""); 
      const vScore =  String(scoreData.value.gcs.gcs_v_score).replace(/\D/g, ""); 
      const mScore =  String(scoreData.value.gcs.gcs_m_score).replace(/\D/g, ""); 

      // 提取字母部分（如 T）
      const eLetter =  String(scoreData.value.gcs.gcs_e_score).replace(/\d/g, ""); 
      const vLetter =  String(scoreData.value.gcs.gcs_v_score).replace(/\d/g, "");
      const mLetter =  String(scoreData.value.gcs.gcs_m_score).replace(/\d/g, ""); 

      // 计算总分，只加数字部分
      const totalScore = Number(eScore) + Number(vScore) + Number(mScore);

      console.log("totalScore: " + totalScore);

      // 获取当前时间
      const currentTime = new Date();
      const hours = currentTime.getHours().toString().padStart(2, "0");
      const minutes = currentTime.getMinutes().toString().padStart(2, "0");
      const formattedTime = `${hours}:${minutes}`;

      // 拼接最终的评分字符串，保留字母和数字部分
      // 如果字母部分存在，添加到总得分后面
      let letterPart = "";
      if (eLetter || vLetter || mLetter) {
        letterPart = ` + ${eLetter || ""}${vLetter || ""}${mLetter || ""}`; // 拼接字母部分
      }

      // 拼接最终评分信息
      scoreData.value.gcs_total_score = `GCS ${totalScore}${letterPart} = E${scoreData.value.gcs.gcs_e_score} + V${scoreData.value.gcs.gcs_v_score} + M${scoreData.value.gcs.gcs_m_score} at ${formattedTime}`;

      console.log("final score: " + scoreData.value.gcs_total_score);
    }

    // 提交TI评分
    const submitGCS = async () => {
      try {
        updateTotalScore();
        console.log(scoreData.value.gcs)
        await axios.put(`/operation_histories/update/${operation_id}`, {
          gcs_score: scoreData.value.gcs_total_score.toString(),
          gcs_content: scoreData.value.gcs,
        });
        ElMessage.success("格拉斯哥昏迷评分提交成功");
      } catch (error) {
        console.error("submitTI error:", error);
        ElMessage.error("格拉斯哥昏迷评分提交失败");
      }
    };

    // 初始化数据
    onMounted(() => {
      fetchScoreData();
    });

    return {
      scoreData,
      submitGCS,
      updateEScore,
      updateMScore,
      updateVScore,
    };
  },
});
</script>

<style scoped>
.score-form {
  margin-top: 20px;
}
</style>
