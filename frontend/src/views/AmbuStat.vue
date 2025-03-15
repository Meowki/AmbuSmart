<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />
  <div class="container">
    <!-- 1. 急救记录录入表单 -->
    <el-card class="form-card" shadow="hover">
      <el-form :model="form" label-width="120px">
        <el-form-item label="初步诊断">
          <el-input
            type="textarea"
            v-model="form.initial_diagnosis"
            placeholder="填写初步诊断..."
          />
        </el-form-item>
        <el-form-item label="急救处理">
          <el-input
            type="textarea"
            v-model="form.procedures"
            placeholder="记录急救处理..."
          />
        </el-form-item>
        <el-form-item label="药物记录">
          <el-input
            type="textarea"
            v-model="form.medicine"
            placeholder="记录药物使用情况..."
          />
        </el-form-item>
        <el-form-item label="急救结果">
          <el-input
            type="textarea"
            v-model="form.outcome"
            placeholder="填写急救结果..."
          />
        </el-form-item>
        <el-form-item label="院内接收者">
          <el-input
            v-model="form.recipient"
            placeholder="填写院内接收者..."
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSubmit">提交记录</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 2. 数据摘要（关键指标） -->
    <el-card class="summary-card" shadow="hover">
      <div class="summary">
        <div class="summary-item">
          <div class="summary-number">{{ summary.total }}</div>
          <div class="summary-label">总记录数</div>
        </div>
        <div class="summary-item">
          <div class="summary-number">{{ summary.successRate }}%</div>
          <div class="summary-label">急救成功率</div>
        </div>
        <div class="summary-item">
          <div class="summary-number">{{ summary.avgProcessTime }} 分钟</div>
          <div class="summary-label">平均处理时间</div>
        </div>
      </div>
    </el-card>

    <!-- 3. 录入记录展示列表（已移除操作栏） -->
    <el-card class="table-card" shadow="hover">
      <el-table :data="records" style="width: 100%">
        <el-table-column prop="initial_diagnosis" label="初步诊断" width="200"></el-table-column>
        <el-table-column prop="procedures" label="急救处理" ></el-table-column>
        <el-table-column prop="medicine" label="药物记录" width="200"></el-table-column>
        <el-table-column prop="outcome" label="急救结果" width="200"></el-table-column>
        <el-table-column prop="recipient" label="院内接收者" width="150"></el-table-column>
      </el-table>
    </el-card>

    <div class="confirm-button">
      <el-button type="success" @click="handleConfirm">确认结束</el-button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import NavigationBar from '@/components/NavigationBars.vue';

const currentStep = ref('统计分析');

// 表单数据
const form = ref({
  initial_diagnosis: '',
  procedures: '',
  medicine: '',
  outcome: '',
  recipient: '',
});

// 模拟已有记录
const records = ref([
  {
    id: 1,
    initial_diagnosis: '轻微中毒',
    procedures: '服用解毒药',
    medicine: '解毒药A',
    outcome: '稳定',
    recipient: '急诊科',
    processTime: 30,
    success: true,
  },
  {
    id: 2,
    initial_diagnosis: '车祸外伤',
    procedures: '止血包扎',
    medicine: '止痛药B',
    outcome: '转院',
    recipient: '骨科',
    processTime: 45,
    success: false,
  },
]);

// 简单计算摘要数据
const summary = ref({
  total: records.value.length,
  successRate: Math.round(
    (records.value.filter(item => item.success).length / records.value.length) * 100
  ),
  avgProcessTime: Math.round(
    records.value.reduce((acc, cur) => acc + cur.processTime, 0) / records.value.length
  ),
});

function handleSubmit() {
  const newRecord = {
    id: Date.now(),
    ...form.value,
    processTime: Math.floor(Math.random() * 60) + 10,
    success: Math.random() > 0.5,
  };
  records.value.push(newRecord);
  updateSummary();
  handleReset();
}

function handleReset() {
  form.value = {
    initial_diagnosis: '',
    procedures: '',
    medicine: '',
    outcome: '',
    recipient: '',
  };
}

function updateSummary() {
  summary.value.total = records.value.length;
  summary.value.successRate = Math.round(
    (records.value.filter(item => item.success).length / records.value.length) * 100
  );
  summary.value.avgProcessTime = Math.round(
    records.value.reduce((acc, cur) => acc + cur.processTime, 0) / records.value.length
  );
}

const router = useRouter();
function handleConfirm() {
  // 跳转到 AmbuEnd 页面（路由地址根据实际情况配置）
  router.push('/AmbuEnd');
}
</script>

<style scoped>
.container {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.form-card,
.summary-card,
.table-card {
  padding: 20px;
}
.summary {
  display: flex;
  justify-content: space-around;
  text-align: center;
}
.summary-item {
  flex: 1;
}
.summary-number {
  font-size: 2em;
  font-weight: bold;
}
.summary-label {
  color: #888;
}
.confirm-button {
  display: flex;
  justify-content: center;
}
</style>
