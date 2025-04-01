<template>
  <div class="emergency-record">
    <!-- 头部信息增强 -->
    <div class="header-box">
      <div class="header-content">
        <h1 class="main-title">院前急救电子记录单</h1>
        <div class="operation-info">
          <div class="info-item">
            <span class="label">急救号：</span>
            <span class="value highlight">{{ currentOperation.operation_id }}</span>
          </div>
          <div class="info-item">
            <span class="label">出诊日期：</span>
            <span class="value">
  {{ currentOperation.dispatch_time?.split(' ')[0] || '-' }}
</span>

          </div>
        </div>
      </div>
    </div>


    <!-- 患者信息卡片优化 -->
    <el-card class="section-card patient-card">
      <el-descriptions title="患者基本信息" :column="3" border>
        <el-descriptions-item label="姓名" label-class-name="desc-label">{{ currentOperation.name }}</el-descriptions-item>
        <el-descriptions-item label="性别">{{ currentOperation.sex }}</el-descriptions-item>
        <el-descriptions-item label="年龄">{{ currentOperation.age }}</el-descriptions-item>
        <el-descriptions-item label="证件类型">{{ currentOperation.idType }}</el-descriptions-item>
        <el-descriptions-item label="证件号码">{{ currentOperation.patient_id }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ currentOperation.telno }}</el-descriptions-item>
        <el-descriptions-item label="居住地址">{{ currentOperation.address }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

      <!-- 时间轴可视化 -->
    <el-card class="section-card timeline-card">
        <div class="card-header" >
          <i class="el-icon-time"></i>
          <span><strong>关键时间节点</strong></span>
        </div>
      <div class="timeline-container">
        <el-steps :active="4" align-center>
          <el-step title="派车" :description="currentOperation.dispatch_time" />
          <el-step title="到达现场" :description="currentOperation.arrival_on_scene_time" />
          <el-step title="离开现场" :description="currentOperation.departure_from_scene_time" />
          <el-step title="到达医院" :description="currentOperation.arrival_at_hospital_time" />
        </el-steps>
      </div>
    </el-card>

    <!-- 现场信息 -->
    <el-card class="section-card">
      <el-descriptions title="现场信息" :column="2" border>
        <el-descriptions-item label="供史者">{{ currentOperation.informant }}</el-descriptions-item>
        <el-descriptions-item label="现场地址">{{ currentOperation.scene_address }}</el-descriptions-item>
        <el-descriptions-item label="急救性质">{{ currentOperation.emergency_type }}</el-descriptions-item>
        <el-descriptions-item label="病情分级">{{ currentOperation.severity_level }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <div class="diagnosis-section">
        <h4>主诉症状：</h4>
        <el-alert :title="currentOperation.chief_complaint" type="warning" :closable="false" />
      </div>

       <div class="diagnosis-section">
        <h4>初步诊断：</h4>
        <el-alert :title="currentOperation.initial_diagnosis " type="warning" :closable="false" />
      </div>
      

<div class="evaluation-cards">
    <!-- TI评分卡片 -->
    <el-card class="evaluation-card">
      <div class="card-header">TI评分</div>
      <div class="card-content">
        <div class="eval-total">总分：{{ currentOperation.ti_score }}</div>
        <ul v-if="currentOperation.ti_content" class="eval-details">
          <li v-for="(value, key) in parseAndFilter(currentOperation.ti_content)" :key="key">
            <strong>{{ formatKey(key) }}:</strong>
            <span v-if="Array.isArray(value)">{{ value.join(', ') }}</span>
            <span v-else>{{ value }}</span>
          </li>
        </ul>
      </div>
    </el-card>

    <!-- GCS评分卡片 -->
    <el-card class="evaluation-card">
      <div class="card-header">GCS评分</div>
      <div class="card-content">
        <div class="eval-total">总分：{{ currentOperation.gcs_score }}</div>
        <ul v-if="currentOperation.gcs_content" class="eval-details">
          <li v-for="(value, key) in parseAndFilter(currentOperation.gcs_content)" :key="key">
            <strong>{{ formatKey(key) }}:</strong>
            <span v-if="Array.isArray(value)">{{ value.join(', ') }}</span>
            <span v-else>{{ value }}</span>
          </li>
        </ul>
      </div>
    </el-card>

    <!-- 胸痛评估卡片 -->
    <el-card class="evaluation-card">
      <div class="card-header">胸痛评估</div>
      <div class="card-content">
        <div class="eval-total">Killip分级：{{ currentOperation.Killip_score }}</div>
        <ul v-if="currentOperation.Killip_content" class="eval-details">
          <li v-for="(value, key) in parseAndFilter(currentOperation.Killip_content)" :key="key">
            <strong>{{ formatKey(key) }}:</strong>
            <span v-if="Array.isArray(value)">{{ value.join(', ') }}</span>
            <span v-else>{{ value }}</span>
          </li>
        </ul>
        <div v-if="currentOperation.Killip_diagnosis" class="eval-diagnosis">
          <strong>初步诊断:</strong> {{ currentOperation.Killip_diagnosis }}
        </div>
      </div>
    </el-card>

    <!-- 卒中评估卡片 -->
    <el-card class="evaluation-card">
      <div class="card-header">卒中评估</div>
      <div class="card-content">
        <ul v-if="currentOperation.cerebral_stroke_content" class="eval-details">
          <li v-for="(value, key) in parseAndFilter(currentOperation.cerebral_stroke_content)" :key="key">
            <strong>{{ formatKey(key) }}:</strong>
            <span v-if="Array.isArray(value)">{{ value.join(', ') }}</span>
            <span v-else>{{ value }}</span>
          </li>
        </ul>
      </div>
    </el-card>
  </div>


    <!-- 检查记录 -->
    <el-card class="section-card">
      <div class="check-section">
        <el-descriptions title="初始检查" :column="3" >
          <el-descriptions-item >{{ currentOperation.initial_check?.timestamp }}</el-descriptions-item>
          <el-descriptions-item label="拒检">{{ currentOperation.initial_check?.reject === 1 ? '是' : '否' }}</el-descriptions-item>
          <el-descriptions-item label="神志">{{ currentOperation.initial_check?.consciousness }}</el-descriptions-item>
          <el-descriptions-item label="瞳孔（左/右）">{{ currentOperation.initial_check?.pupil }}</el-descriptions-item>
          <el-descriptions-item label="对光反射">{{ currentOperation.initial_check?.pupillary_light_reflex }}</el-descriptions-item>
          <el-descriptions-item label="血压（mmHg）">{{ currentOperation.initial_check?.blood_pressure }}</el-descriptions-item>
          <el-descriptions-item label="脉搏（次/分）">{{ currentOperation.initial_check?.pulse }}</el-descriptions-item>
          <el-descriptions-item label="呼吸（次/分）">{{ currentOperation.initial_check?.respiration }}</el-descriptions-item>
          <el-descriptions-item label="血氧（%）">{{ currentOperation.initial_check?.oxygen_saturation }}</el-descriptions-item>
        </el-descriptions>

        <el-descriptions title="最终检查" :column="3"  style="margin-top: 20px;" >
          <el-descriptions-item >{{ currentOperation.final_check?.timestamp }}</el-descriptions-item>
          <el-descriptions-item label="拒检">{{ currentOperation.final_check?.reject === 1 ? '是' : '否' }}</el-descriptions-item>
          <el-descriptions-item label="神志">{{ currentOperation.final_check?.consciousness }}</el-descriptions-item>
          <el-descriptions-item label="瞳孔（左/右）">{{ currentOperation.final_check?.pupil }}</el-descriptions-item>
          <el-descriptions-item label="对光反射">{{ currentOperation.final_check?.pupillary_light_reflex }}</el-descriptions-item>
          <el-descriptions-item label="血压（mmHg）">{{ currentOperation.final_check?.blood_pressure }}</el-descriptions-item>
          <el-descriptions-item label="脉搏（次/分）">{{ currentOperation.final_check?.pulse }}</el-descriptions-item>
          <el-descriptions-item label="呼吸（次/分）">{{ currentOperation.final_check?.respiration }}</el-descriptions-item>
          <el-descriptions-item label="血氧（%）">{{ currentOperation.final_check?.oxygen_saturation }}</el-descriptions-item>
        </el-descriptions>
      </div>
    </el-card>

    <!-- 处置信息 -->
    <el-card class="section-card">
      <el-descriptions title="处置记录" :column="1" border>
        <el-descriptions-item label="急救处理">{{ currentOperation.procedures }}</el-descriptions-item>
        <el-descriptions-item label="药物使用记录">{{ currentOperation.medicine }}</el-descriptions-item>
        <el-descriptions-item label="急救结果">{{ currentOperation.outcome }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

        <div class="treatment-plan">
        <h4>处理措施：</h4>
        <ul>
          <!-- 检查 measures 是否为非空字符串 -->
          <li v-for="(item, index) in (currentOperation.procedures ? currentOperation.procedures.split('，') : [])" :key="index">
            <el-icon><caret-right /></el-icon>
            {{ item }}
          </li>
        </ul>
      </div>

    <!-- 签名区 -->
    <div class="signature-area">
      <el-descriptions :column="3" border>
        <el-descriptions-item label="医师">{{ currentOperation.physician }}</el-descriptions-item>
        <el-descriptions-item label="护士">{{ currentOperation.nurse }}</el-descriptions-item>
        <el-descriptions-item label="司机">{{ currentOperation.driver }}</el-descriptions-item>
        <el-descriptions-item label="担架工">{{ currentOperation.stretcher_bearer }}</el-descriptions-item>
        <el-descriptions-item label="抢救员">{{ currentOperation.paramedic }}</el-descriptions-item>
        <el-descriptions-item label="院内接收员"> {{ currentOperation.recipient }}</el-descriptions-item>
      </el-descriptions>
    </div>
  </div>
</template>

<script setup>
import { CaretRight } from '@element-plus/icons-vue'
import { ref, defineProps, watch } from 'vue';

// 接收 records-----------------------------------------------
const props = defineProps({
  records: {
    type: Array,
    default: () => []
  }
});

const currentOperation = ref({});  
console.log("接收到的记录:", props.records);
  

watch(
  () => props.records,
  (newRecords) => {
    const rawRecords = JSON.parse(JSON.stringify(newRecords));
    console.log("解包后记录:", rawRecords);
    
    if (rawRecords) {
      currentOperation.value = rawRecords[0] || {};
      console.log("当前记录:", JSON.stringify(currentOperation.value));
    } else {
      currentOperation.value = {};
    }
  },
  { immediate: true, deep: true } 
);

function parseAndFilter(content) {
  try {
    const parsed = content;
    const result = {};
    Object.keys(parsed).forEach(key => {
      if (!key.toLowerCase().includes("score")) {
        result[key] = parsed[key];
      }
    });
    console.log("result:"+result)
    return result;
  } catch (e) {
    return {};
  }
}

// 可选：将 key 格式化为更友好的显示文字
function formatKey(key) {
  const mapping = {
    circulation: "循环状态",
    injury_site: "受伤部位",
    injury_type: "损伤类型",
    respiration: "呼吸状态",
    consciousness: "意识状态",
    highRisk: "高危状态",
    otherHighRisk: "其它说明",
    gcs_e: "睁眼评分",
    gcs_m: "言语评分",
    gcs_v: "运动评分",
    selected: "评估项",
    other: "其它"
  };
  return mapping[key] || key;
}
</script>

<style scoped lang="scss">
.emergency-record {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

.header-box {
  background: linear-gradient(135deg, #409EFF, #337ecc);
  color: white;
  padding: 24px 32px;
  border-radius: 8px;
  margin-bottom: 24px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);

  .main-title {
    font-size: 24px;
    margin: 0 0 12px;
    letter-spacing: 1px;
  }

  .operation-info {
    display: flex;
    gap: 32px;

    .info-item {
      display: flex;
      align-items: center;
      font-size: 14px;

      .label {
        opacity: 0.8;
      }

      .value {
        font-weight: 500;

        &.highlight {
          font-size: 16px;
          color: #ffd04b;
        }
      }
    }
  }
}

.section-card {
  margin-bottom: 20px;
  border-radius: 8px;
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);

  ::v-deep .el-card__header {
    background-color: #f8fafc;
    border-bottom: 2px solid #e4e7ed;
    padding: 12px 20px;

    .card-header {
      display: flex;
      align-items: center;
      font-weight: 500;

      i {
        font-size: 18px;
        margin-right: 8px;
        color: #409EFF;
      }
    }
  }
}

.patient-card {
  ::v-deep .el-descriptions__body {
    background-color: white;
  }

  .desc-label {
    background-color: #f8fafc !important;
  }
}

.timeline-card {
  ::v-deep .el-steps {
    padding: 20px;

    .el-step__head {
      &.is-process {
        color: #409EFF;
        border-color: #409EFF;
      }
    }

    .el-step__title {
      font-size: 14px;
      color: #606266;
    }

    .el-step__description {
      color: #909399;
      font-size: 12px;
    }
  }
}

.assessment-group {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 16px;
  margin-bottom: 20px;

  .assessment-card {
    transition: transform 0.3s;

    &:hover {
      transform: translateY(-2px);
    }

    .card-header-sm {
      font-size: 14px;
      display: flex;
      align-items: center;

      i {
        margin-right: 6px;
        font-size: 16px;
      }
    }

    .score-box {
      padding: 12px;
      border-radius: 6px;
      color: white;
      margin-bottom: 12px;
      display: flex;
      justify-content: space-between;
      align-items: center;

      .score-label {
        font-size: 12px;
      }

      .score-value {
        font-size: 24px;
        font-weight: bold;
      }
    }

    .desc-compact {
      ::v-deep .el-descriptions__row {
        td {
          padding: 4px 0;
        }
      }
    }
  }
}

.evaluation-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.evaluation-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.card-header {
  font-size: 16px;
  font-weight: 500;
  padding: 12px 20px;
  background-color: #f8fafc;
  border-bottom: 1px solid #e4e7ed;
}

.card-content {
  padding: 12px 20px;
}

.eval-total {
  font-size: 14px;
  margin-bottom: 6px;
}

.eval-details {
  list-style: none;
  padding: 0;
  margin: 0;
}

.eval-details li {
  font-size: 13px;
  line-height: 1.5;
  padding: 2px 0;
}

.eval-diagnosis {
  margin-top: 8px;
  font-size: 13px;
}

.procedure-card {
  .procedure-list {
    .procedure-item {
      display: flex;
      padding: 12px 0;
      border-bottom: 1px solid #ebeef5;

      &:last-child {
        border-bottom: none;
      }

      .step-icon {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: #409EFF;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16px;
        flex-shrink: 0;
      }

      .step-content {
        flex: 1;

        .step-title {
          font-weight: 500;
          color: #303133;
        }

        .step-detail {
          color: #606266;
          font-size: 13px;
          margin: 4px 0;
        }

        .step-time {
          color: #909399;
          font-size: 12px;
        }
      }
    }
  }
}

.signature-area {
  background: white;
  padding: 20px;
  border-radius: 8px;
  margin-top: 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);

  ::v-deep .el-descriptions__label {
    background: #f8fafc !important;
    font-weight: 500;
  }
}
</style>