<template>
  <transition name="fade-soft" appear>
  <header class="navbar">
    <div class="logo">PEC-AmbuSmart</div>
    <div class="steps">
      <div v-for="(step, index) in steps" :key="index" 
           :class="['step', { active: step === activeStep }]">
        {{ step }}
        <span v-if="index !== steps.length - 1" class="separator">></span>
      </div>
    </div>
    <div class="exit" @click="confirmExit">
      <img src="/icon/exit.png" alt="Exit" class="exit-icon" />
    </div>
  </header>

   <el-dialog v-model="showConfirm" title="退出" width="30%" align-center>
      <span>确认取消本次急救及<b style="color: red">相关所有记录</b>，返回主页？</span>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showConfirm = false">取消</el-button>
          <el-button type="primary" @click="exitToHome">确认</el-button>
        </span>
      </template>
    </el-dialog>
  </transition>
</template>

<script setup>
import { defineProps, ref } from 'vue';
import { useStore } from 'vuex';  
import { useRouter } from 'vue-router';  
import api from "@/services/api";

const store = useStore();  
const router = useRouter();  
const showConfirm = ref(false);

defineProps({
  activeStep: String
});

const steps = ['出车准备', '信息采集', '决策系统', '统计分析', '急救结束'];

const confirmExit = () => {
  showConfirm.value = true;
};

const exitToHome = async () => {
  showConfirm.value = false;

  const operationId = store.state.operation_id; 
  console.log("Operation ID stored in Vuex:", operationId);

  if (operationId) {
    try {
      await api.delete(`/operation_histories/delete/${operationId}`);
      console.log("Operation record deleted successfully");
    } catch (error) {
      console.error("Failed to delete operation record:", error);
    }
  }

  store.commit("setOperationId", null); // 清空 Vuex 里的 operation_id

  router.push('/'); // 跳转回主页
};
</script>


<style scoped>

.fade-soft-enter-active {
  transition: opacity 0.6s ease-in;
}
.fade-soft-enter-from {
  opacity: 0.4;
}

.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 30px;
  background: rgba(0, 91, 187, 0.8);
  backdrop-filter: blur(10px);
  color: white;
  font-weight: bold;
  height: 50px;
  border-radius: 12px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

.logo {
  font-size: 18px;
  font-weight: bold;
}

.steps {
  display: flex;
  align-items: center;
}

.step {
  padding: 0 5px;
  transition: color 0.3s, transform 0.2s;
  cursor: pointer;
}

.step.active {
  color: #ffd700;
  font-weight: bold;
  position: relative;
}

.step.active::after {
  content: "";
  position: absolute;
  left: 50%;
  bottom: -5px;
  width: 50%;
  height: 3px;
  background: #ffd700;
  transform: translateX(-60%);
  border-radius: 2px;
}

.step:hover {
  transform: scale(1.05);
  color: #fff;
}

.separator {
  margin: 0 5px;
  color: rgba(255, 255, 255, 0.6);
}

.exit {
  cursor: pointer;
  transition: transform 0.2s;
}

.exit-icon {
  width: 24px;
  height: 24px;
  transition: transform 0.2s;
}

.exit:hover .exit-icon {
  transform: scale(1.1);
}
</style>
