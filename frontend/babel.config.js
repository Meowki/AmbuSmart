module.exports = {
  presets: [
    '@vue/cli-plugin-babel/preset', // Vue 默认的 Babel preset
    '@babel/preset-env',  // 支持 ES6+
    '@babel/preset-react' // 支持 React JSX
  ],
  plugins: [
    '@babel/plugin-transform-react-jsx', // 支持 React JSX
    '@vue/babel-plugin-jsx', // 支持 Vue JSX
    '@babel/plugin-transform-private-methods'
  ]
};
