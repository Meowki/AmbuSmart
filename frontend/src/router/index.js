import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '../components/HomePage.vue'
import ChatWindow from '../components/Chat.vue'
import UserManagement from '../components/UserManagement.vue'

const routes = [
  {
    path: '/',
    name: 'HomePage',
    component: HomePage
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
    component:()=>import('../components/test.vue')
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
