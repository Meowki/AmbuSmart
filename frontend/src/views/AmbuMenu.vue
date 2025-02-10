<template>
  <div class="home-container">
    <h1 class="title">AmbuSmart 急救医疗辅助平台</h1>
    <p class="subtitle">🚑 智能辅助，守护生命</p>
    <el-button type="danger" class="start-button" @click="startEmergency">
      进入急救
    </el-button>
    <div class="card-container">
      <el-card class="card" shadow="always">
        <div class="card-content">
          <p>📞 紧急求救</p>
        </div>
      </el-card>
      <el-card class="card" shadow="always">
        <div class="card-content">
          <p>📖 急救指南</p>
        </div>
      </el-card>
      <el-card class="card" shadow="always">
        <div class="card-content">
          <p>🌍 最近医院</p>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script>
export default {
  name: "AmbuMenu",
  methods: {
    startEmergency() {
      this.$router.push("/emergency");
    },
  },
};
</script>

<style scoped>
.home-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  padding: 50px;
  background: linear-gradient(to bottom, #e0f7fa, #ffffff);
  height: 100vh;
  animation: fadeIn 1.5s ease-in-out;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}
.title {
  font-size: 32px;
  font-weight: bold;
  margin-bottom: 10px;
  animation: fadeIn 1.5s ease-in-out;
}
.subtitle {
  font-size: 18px;
  color: #666;
  margin-bottom: 30px;
  animation: fadeIn 1.5s ease-in-out;
}
.start-button {
  font-size: 20px;
  padding: 15px 40px;
  margin-bottom: 40px;
  transition: transform 0.2s;
}
.start-button:hover {
  transform: scale(1.05);
}
.card-container {
  display: flex;
  gap: 20px;
}
.card {
  width: 180px;
  text-align: center;
  font-size: 16px;
  padding: 20px;
  border-radius: 15px;
  transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
}
.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}
.card-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
</style>