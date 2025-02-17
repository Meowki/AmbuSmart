<template>
  <div class="ambu-core">
    <!-- 顶部导航按钮组 -->
    <div class="nav-buttons">
      <el-button type="success">抵达</el-button>
      <el-button type="primary">流程总结</el-button>
      <el-button type="primary">院内准备</el-button>
      <el-button type="primary">患者具体信息</el-button>
    </div>

    <!-- 患者信息卡片 -->
    <el-card class="patient-info" shadow="hover">
      <div class="info-content">
        <el-avatar icon="el-icon-user" size="large" class="patient-avatar" />
        <div class="info-text">
          患者68岁，既往有高血压史，此次出现突发胸痛并后压榨性传痛已持续约20分钟，伴出汗、恶心、血压 90/60 mmHg，心率 102 次/分，呼吸急促。简单心电图显示 ST 段抬高。
        </div>
      </div>
    </el-card>

    <!-- 医疗建议内容区域 -->
    <el-card class="medical-advice" shadow="hover">
      <div class="advice-header">
        <el-icon><Plus /></el-icon>
        初步判断为急性ST段抬高型心肌死亡（STEMI）。建议采取以下措施：
      </div>
      <div class="advice-content">
        <ol>
          <li>确保气道通畅：如果患者意识不清，考虑必要的气道管理措施。</li>
          <li>氧疗：给予高流量氧气，保持血氧饱和度在94%以上。</li>
          <li>药物治疗：
            <ul>
              <li>阿司匹林：如果患者未过敏，口服300 mg阿司匹林，咀嚼吸收。</li>
              <li>硝酸甘油：舌下含服硝酸甘油0.4 mg，监测血压，避免低血压加重。</li>
              <li>抗凝药物：根据协议，考虑静脉注射肝素或其他抗凝药物。</li>
            </ul>
          </li>
          <li>静脉通路：建立双侧静脉通路，便于药物快速输注。</li>
          <li>监测生命体征：持续监测心电图、血压、心率和血氧饱和度。</li>
        </ol>
      </div>
    </el-card>

    <!-- 底部操作栏 -->
    <div class="bottom-bar">
      <el-button circle>
        <el-icon><Link /></el-icon>
      </el-button>
      <div class="right-buttons">
        <el-button>知识图谱</el-button>
        <el-button>快速输入</el-button>
        <el-button>量化评分表</el-button>
        <el-button circle>
          <el-icon><Message /></el-icon>
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Plus, Link, Message } from '@element-plus/icons-vue';
</script>

<style scoped>
.ambu-core {
  padding: 20px;
  min-height: 100vh;
  background-color: #f5f7fa;
}

.nav-buttons {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.patient-info {
  margin-bottom: 20px;
}

.info-content {
  display: flex;
  align-items: flex-start;
  gap: 16px;
}

.info-text {
  flex: 1;
  line-height: 1.6;
}

.medical-advice {
  margin-bottom: 20px;
}

.advice-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
  font-weight: bold;
}

.advice-content ol {
  margin: 0;
  padding-left: 20px;
}

.advice-content li {
  margin-bottom: 12px;
}

.advice-content ul {
  margin: 8px 0;
  padding-left: 20px;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16px;
  background-color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

.right-buttons {
  display: flex;
  gap: 10px;
  align-items: center;
}
</style>
