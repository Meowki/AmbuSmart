<template>
  <el-button type="primary" @click="openDialog">基础检查</el-button>

  <!-- 对话框 -->
  <el-dialog title="Check Form" v-model="dialogVisible" width="70%" :close-on-click-modal="false">
    <el-form :model="checkData.initial_check" ref="initialCheckForm" label-width="120px" class="check-form">
      <h3>初始检查</h3>
      
      <el-row>
        <el-col :span="12">
          <el-form-item label="检查时间" :prop="'timestamp'">
            {{ formatDateTime(checkData.initial_check.timestamp) || "第一次提交后自动生成" }}
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="是否拒检" :prop="`reject`">
            <el-radio-group v-model="checkData.initial_check.reject">
              <el-radio :value="0">否</el-radio>
              <el-radio :value="1">是</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>

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
      </el-row>

      <el-row>
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
      </el-row>

      <el-row>
        <el-col :span="8">
          <el-form-item label="血氧（%）" :prop="`oxygen_saturation`">
            <el-input v-model="checkData.initial_check.oxygen_saturation"></el-input>
          </el-form-item>
        </el-col>
      </el-row>

      <el-button type="primary" @click="submitInitialCheck" style="margin-top: 20px;">提交初始检查</el-button>
      <el-button @click="dialogVisible = false" style="margin-top: 20px;">关闭</el-button>
    </el-form>

    <el-divider></el-divider>

    <h3>最终检查</h3>
    <el-form :model="checkData.final_check" ref="finalCheckForm" label-width="120px" class="check-form">
      <el-row>
        <el-col :span="12">
          <el-form-item label="检查时间" :prop="'timestamp'">
            {{ formatDateTime(checkData.final_check.timestamp) || "第一次提交后自动生成" }}
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="是否拒检" :prop="`reject`">
            <el-radio-group v-model="checkData.final_check.reject">
              <el-radio :value="0">否</el-radio>
              <el-radio :value="1">是</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>

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
      </el-row>

      <el-row>
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
      </el-row>

      <el-row>
        <el-col :span="8">
          <el-form-item label="血氧（%）" :prop="`oxygen_saturation`">
            <el-input v-model="checkData.final_check.oxygen_saturation"></el-input>
          </el-form-item>
        </el-col>
      </el-row>

      <el-button type="primary" @click="submitFinalCheck" style="margin-top: 20px;">提交最终检查</el-button>
      <el-button @click="dialogVisible = false" style="margin-top: 20px;">关闭</el-button>
    </el-form>

  </el-dialog>
</template>

<script>
import { ref} from "vue";
import { useStore } from "vuex";
import axios from "axios";
import dayjs from "dayjs";
import { ElMessage } from 'element-plus'; // 引入 ElMessage

export default {
  setup() {
    const store = useStore();
    const operation_id = store.state.operation_id || "20202";
    const dialogVisible = ref(false);
    const checkData = ref({
      initial_check: {
        timestamp: "",
        reject: 0,
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
        reject: 0,
        consciousness: "",
        pupil: "",
        pupillary_light_reflex: "",
        blood_pressure: "",
        pulse: "",
        respiration: "",
        oxygen_saturation: "",
      },
    });

    const fetchOperationData = async () => {
      try {
        const response = await axios.get(
          `/operation_histories/operationId/${operation_id}`
        );
        const data = response.data;
        if (data.initial_check)
          checkData.value.initial_check = data.initial_check;
        if (data.final_check) checkData.value.final_check = data.final_check;
        console.log(
          "basic_check_initial:" + JSON.stringify(data.initial_check)
        );
      } catch (error) {
        console.error(error);
      }
    };

    const openDialog = () => {
      dialogVisible.value = true;
      fetchOperationData();
    };

    const submitInitialCheck = async () => {
      try {
        checkData.value.initial_check.timestamp = new Date().toISOString();
        if (checkData.value.initial_check.eid) {
          await axios.put(
            `/basic_check/update/${checkData.value.initial_check.eid}`,
            checkData.value.initial_check
          );
          ElMessage.success('初始检查更新成功');
          dialogVisible.value = false
        } else {
          const initialResponse = await axios.post(
            `/basic_check/`,
            checkData.value.initial_check
          );
          await axios.put(`/operation_histories/update/${operation_id}`, {
            initial_eid: initialResponse.data.eid,
          });
          ElMessage.success('初始检查新增成功');
          dialogVisible.value = false;
        }
      } catch (error) {
        console.error(error);
        ElMessage.error('初始检查提交失败');
      }
    };

    const submitFinalCheck = async () => {
      try {
        checkData.value.final_check.timestamp = new Date().toISOString();
        if (checkData.value.final_check.eid) {
          await axios.put(
            `/basic_check/update/${checkData.value.final_check.eid}`,
            checkData.value.final_check
          );
          ElMessage.success('最终检查更新成功');
          dialogVisible.value = false
        } else {
          const finalResponse = await axios.post(
            `/basic_check/`,
            checkData.value.final_check
          );
          await axios.put(`/operation_histories/update/${operation_id}`, {
            final_eid: finalResponse.data.eid,
          });
          ElMessage.success('最终检查新增成功');
          dialogVisible.value = false
        }
      } catch (error) {
        console.error(error);
        ElMessage.error('最终检查提交失败');
      }
    };

    const formatDateTime = (val) => {
      return dayjs(val).format("YYYY年MM月DD日 HH时mm分");
    };

    return {
      dialogVisible,
      checkData,
      openDialog,
      submitInitialCheck,
      submitFinalCheck,
      formatDateTime,
    };
  },
};
</script>
