import { createRouter, createWebHistory } from 'vue-router'
// import HomePage from '../views/HomePage.vue'
import ChatWindow from '../views/Chat.vue'
import UserManagement from '../views/UserManagement.vue'

const routes = [
  // {
  //   path: '/',
  //   name: 'HomePage',
  //   component: HomePage
  // },
  {
    path: '/',
    name: 'AmbuMenu',
    component: ()=>import('../views/AmbuMenu.vue')
  },
  {
    path:'/AmbuStart',
    name:'AmbuStart',
    component:()=>import('../views/AmbuStart.vue')
  },
  {
    path:'/AmbuInfo',
    name:'AmbuInfo',
    component:()=>import('../views/AmbuPatientInfo.vue')
  },
  {
    path: '/chat',
    name: 'ChatWindow',
    component: ChatWindow
  },
  {
    path: '/users',
    name: 'Users',
    component: UserManagement
  },
  {
    path:'/test',
    name:'Test',
    component:()=>import('../views/test.vue')
  },

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
