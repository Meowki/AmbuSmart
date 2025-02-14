<template>
<div class="exit" @click="confirmExit">
      <img src="/icon/exit.png" alt="Exit" class="exit-icon" />
    </div>
    
    <el-dialog v-model="showConfirm" title="确认退出" width="30%" center>
      <span>确认取消本次急救及记录，返回主页？</span>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showConfirm = false">取消</el-button>
          <el-button type="primary" @click="exitToHome">确认</el-button>
        </span>
      </template>
    </el-dialog>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const showConfirm = ref(false);

const confirmExit = () => {
  showConfirm.value = true;
};

const exitToHome = () => {
  showConfirm.value = false;
  router.push('/');
};
</script>

<style scoped>

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
