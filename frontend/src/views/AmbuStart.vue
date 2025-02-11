<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />
</template>

<script setup>
import { ref } from 'vue';
import NavigationBar from '@/components/NavigationBars.vue';

const currentStep = ref('出车准备'); // 根据当前页面动态修改
</script>

<style scoped>
.nav-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 15px 30px;
  background: linear-gradient(to right, #1b365d, #294d8d);
  color: white;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.logo {
  font-size: 20px;
  font-weight: bold;
}

.breadcrumb {
  flex: 1;
  display: flex;
  justify-content: center;
  font-size: 16px;
}

.breadcrumb .active {
  font-weight: bold;
  color: #ffd700;
}

.exit-button {
  background-color: #d9534f;
  border: none;
  padding: 8px 16px;
  font-size: 14px;
}
</style>
