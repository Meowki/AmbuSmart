<template>
  <div id="app">
    <!-- 顶部的导航栏 -->
    <div class="header">
      <div class="logo">PEC - AmbuSmart</div>
      <div class="nav-buttons">
        <button v-for="(label, index) in navLinks" :key="index" :class="{'active': activeTab === index}" @click="changeTab(index)">
          {{ label }}
        </button>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
      <div class="card">
        <div class="patient-info">
          <p>患者68岁，既往有高血压史，此次出现突发胸骨后压迫性胸痛已持续约20分钟，伴随出汗、恶心、心压90/60 mmHg，心率102次/分，呼吸急促。简单心电图显示ST段抬高。</p>
        </div>

        <!-- 当前选中的tab内容 -->
        <div v-if="activeTab === 0" class="tab-content">
          <h3>流程总结</h3>
          <p>初步判断为急性ST段抬高型心肌梗死（STEMI）。建议采取以下措施：</p>
          <ul>
            <li>1. 确保气道通畅：如果患者显得不清醒，考虑必要的气道管理措施。</li>
            <li>2. 给予高流量氧气，保持血氧饱和度94%以上。</li>
            <li>3. 药物治疗：
              <ul>
                <li>阿托伐他汀：如果患者未服药，口服300mg同口服液，呼吸吸收。</li>
                <li>硝酸甘油：舌下含服硝酸甘油0.4 mg，监测血压，避免低血压。</li>
                <li>抗凝药物：根据协作，考虑硫氢膦联合使用。</li>
              </ul>
            </li>
            <li>4. 静脉通道：建立双侧静脉通道，尽早进行静脉液体补充。</li>
            <li>5. 监测生命体征：持续监测心电图、血压、心率和血氧饱和度。</li>
          </ul>
        </div>

        <div v-if="activeTab === 1" class="tab-content">
          <h3>医院准备</h3>
          <p>医院已准备好急救设备并已联系相关科室，待患者到达后立即进行进一步检查与治疗。</p>
        </div>

        <div v-if="activeTab === 2" class="tab-content">
          <h3>患者具体信息</h3>
          <p>患者目前的症状及体征如上所述，进一步检查结果待出。</p>
        </div>

        <!-- 发送框 -->
        <div class="send-box">
          <textarea v-model="message" placeholder="输入消息..."></textarea>
          <button @click="sendReport">发送</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AmbuSmart',
  data() {
    return {
      activeTab: 0,  // 当前选中的tab索引
      navLinks: ['拒绝', '流程总结', '医院准备', '患者具体信息'],  // 导航栏内容
      message: ''  // 发送框的消息
    };
  },
  methods: {
    // 切换tab
    changeTab(index) {
      this.activeTab = index;
    },
    // 发送报告（这里可以实现发送逻辑）
    sendReport() {
      if (this.message) {
        alert(`报告已发送：${this.message}`);
        this.message = ''; // 发送后清空文本框
      } else {
        alert('请输入消息');
      }
    }
  }
};
</script>

<style scoped>
/* 基础布局 */
#app {
  font-family: Arial, sans-serif;
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #e0e7ff;
  min-height: 100vh;
}

/* 顶部导航栏 */
.header {
  background-color: rgba(255, 255, 255, 0.8);
  padding: 15px 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.logo {
  font-size: 24px;
  font-weight: bold;
  color: #005c8e;
}

.nav-buttons button {
  padding: 10px;
  margin: 0 5px;
  background-color: #ddd;
  border: none;
  cursor: pointer;
  font-size: 16px;
  border-radius: 5px;
}

.nav-buttons button.active {
  background-color: #005c8e;
  color: white;
}

/* 主内容 */
.main-content {
  width: 80%;
  max-width: 1200px;
  margin-top: 30px;
  background-color: rgba(255, 255, 255, 0.7);
  border-radius: 10px;
  backdrop-filter: blur(10px); /* 玻璃质感 */
  padding: 30px;
}

/* 玻璃质感卡片 */
.card {
  background-color: rgba(255, 255, 255, 0.7);
  padding: 20px;
  border-radius: 10px;
  backdrop-filter: blur(10px);
}

/* Tab 内容 */
.tab-content {
  margin-top: 20px;
}

.tab-content h3 {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.tab-content p {
  font-size: 16px;
  line-height: 1.6;
}

/* 发送框 */
.send-box {
  display: flex;
  flex-direction: column;
  margin-top: 20px;
}

.send-box textarea {
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ddd;
  border-radius: 10px;
  min-height: 100px;
  margin-bottom: 10px;
  resize: none;
  background-color: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(5px);
}

.send-box button {
  padding: 10px 20px;
  background-color: #005c8e;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}

.send-box button:hover {
  background-color: #004b70;
}
</style>
