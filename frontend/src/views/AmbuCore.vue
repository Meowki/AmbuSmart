<template>
  <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />

  <!--1. chat + 模板添加，补充主诉等 -->
  <!--2. timeline,到达/出发/到达 -->
  <!--3. 手动查看患者具体信息，（门诊/急救/住院）历史，过敏史与既往史 -->
  <!--4. 自动总结现在患者情况，以及过程记录（检查和用药） -->
  <!--5. 严重情况、基础检查填写表 -->
  <!--6. 自动总结患者诊断结果，为目标医院发送信息（可能是在下一步） -->
</template>

<script setup>
import { ref } from 'vue';
import NavigationBar from '@/components/NavigationBars.vue';

const currentStep = ref('决策系统');
</script>

<style scoped>

</style>
