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
      width="500px"
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
import { ref, onMounted } from 'vue';
import api from "@/services/api";
import * as echarts from 'echarts';
import { Search } from '@element-plus/icons-vue'


// 状态定义
const keyword = ref('胸痛');  

const fetchGraph = async () => {
  try {
    const response = await api.get('/knowledge/schema', {
      params: { entity: keyword.value }
    });
    const graphData = response.data;
    console.log("返回数据:", graphData);
    renderGraph(graphData);
  } catch (error) {
    console.error("请求失败:", error);
  }
};

const renderGraph = (graphData) => {
  const nodes = [];
  const links = [];

  const nodeMap = {};    
  const linkSet = new Set(); 
  
  function addNode(name, size, category) {
    if (!nodeMap[name]) {
      nodeMap[name] = {
        id: name,        
        name,
        symbolSize: size,
        category
      };
      nodes.push(nodeMap[name]);
    }
  }

  function addLink(source, target) {
    const key = `${source}->${target}`;
    if (!linkSet.has(key)) {
      linkSet.add(key);
      links.push({ source, target });
    }
  }

  const center = keyword.value;
  // 创建中心节点
  addNode(center, 60, 0);

  let categorySet = new Set();
  let categoryIndex = 1;

  // 生成节点和连线
  for (let relation in graphData[center]) {
    categorySet.add(relation);
    // relation节点
    addNode(relation, 50, categoryIndex);

    // 中心节点 -> relation
    addLink(center, relation);

    // 尾实体
    graphData[center][relation].forEach(([tailEntity]) => {
      // 若 tailEntity 重复，自动跳过
      addNode(tailEntity, 35, categoryIndex);
      addLink(relation, tailEntity);
    });

    categoryIndex++;
  }

  // categories
  const categories = [{ name: '中心' }, ...Array.from(categorySet).map(name => ({ name }))];

  const chartDom = document.getElementById('knowledge-graph');
  const myChart = echarts.init(chartDom);
  const option = {
    tooltip: {},
    legend: [{ data: categories.map(c => c.name) }],
    series: [{
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
    }]
  };

  myChart.setOption(option);
};


onMounted(fetchGraph);
</script>

<style scoped>
#knowledge-graph {
  border: 1px solid #ddd;
  border-radius: 8px;
}

.search-area {
  display: flex;
  align-items: center;
  gap: 8px; 
  margin-bottom: 20px;
}

.search-input {
  width: 300px; 
}



.graph-container {
  height: 500px;
  border: 1px solid #ddd;
  border-radius: 8px;
}
</style>

