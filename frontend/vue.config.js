const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: process.env.VUE_APP_API_BASE_URL, // 代理 API 请求，避免 CORS 问题
  }
});
