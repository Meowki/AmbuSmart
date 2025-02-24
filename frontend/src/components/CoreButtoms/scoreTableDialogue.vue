<template>
  <el-button type="primary" @click="showDialog = true">打开评估</el-button>

  <el-dialog v-model="showDialog" title="创伤评估" width="800px">
    <!-- TI评分 -->
    <div class="score-card">
      <h3>创伤指数评分（TI）</h3>
      <div class="grid">
        <div v-for="item in tiOptions" :key="item.label" class="grid-item">
          <label>{{ item.label }}</label>
          <el-select v-model="tiForm[item.field]" size="small">
            <el-option
              v-for="opt in item.options"
              :key="opt.value"
              :label="opt.label"
              :value="opt.value"
            />
          </el-select>
        </div>
      </div>
      <div class="total">当前总分：{{ tiTotal }}</div>
    </div>

    <!-- GCS评分 -->
    <div class="score-card">
      <h3>格拉斯哥昏迷指数（GCS）</h3>
      <el-radio-group 
        v-model="gcsScore" 
        class="gcs-grid"
        @change="calculateGCS">
        <div v-for="item in gcsOptions" :key="item.label">
          <div class="subtitle">{{ item.label }}</div>
          <el-radio
            v-for="opt in item.options"
            :key="opt.value"
            :label="opt.value"
            border
          >{{ opt.label }}</el-radio>
        </div>
      </el-radio-group>
      <div class="total">当前总分：{{ gcsTotal }}</div>
    </div>

    <template #footer>
      <el-button @click="saveAssessment">保存评估</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'

const showDialog = ref(false)

// TI评分逻辑
const tiForm = reactive({
  area: 0,
  type: 0,
  bleeding: 0
})

const tiOptions = [
  {
    label: '创伤部位',
    field: 'area',
    options: [
      { value: 0, label: '请选择' },
      { value: 2, label: '四肢' },
      { value: 3, label: '胸腹部' },
      { value: 4, label: '头颈部' }
    ]
  },
  // 其他评分项...
]

const tiTotal = computed(() => {
  return Object.values(tiForm).reduce((a, b) => a + b, 0)
})

// GCS评分逻辑
const gcsScore = reactive({
  eye: 4,
  verbal: 5,
  motor: 6
})

const gcsOptions = [
  {
    label: '睁眼反应',
    field: 'eye',
    options: [
      { value: 4, label: '自主睁眼' },
      { value: 3, label: '呼唤睁眼' },
      { value: 2, label: '疼痛刺激' },
      { value: 1, label: '无反应' }
    ]
  },
  // 其他评分项...
]

const gcsTotal = computed(() => {
  return Object.values(gcsScore).reduce((a, b) => a + b, 0)
})

// 保存功能
const saveAssessment = async () => {
  const payload = {
    ti_score: tiTotal.value,
    ti_content: JSON.stringify(tiForm),
    gcs_score: gcsTotal.value,
    gcs_content: JSON.stringify(gcsScore)
  }
  
  try {
    // 这里替换实际API调用
    console.log('保存数据:', payload)
    showDialog.value = false
  } catch (err) {
    console.error('保存失败', err)
  }
}
</script>

<style scoped>
.score-card {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 20px;
  
  h3 {
    color: #2c3e50;
    margin-bottom: 12px;
  }
}

.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  
  &-item {
    background: white;
    padding: 8px;
    border-radius: 4px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    
    label {
      font-size: 12px;
      color: #666;
      display: block;
      margin-bottom: 4px;
    }
  }
}

.gcs-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  
  .subtitle {
    font-weight: 500;
    margin-bottom: 8px;
    color: #34495e;
  }
}

.total {
  margin-top: 12px;
  font-weight: bold;
  color: #27ae60;
}
</style>