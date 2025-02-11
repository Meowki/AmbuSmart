<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />
</template>

<script setup>
import { ref } from 'vue';
import NavigationBar from '@/components/NavigationBars.vue';

const currentStep = ref('统计分析');
</script>

<style scoped>

</style>
