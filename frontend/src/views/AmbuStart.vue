<template>
  <div class="operation-form">
    <NavigationBar :activeStep="currentStep" @exit="() => console.log('退出')" />
    
    <el-card class="form-card">
      <el-form :model="formData" label-width="120px">
        <el-form-item label="司机">
          <el-input v-model="formData.driver" placeholder="请输入司机姓名" />
        </el-form-item>
        
        <el-form-item label="护士">
          <el-input v-model="formData.nurse" placeholder="请输入护士姓名" />
        </el-form-item>
        
        <el-form-item label="担架工">
          <el-input v-model="formData.stretcher_bearer" placeholder="请输入担架工姓名" />
        </el-form-item>
        
        <el-form-item label="特殊处理">
          <el-checkbox-group v-model="formData.specialHandling">
            <el-checkbox label="中毒">中毒</el-checkbox>
            <el-checkbox label="传染病">传染病</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        
        <el-divider>救护车设备与药品检查</el-divider>
        <el-checkbox-group v-model="formData.equipmentCheck">
          <el-checkbox v-for="item in equipmentList" :key="item" :label="item">{{ item }}</el-checkbox>
        </el-checkbox-group>
        
        <el-form-item>
          <el-button type="primary" @click="submitForm">提交</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import NavigationBar from '@/components/NavigationBars.vue';
import { ElMessage } from 'element-plus';

const currentStep = ref('出车准备');
const formData = ref({
  driver: '',
  nurse: '',
  stretcher_bearer: '',
  specialHandling: [],
  equipmentCheck: []
});

const equipmentList = [
  '氧气瓶', '呼吸机', '心电监护仪', '急救药品', '担架床'
];

const submitForm = () => {
  console.log('提交数据:', formData.value);
  ElMessage.success('数据已提交');
};
</script>

<style scoped>
.operation-form {
  padding: 20px;
}

.form-card {
  max-width: 600px;
  margin: auto;
}
</style>
