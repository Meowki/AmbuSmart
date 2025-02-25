<el-form :model="scoreData.ti" ref="tiForm" label-width="120px">

      <!-- 受伤部位 -->
      <el-row>
        <el-col :span="12">
          <el-form-item label="受伤部位" prop="injury_site">
            <el-select v-model="scoreData.ti.injury_site" @change="updateTotalScore" placeholder="请选择">
              <el-option label="头部" value="5"></el-option>
              <el-option label="胸部" value="4"></el-option>
              <el-option label="腹部" value="3"></el-option>
              <el-option label="四肢" value="2"></el-option>
              <el-option label="其他" value="1"></el-option>
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
            <el-select v-model="scoreData.ti.injury_type" @change="updateTotalScore" placeholder="请选择">
              <el-option label="创伤" value="5"></el-option>
              <el-option label="出血" value="4"></el-option>
              <el-option label="骨折" value="3"></el-option>
              <el-option label="其他" value="2"></el-option>
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
            <el-select v-model="scoreData.ti.consciousness" @change="updateTotalScore" placeholder="请选择">
              <el-option label="清醒" value="5"></el-option>
              <el-option label="昏迷" value="2"></el-option>
              <el-option label="嗜睡" value="3"></el-option>
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
            <el-select v-model="scoreData.ti.circulation" @change="updateTotalScore" placeholder="请选择">
              <el-option label="正常" value="5"></el-option>
              <el-option label="低血压" value="3"></el-option>
              <el-option label="休克" value="1"></el-option>
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
            <el-select v-model="scoreData.ti.respiration" @change="updateTotalScore" placeholder="请选择">
              <el-option label="正常" value="5"></el-option>
              <el-option label="呼吸急促" value="3"></el-option>
              <el-option label="呼吸衰竭" value="1"></el-option>
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

    return {
      dialogVisibleScore,
      activeNames,
      scoreData,
      openScoreDialog,
      submitTI,
    };
  },
};
</script>

<style scoped>
.score-form {
  margin-top: 20px;
}
</style>
