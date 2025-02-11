import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import router from './router'
import store from './store'


createApp(App)
  .use(router)
  .use(ElementPlus)
  .use(store)
  .mount('#app')

  // console.log("API BASE URL:", process.env.VUE_APP_API_BASE_URL); 