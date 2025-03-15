<template>
  <NavigationBar :activeStep="currentStep" @exit="handleExit" />
  <div class="container">
    <el-card class="end-card" shadow="hover">
      <h2>急救记录结束</h2>
      <p>您的急救记录已成功结束，感谢您的使用！</p>
      <el-button type="primary" @click="goHome">返回首页</el-button>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import NavigationBar from '@/components/NavigationBars.vue'

const currentStep = ref('急救结束')
const router = useRouter()

function goHome() {
  router.push('/')
}

function handleExit() {
  console.log('退出')
}
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 60px); /* 根据导航栏高度调整 */
}

.end-card {
  text-align: center;
}
</style>
