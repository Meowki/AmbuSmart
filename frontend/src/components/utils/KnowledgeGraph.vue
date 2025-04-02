<template>
  <div>
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

    <div id="knowledge-graph" style="height: 500px; margin-top: 20px;"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch, defineProps,nextTick } from 'vue'
import { Search } from '@element-plus/icons-vue'
import api from '@/services/api'
import * as echarts from 'echarts'

// =========== PROPS & STATE ===========
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

const keyword = ref(props.initialKeyword)
const chartRef = ref(null)

// =========== WATCH LOGIC ===========
watch(
  () => props.graphData,
  (newVal) => {
    if (newVal) {
      // 自动判断：单中心还是多中心
      nextTick(() => {
        renderAutoGraph(newVal)
      })
    }
  },
  { immediate: true, deep: true } // 添加 deep: true 确保对象变化被捕获
)

// 如果 initialKeyword 不为空 && 没有外部graphData => 自动执行单中心搜索
onMounted(() => {
  if (props.initialKeyword && !props.graphData) {
       // 每次初始化前先销毁旧实例
   if (chartRef.value) {
    chartRef.value.dispose()
  }
    fetchGraph()
  }
})

// =========== API REQUEST (SINGLE CENTER) ===========
async function fetchGraph() {
  if (!keyword.value) return
  try {
    const resp = await api.get('/knowledge/schema', {
      params: { entity: keyword.value }
    })
    console.log('查询关键词=', keyword.value, '返回:', resp.data)
    // 根据顶层keys判断渲染模式
    renderAutoGraph(resp.data)
  } catch (err) {
    console.error('请求失败:', err)
  }
}

// =========== AUTO DETECTION ===========
function renderAutoGraph(data) {
  const topKeys = Object.keys(data)
  if (!topKeys.length) {
    console.warn('[renderAutoGraph] data 为空')
    return
  }

  // 如果只有一个key => 单中心
  if (topKeys.length === 1) {
    renderSingleCenterLegacy(data)
  } else {
    // 多中心 => 新增逻辑
    renderMultiCenter(data)
  }
}

/**
 * 单中心：当 data 只有一个 topKey
 */
function renderSingleCenterLegacy(graphData, centerName = '') {
  console.log('[renderSingleCenterLegacy] data:', graphData, 'centerName=', centerName)

  // 需要找到 mainKey
  const mainKey = centerName && graphData[centerName] 
    ? centerName 
    : Object.keys(graphData)[0]
  
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

  initECharts(nodes, links, categories)
}


/**
 * 多中心：当 data 有多个 topKey
 */
 function renderMultiCenter(graphData) {
  console.log('[renderMultiCenter] data:', graphData)

  const nodes = []
  const links = []
  const nodeMap = {}
  const linkSet = new Set()

  function addNode(name, size, category) {
    console.log('[addNode] called with:', name, size, category)
    if (!nodeMap[name]) {
      nodeMap[name] = { id: name, name, symbolSize: size, category }
      nodes.push(nodeMap[name])
    } 
  }

  function addLink(source, target) {
    const key = `${source}->${target}`
    if (!linkSet.has(key)) {
      linkSet.add(key)
      links.push({ source, target })
    } else {
    }
  }

  const superCenter = '中心词'
  addNode(superCenter, 80, 0)

  let categoryIndex = 1

  // 遍历每个 topKey
  const topKeys = Object.keys(graphData)

  for (const topKey of topKeys) {
    const topVal = graphData[topKey]
    if (!topVal) {
      continue
    }

    // realKey => 例如 "腹痛"
    const subKeys = Object.keys(topVal)
    if (!subKeys.length) {
      continue
    }

    const realKey = subKeys[0]
    if (!realKey || !topVal[realKey]) {
      continue
    }

    // 建立 topKey 节点 => 连接 superCenter
    addNode(topKey, 60, categoryIndex)
    addLink(superCenter, topKey)

    // 遍历 topVal[realKey], 例如 { "病因": [...], "症状": [...], ... }
    const relationObj = topVal[realKey]
    
    for (const relation in relationObj) {
      addNode(relation, 50, categoryIndex)
      addLink(topKey, relation)

      const arr = relationObj[relation]
      if (!Array.isArray(arr)) {
        continue
      }

      for (const item of arr) {
        // item like [tailEntity, ID]
        const tailEntity = item[0]
        const tailId = item[1]
        addNode(tailEntity, 35, categoryIndex)
        addLink(relation, tailEntity)
      }
    }
    categoryIndex++
  }

  const categories = [{ name: '中心词' }]
  for (let i = 1; i < categoryIndex; i++) {
    categories.push({ name: `中心${i}` })
  }

  initECharts(nodes, links, categories)
}


// =========== ECHARTS INIT ===============
function initECharts(nodes, links, categories) {
  console.log('[initECharts]')
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
  window.addEventListener('resize', () => chartRef.value?.resize())
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
