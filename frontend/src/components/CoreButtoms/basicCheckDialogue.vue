<template>
  <el-button type="primary" @click="openDialog">Open Check Form</el-button>

  <!-- 对话框 -->
  <el-dialog title="Check Form" v-model="dialogVisible" width="60%">
    <el-form :model="checkData.initial_check" ref="initialCheckForm">
      <h3>Initial Check</h3>
      <el-row>
        <el-col :span="8">
          <el-form-item label="Consciousness" :prop="`consciousness`">
            <el-input v-model="checkData.initial_check.consciousness"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="Pupil" :prop="`pupil`">
            <el-input v-model="checkData.initial_check.pupil"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="Pupillary Light Reflex" :prop="`pupillary_light_reflex`">
            <el-input v-model="checkData.initial_check.pupillary_light_reflex"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="Blood Pressure" :prop="`blood_pressure`">
            <el-input v-model="checkData.initial_check.blood_pressure"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="Pulse" :prop="`pulse`">
            <el-input v-model="checkData.initial_check.pulse"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="Respiration" :prop="`respiration`">
            <el-input v-model="checkData.initial_check.respiration"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="Oxygen Saturation" :prop="`oxygen_saturation`">
            <el-input v-model="checkData.initial_check.oxygen_saturation"></el-input>
          </el-form-item>
        </el-col>
        <!-- 其他初始检查字段 -->
      </el-row>

      <h3>Final Check</h3>
      <el-form :model="checkData.final_check" ref="finalCheckForm">
        <el-row>
          <el-col :span="8">
            <el-form-item label="Consciousness" :prop="`consciousness`">
              <el-input v-model="checkData.final_check.consciousness"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Pupil" :prop="`pupil`">
              <el-input v-model="checkData.final_check.pupil"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Pupillary Light Reflex" :prop="`pupillary_light_reflex`">
              <el-input v-model="checkData.final_check.pupillary_light_reflex"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Blood Pressure" :prop="`blood_pressure`">
              <el-input v-model="checkData.final_check.blood_pressure"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Pulse" :prop="`pulse`">
              <el-input v-model="checkData.final_check.pulse"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Respiration" :prop="`respiration`">
              <el-input v-model="checkData.final_check.respiration"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="Oxygen Saturation" :prop="`oxygen_saturation`">
              <el-input v-model="checkData.final_check.oxygen_saturation"></el-input>
            </el-form-item>
          </el-col>
          <!-- 其他最终检查字段 -->
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
        reject: "",
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
        reject: "",
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
    const submitForm = async () => {
      try {
        // 处理 initial_check 的新增或更新
        if (checkData.value.initial_check.timestamp) {
          // 更新 initial_check
          await axios.put(`/basic_check/update/${checkData.value.initial_check.eid}`);
        } else {
          // 新增 initial_check
          const initialResponse = await axios.post(`/basic_check/`, checkData.value.initial_check);
          await axios.put(`/operation_histories/update/${operation_id}`, { initial_eid: initialResponse.data.eid });
        }

        // 处理 final_check 的新增或更新
        if (checkData.value.final_check.timestamp) {
          // 更新 final_check
          await axios.put(`/basic_check/update/${checkData.value.final_check.eid}`);
        } else {
          // 新增 final_check
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
