<template>
  <div>
    <el-form :model="strokeData" ref="strokeForm" label-width="120px">
      <h3>脑卒中评估</h3>
      <el-form-item label="脑卒中评估">
        <el-checkbox-group v-model="strokeData.selected">
          <el-row>
            <el-col v-for="option in options" :key="option.value" :span="8">
              <el-checkbox :label="option.value">{{ option.label }}</el-checkbox>
            </el-col>
          </el-row>
        </el-checkbox-group>
      </el-form-item>
      <el-form-item v-if="strokeData.selected.includes('其它')" label="其它说明">
        <el-input v-model="strokeData.other"></el-input>
      </el-form-item>
      <el-button type="primary" @click="submitStrokeAssessment" style="margin-top: 20px;">提交脑卒中评估</el-button>
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

    const strokeData = ref({
      selected: [], // 多选框结果
      other: ""     // 当选择“其它”时的补充说明
    });

    // 脑卒中评估的选项
    const options = [
      { value: "面部不对称(F)", label: "面部不对称(F)" },
      { value: "上肢无力(A)", label: "上肢无力(A)" },
      { value: "言语障碍(S)", label: "言语障碍(S)" },
      { value: "需立即送医（T）", label: "言语障碍(T)" },
      { value: "其它", label: "其它" }
    ];

    const submitStrokeAssessment = async () => {
      try {
        const payload = {
          cerebral_stroke_content: {
            selected: strokeData.value.selected,
            other: strokeData.value.other
          }
        };
        await axios.put(`/operation_histories/update/${operation_id}`, payload);
        ElMessage.success("脑卒中评估提交成功");
      } catch (error) {
        console.error("submitStrokeAssessment error:", error);
        ElMessage.error("脑卒中评估提交失败");
      }
    };

    const fetchStrokeData = async () => {
      try {
        const response = await axios.get(`/operation_histories/operationId/${operation_id}`);
        const data = response.data;
        if (data.cerebral_stroke_content) {
          const content = data.cerebral_stroke_content;
          strokeData.value.selected = content.selected || [];
          strokeData.value.other = content.other || "";
        }
      } catch (error) {
        console.error("fetchStrokeData error:", error);
      }
    };

    onMounted(() => {
      fetchStrokeData();
    });

    return {
      strokeData,
      options,
      submitStrokeAssessment
    };
  }
};
</script>

<style scoped>
/* 可以根据需要调整布局样式 */
</style>
