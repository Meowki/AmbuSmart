<!-- src/components/WrappedAntdButton.vue -->
<script setup>
import { defineProps, onMounted, onBeforeUnmount, watch } from 'vue'
import { createRoot } from 'react-dom/client'
import { bridgeReactToVue } from '@teamsupervue/react-vue-bridge'
import { Button } from 'antd'
import { SmileOutlined } from '@ant-design/icons'

const ReactButton = bridgeReactToVue(Button)

const props = defineProps({
  type: String,
  onClick: Function
})

let root = null
const container = document.createElement('div')

onMounted(() => {
  root = createRoot(container)
  renderReactComponent()
})

onBeforeUnmount(() => {
  root.unmount()
})

watch(props, () => {
  renderReactComponent()
})

const renderReactComponent = () => {
  root.render(
    <ReactButton
      type={props.type}
      onClick={props.onClick}
      icon={<SmileOutlined />}
    >
      React Antd Button
    </ReactButton>
  )
}
</script>

<template>
  <div ref="reactContainer"></div>
</template>