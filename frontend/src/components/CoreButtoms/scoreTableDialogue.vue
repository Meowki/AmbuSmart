<template>
  <!-- 触发弹窗按钮 -->
  <el-button type="primary" @click="openScoreDialog">评估评分</el-button>

  <!-- 评估评分的对话框 -->
  <el-dialog
    title="评分评估"
    v-model="dialogVisibleScore"
    width="70%"
    :close-on-click-modal="false"
  >
    <el-collapse v-model="activeNames" accordion>
      <!-- 创伤指数评分折叠项 -->
      <el-collapse-item title="创伤指数评分 (TI)" name="1">
        <TiScore />
      </el-collapse-item>

      <!-- GCS评分折叠项 -->
      <el-collapse-item title="格拉斯哥昏迷评分（GCS）" name="2">
        <GcsScore />
      </el-collapse-item>

      <!-- Killip评分折叠项 -->
      <el-collapse-item title="Killip评分" name="3">
      </el-collapse-item>

      <!-- 脑卒中评估折叠项 -->
      <el-collapse-item title="脑卒中评估" name="4">
        
      </el-collapse-item>
    </el-collapse>

    <el-button @click="dialogVisibleScore = false" style="margin-top: 20px"
      >关闭</el-button
    >
  </el-dialog>
</template>

<script>
import { ref } from "vue";
import TiScore from "@/components/ScoreValueForm/TiScore.vue";
import GcsScore from "@/components/ScoreValueForm/GcsScore.vue";

export default {
  components: {
    TiScore,
    GcsScore,
  },
  setup() {
    const activeNames = ref(["1"]);

    const dialogVisibleScore = ref(false);

    const openScoreDialog = () => {
      dialogVisibleScore.value = true;
    };

    return {
      dialogVisibleScore,
      activeNames,
      openScoreDialog,
    };
  },
};
</script>

<style scoped>
.score-form {
  margin-top: 20px;
}
</style>
