<template>
  <div>
    <!-- 保留搜索框，让用户可以自己查 -->
    <div class="search-area">
      <el-input
        v-model="keyword"
        placeholder="请输入关键词..."
        class="search-input"
        clearable
        :prefix-icon="Search"
        @keyup.enter="fetchGraph"
      />
      <el-button
        type="primary"
        :icon="Search"
        class="search-btn"
        @click="fetchGraph"
      >
        搜索
      </el-button>
    </div>

    <!-- 图表区域 -->
    <div id="knowledge-graph" style="height: 500px; margin-top: 20px;"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, defineProps } from 'vue'
import { Search } from '@element-plus/icons-vue'
import api from '@/services/api'
import * as echarts from 'echarts'

// 让组件支持：
// 1. graphData: 如果传了，就渲染这份数据
// 2. initialKeyword: 如果外部想默认搜索“胸痛”之类，可以设
const props = defineProps({
  graphData: {
    type: Object,
    default: null
  },
  initialKeyword: {
    type: String,
    default: ''
  }
})

// 内部状态
const keyword = ref(props.initialKeyword)
const chartRef = ref(null)

// 如果外部有传 graphData，则先渲染
watch(
  () => props.graphData,
  (newVal) => {
    if (newVal) {
      // 由于 newVal 里可能没有 keyword 概念，所以不改 keyword
      renderGraph(newVal, '外部数据') 
    }
  },
  { immediate: true }
)

// 如果需要默认搜索
onMounted(() => {
  // 如果 initialKeyword 不为空 & 未传外部 graphData 时，自动请求
  if (props.initialKeyword && !props.graphData) {
    fetchGraph()
  }
})

async function fetchGraph() {
  if (!keyword.value) return
  try {
    const resp = await api.get('/knowledge/schema', {
      params: { entity: keyword.value }
    })
    console.log('查询关键词=', keyword.value, '返回:', resp.data)
    renderGraph(resp.data, keyword.value)
  } catch (err) {
    console.error('请求失败:', err)
  }
}

// 根据 data 来渲染 ECharts
function renderGraph(graphData, centerName) {
  // graphData 结构: { [中心词]: { relation1: [...], ... } }
  // centerName 可能是 keyword，也可能是 '外部数据'
  // 需要找到 graphData 中的那个顶层 key
  const mainKey = centerName && graphData[centerName] ? centerName : Object.keys(graphData)[0]
  if (!graphData[mainKey]) {
    console.warn('graphData 不包含 mainKey:', mainKey)
    return
  }

  const nodes = []
  const links = []
  const nodeMap = {}
  const linkSet = new Set()

  function addNode(name, size, category) {
    if (!nodeMap[name]) {
      nodeMap[name] = {
        id: name,
        name,
        symbolSize: size,
        category
      }
      nodes.push(nodeMap[name])
    }
  }

  function addLink(source, target) {
    const key = `${source}->${target}`
    if (!linkSet.has(key)) {
      linkSet.add(key)
      links.push({ source, target })
    }
  }

  // 中心节点
  addNode(mainKey, 60, 0)

  let categoryIndex = 1
  const categorySet = new Set()

  // 遍历 graphData[mainKey]
  for (const relation in graphData[mainKey]) {
    categorySet.add(relation)
    addNode(relation, 50, categoryIndex)
    addLink(mainKey, relation)

    graphData[mainKey][relation].forEach(([tailEntity]) => {
      addNode(tailEntity, 35, categoryIndex)
      addLink(relation, tailEntity)
    })

    categoryIndex++
  }

  const categories = [{ name: '中心' }, ...Array.from(categorySet).map(name => ({ name }))]

  const chartDom = document.getElementById('knowledge-graph')
  if (!chartDom) return

  if (!chartRef.value) {
    chartRef.value = echarts.init(chartDom)
  }

  const option = {
    tooltip: {},
    legend: [{ data: categories.map(c => c.name) }],
    series: [
      {
        type: 'graph',
        layout: 'force',
        symbolSize: 45,
        roam: true,
        draggable: true,
        categories,
        label: { show: true },
        force: { repulsion: 500 },
        data: nodes,
        links,
        lineStyle: { width: 2, curveness: 0.2 },
        emphasis: { focus: 'adjacency' }
      }
    ]
  }

  chartRef.value.setOption(option)
}
</script>

<style scoped>
.search-area {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
}
.search-input {
  width: 300px;
}
#knowledge-graph {
  border: 1px solid #ddd;
  border-radius: 8px;
}
</style>
