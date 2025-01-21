<template>
  <div class="home">
    <h1>欢迎来到聊天应用</h1>
    <router-link to="/chat">进入聊天窗口</router-link>
  </div>
</template>

<script>
export default {
  name: 'HomePage'
}
</script>

<style scoped>
.home {
  text-align: center;
  margin-top: 100px;
}

.home a {
  display: inline-block;
  margin-top: 20px;
  padding: 10px 20px;
  background-color: #4a90e2;
  color: #ffffff;
  border-radius: 5px;
  text-decoration: none;
  transition: background-color 0.3s;
}

.home a:hover {
  background-color: #357ab8;
}
</style>
