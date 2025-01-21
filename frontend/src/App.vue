<template>
  <router-view></router-view>
</template>

<script>
import axios from 'axios'

export default {
  name: 'App',
  data() {
    return {
      message: ''
    }
  },
  mounted() {
    axios.get('http://localhost:8000/api/chat')
      .then(response => {
        this.message = response.data.message
      })
      .catch(error => {
        console.error("There was an error!", error);
      })
  }
}
</script>

<style>
#app {
  margin: 0;
  font-family: Avenir, Helvetica, Arial, sans-serif;
  background-color: #f5f5f5;
}
</style>
