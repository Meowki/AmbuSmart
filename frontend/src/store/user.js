import { defineStore } from 'pinia';
import apiClient from '@/services/api';

export const useUserStore = defineStore('user', {
  state: () => ({
    userInfo: null,
  }),
  actions: {
    async fetchUser() {
      try {
        const res = await apiClient.get('/user/profile');
        this.userInfo = res.data;
      } catch (error) {
        console.error('获取用户信息失败', error);
      }
    },
  },
});
