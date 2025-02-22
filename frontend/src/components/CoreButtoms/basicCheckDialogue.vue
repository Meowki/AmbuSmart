<template>
  <el-button type="primary" @click="openDialog">Open Check Form</el-button>

  <!-- 对话框 -->
  <el-dialog title="Check Form" v-model="dialogVisible" width="60%">
    <el-form :model="checkData.initial_check" ref="初始检查">
      <h3>初始检查</h3>
      <el-form-item label="是否拒检" :prop="`reject`">
        <el-radio-group v-model="checkData.initial_check.reject">
          <el-radio value="0">否</el-radio>
          <el-radio value="1">是</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-row>
        <el-col :span="8">
          <el-form-item label="神志" :prop="`consciousness`">
            <el-select v-model="checkData.initial_check.consciousness" placeholder="请选择">
              <el-option label="清醒" value="清醒"></el-option>
              <el-option label="嗜睡" value="嗜睡"></el-option>
              <el-option label="昏迷" value="昏迷"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="瞳孔（左/右）" :prop="`pupil`">
            <el-input v-model="checkData.initial_check.pupil"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="对光反射" :prop="`pupillary_light_reflex`">
            <el-select v-model="checkData.initial_check.pupillary_light_reflex" placeholder="请选择">
              <el-option label="灵敏" value="灵敏"></el-option>
              <el-option label="迟钝" value="迟钝"></el-option>
              <el-option label="消失" value="消失"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="血压（mmHg）" :prop="`blood_pressure`">
            <el-input v-model="checkData.initial_check.blood_pressure"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="脉搏（次/分）" :prop="`pulse`">
            <el-input v-model="checkData.initial_check.pulse"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="呼吸（次/分）" :prop="`respiration`">
            <el-input v-model="checkData.initial_check.respiration"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="血氧（%）" :prop="`oxygen_saturation`">
            <el-input v-model="checkData.initial_check.oxygen_saturation"></el-input>
          </el-form-item>
        </el-col>
        <!-- 其他初始检查字段 -->
      </el-row>

      <h3>最终检查</h3>
      <el-form :model="checkData.final_check" ref="最终检查">
        <el-form-item label="是否拒检" :prop="`reject`">
        <el-radio-group v-model="checkData.final_check.reject">
          <el-radio value="0">否</el-radio>
          <el-radio value="1">是</el-radio>
        </el-radio-group>
      </el-form-item>
        <el-row>
          <el-col :span="8">
            <el-form-item label="神志" :prop="`consciousness`">
            <el-select v-model="checkData.final_check.consciousness" placeholder="请选择">
              <el-option label="清醒" value="清醒"></el-option>
              <el-option label="嗜睡" value="嗜睡"></el-option>
              <el-option label="昏迷" value="昏迷"></el-option>
            </el-select>
          </el-form-item>
          </el-col>
          <el-col :span="8">
          <el-form-item label="瞳孔（左/右）" :prop="`pupil`">
            <el-input v-model="checkData.final_check.pupil"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="对光反射" :prop="`pupillary_light_reflex`">
            <el-select v-model="checkData.final_check.pupillary_light_reflex" placeholder="请选择">
              <el-option label="灵敏" value="灵敏"></el-option>
              <el-option label="迟钝" value="迟钝"></el-option>
              <el-option label="消失" value="消失"></el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="血压（mmHg）" :prop="`blood_pressure`">
            <el-input v-model="checkData.final_check.blood_pressure"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="脉搏（次/分）" :prop="`pulse`">
            <el-input v-model="checkData.final_check.pulse"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="呼吸（次/分）" :prop="`respiration`">
            <el-input v-model="checkData.final_check.respiration"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="血氧（%）" :prop="`oxygen_saturation`">
            <el-input v-model="checkData.final_check.oxygen_saturation"></el-input>
          </el-form-item>
        </el-col>
        </el-row>
      </el-form>
    </el-form>

    <div class="dialog-footer">
      <el-button @click="dialogVisible = false">Cancel</el-button>
      <el-button type="primary" @click="submitForm">Submit</el-button>
    </div>
  </el-dialog>
</template>

<script>
/*eslint-disable*/
import { ref, onMounted } from 'vue';
import { useStore } from 'vuex';
import axios from 'axios';

export default {
  setup() {
    const store = useStore();
    const operation_id = store.state.operation_id || "20202";
    const dialogVisible = ref(false);  // 控制对话框的显示与隐藏
    const checkData = ref({
      initial_check: {
        timestamp: "",
        reject: "0",
        consciousness: "",
        pupil: "",
        pupillary_light_reflex: "",
        blood_pressure: "",
        pulse: "",
        respiration: "",
        oxygen_saturation: "",
      },
      final_check: {
        timestamp: "",
        reject: "0",
        consciousness: "",
        pupil: "",
        pupillary_light_reflex: "",
        blood_pressure: "",
        pulse: "",
        respiration: "",
        oxygen_saturation: "",
      },
    });

    // 获取操作数据
    const fetchOperationData = async () => {
      try {
        const response = await axios.get(`/operation_histories/operationId/${operation_id}`);
        const data = response.data;
        if (data.initial_check) checkData.value.initial_check = data.initial_check;
        if (data.final_check) checkData.value.final_check = data.final_check;
        console.log("basic_check_initial:"+ JSON.stringify(data.initial_check))
      } catch (error) {
        console.error(error);
      }
    };

    // 打开对话框
    const openDialog = () => {
      dialogVisible.value = true;
      fetchOperationData();
    };

    // 提交表单
    //1. 更新逻辑不对
    //2. 前端优化+放时间
    const submitForm = async () => {
      try {
        // 处理 initial_check 的新增或更新
        if (checkData.value.initial_check.timestamp && checkData.value.initial_check.eid) {
          // 更新 initial_check
          console.log("initial update")
          await axios.put(`/basic_check/update/${checkData.value.initial_check.eid}`, checkData.value.initial_check);
        } else {
          // 新增 initial_check
          checkData.value.initial_check.timestamp = new Date().toISOString();
          const initialResponse = await axios.post(`/basic_check/`, checkData.value.initial_check);
          await axios.put(`/operation_histories/update/${operation_id}`, { initial_eid: initialResponse.data.eid });
        }

        // 处理 final_check 的新增或更新
        if (checkData.value.final_check.timestamp) {
          // 更新 final_check
          await axios.put(`/basic_check/update/${checkData.value.final_check.eid}`);
        } else {
          // 新增 final_check
          checkData.value.final_check.timestamp = new Date().toISOString();
          const finalResponse = await axios.post(`/basic_check/`, checkData.value.final_check);
          await axios.put(`/operation_histories/update/${operation_id}`, { final_eid: finalResponse.data.eid });
        }

        dialogVisible.value = false; // 提交后关闭对话框
      } catch (error) {
        console.error(error);
      }
    };

    return {
      dialogVisible,
      checkData,
      openDialog,
      submitForm,
    };
  },
};
</script>
