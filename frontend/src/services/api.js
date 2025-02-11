import axios from "axios";

const api = axios.create({
  baseURL: process.env.VUE_APP_API_BASE_URL, // 确保用的是 Vue CLI 变量
});

export default api;
