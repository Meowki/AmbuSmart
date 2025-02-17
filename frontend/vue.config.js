const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: process.env.VUE_APP_API_BASE_URL, // 代理 API 请求，避免 CORS 问题
  },
  configureWebpack: {
    module: {
      rules: [
        {
          test: /\.jsx?$/, // 匹配 .js 和 .jsx 文件
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: [
                '@babel/preset-env', // 支持 ES6+
                '@babel/preset-react', // 支持 JSX
              ],
              plugins: [
                '@babel/plugin-transform-react-jsx', // 支持 JSX 转换
              ]
            },
          },
        },
      ],
    },
  },
});
