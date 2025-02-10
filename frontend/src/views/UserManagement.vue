<template>
  <div>
    <h2>用户管理</h2>
    <form @submit.prevent="addUser">
      <input v-model="newUser.name" placeholder="姓名" required />
      <input v-model="newUser.email" placeholder="邮箱" type="email" required />
      <button type="submit">添加用户</button>
    </form>
    <ul>
      <li v-for="user in users" :key="user.id">
        {{ user.name }} - {{ user.email }}
        <button @click="removeUser(user.id)">删除</button>
      </li>
    </ul>
  </div>
</template>

<script>
import { getUsers, createUser, deleteUser } from '../services/userService';

export default {
  data() {
    return {
      users: [],
      newUser: {
        name: '',
        email: ''
      }
    };
  },
  methods: {
    async fetchUsers() {
      try {
        this.users = await getUsers();
      } catch (error) {
        console.error('获取用户失败:', error);
      }
    },
    async addUser() {
      try {
        const user = await createUser(this.newUser);
        this.users.push(user);
        this.newUser.name = '';
        this.newUser.email = '';
      } catch (error) {
        console.error('添加用户失败:', error);
      }
    },
    async removeUser(userId) {
      try {
        await deleteUser(userId);
        this.users = this.users.filter(user => user.id !== userId);
      } catch (error) {
        console.error('删除用户失败:', error);
      }
    }
  },
  created() {
    this.fetchUsers();
  }
};
</script>

<style scoped>
/* 添加一些样式 */
form {
  margin-bottom: 20px;
}
input {
  margin-right: 10px;
}
button {
  margin-left: 10px;
}
</style> 