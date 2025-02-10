<template>
  <div>
    <h2>检查项目列表</h2>
    <ul>
      <li v-for="check in checks" :key="check.cid">
        <h3>{{ check.name }}</h3>
      </li>
    </ul>
  </div>
</template>

<script>
// import { reactive, onMounted } from 'vue';
import axios from 'axios';

export default {
  name: 'CheckList',
  data() {
    return {
      checks: [],
    };
  },
  mounted() {
    this.fetchChecks();
  },
  methods: {
    async fetchChecks() {
      try {
        const response = await axios.get('http://localhost:8000/api/check');
        console.log(response.data);
        this.checks = response.data;
      } catch (error) {
        console.error('获取检查项目列表失败', error);
      }
    },
  },
};
</script>

<style scoped>
/* 可选的样式 */
</style>
