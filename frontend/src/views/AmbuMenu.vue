<template>
    <div style="z-index: 0" class="waveWrapper waveAnimation">
  <div class="waveWrapperInner bgTop">
    <div class="wave waveTop" style="background-image: url('http://front-end-noobs.com/jecko/img/wave-top.png')"></div>
  </div>
  <div class="waveWrapperInner bgMiddle">
    <div class="wave waveMiddle" style="background-image: url('http://front-end-noobs.com/jecko/img/wave-mid.png')"></div>
  </div>
  <div class="waveWrapperInner bgBottom">
    <div class="wave waveBottom" style="background-image: url('http://front-end-noobs.com/jecko/img/wave-bot.png')"></div>
  </div>
  </div>
   <div class="home-container">
    <el-card class="main-card" shadow="always">
      <h1 class="title">PEC - AmbuSmart 院前急救平台</h1>
      <p class="subtitle">🚑 智能辅助，守护生命</p>
      <el-button type="danger" class="start-button" @click="startEmergency">
        进入急救
      </el-button>
      <div class="card-container">
        <el-card class="card" shadow="always">
          <div class="card-content">
            <p>📞 历史记录</p>
          </div>
        </el-card>
        <el-card class="card" shadow="always">
          <div class="card-content">
            <p>📖 急救手册</p>
          </div>
        </el-card>
        <el-card class="card" shadow="always">
          <div class="card-content">
            <p>🌍 最近医院</p>
          </div>
        </el-card>
      </div>
    </el-card>
  </div>
</template>

<script>
import api from "@/services/api";

export default {
  name: "HomePage",
  // methods: {
  //   startEmergency() {
  //     this.$router.push("/AmbuStart");
  //   },
  // },
  data() {
  return {
    operation_id: null, // 用于存储 operation_id
  };
},
methods: {
  
  async startEmergency() {
    try {
      // 发送请求创建 operation_history 记录
     const response = await api.post("/operation_histories/",{
        patient_id: null,
        informant: null,
        scene_address: null,
        dispatch_time: new Date().toISOString(),
        arrival_on_scene_time: null,
        departure_from_scene_time: null,
        arrival_at_hospital_time: null,
        destination: null,
        severity_level: null,
        emergency_type: null,
        chief_complaint: null,
        initial_diagnosis: null,
        procedures: null,
        medicine: null,
        outcome: null,
        physician: null,
        nurse: null,
        driver: null,
        paramedic: null,
        stretcher_bearer: null,
        recipient: null,
        initial_eid: null,
        final_eid: null,
        ti_score: null,
        ti_content: null,
        gcs_score: null,
        gcs_content: null,
        Killip_score: null,
        Killip_content: null,
        Killip_diagnosis: null,
        cerebral_stroke_content: null
      });

      // 存储 operation_id
      this.operation_id = response.data.operation_id; 
      console.log("Operation created, ID:", this.operation_id);

      // 记录到 Vuex 
      this.$store.commit("setOperationId", this.operation_id);
      console.log("Operation ID stored in Vuex:", this.$store.state.operation_id);

      // 跳转到急救页面，并传递 ID
      this.$router.push({ path: "/AmbuStart", query: { operation_id: this.operation_id } });
    } catch (error) {
      console.error("Failed to create operation history:", error);
    }
  }
}

};
</script>

<style scoped>
.home-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  animation: fadeIn 1.5s ease-in-out;
  height: 100vh;
}
.main-card {
  padding: 10px;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  margin-top: -30px;
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
  color: white;
}
.subtitle {
  font-size: 18px;
  color: white;
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
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(8px);
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
@keyframes move_wave {
    0% { transform: translateX(0) translateZ(0) scaleY(1) }
    50% { transform: translateX(-25%) translateZ(0) scaleY(0.55) }
    100% { transform: translateX(-50%) translateZ(0) scaleY(1) }
}
.waveWrapper {
    overflow: hidden;
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    top: 0;
    margin: auto;
}
.waveWrapperInner {
    position: absolute;
    width: 100%;
    overflow: hidden;
    height: 100%;
    bottom: -1px;
    background-image: linear-gradient(to top, #75adee 20%, #002b88 80%);
}
.bgTop {
    z-index: 15;
    opacity: 0.5;
}
.bgMiddle {
    z-index: 10;
    opacity: 0.75;
}
.bgBottom {
    z-index: 5;
}
.wave {
    position: absolute;
    left: 0;
    width: 200%;
    height: 100%;
    background-repeat: repeat no-repeat;
    background-position: 0 bottom;
    transform-origin: center bottom;
}
.waveTop {
    background-size: 50% 100px;
}
.waveAnimation .waveTop {
  animation: move-wave 3s;
   -webkit-animation: move-wave 3s;
   -webkit-animation-delay: 1s;
   animation-delay: 1s;
}
.waveMiddle {
    background-size: 50% 120px;
}
.waveAnimation .waveMiddle {
    animation: move_wave 10s linear infinite;
}
.waveBottom {
    background-size: 50% 100px;
}
.waveAnimation .waveBottom {
    animation: move_wave 15s linear infinite;
}
</style>
