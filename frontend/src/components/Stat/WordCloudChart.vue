<template>
  <div ref="chartRef" style="width: 100%; height: 300px"></div>
</template>

<script setup>
import { onMounted, onUnmounted, watch, ref, defineProps } from "vue";
import * as echarts from "echarts";
import "echarts-wordcloud";

const props = defineProps({
  keywords: Array, // [{ name: '心梗', value: 12 }, { name: '胸痛', value: 8 }]
});

const chartRef = ref(null);
let chartInstance = null;

const initChart = () => {
  if (!chartRef.value) return;
  chartInstance = echarts.init(chartRef.value);
  renderChart();
};

const renderChart = () => {
  if (!chartInstance || !props.keywords) return;
  chartInstance.setOption({
    tooltip: {},
    series: [
      {
        type: "wordCloud",
        gridSize: 2,
        sizeRange: [16, 60],
        rotationRange: [-45, 0, 45],
        width: "100%",
        height: "100%",
        drawOutOfBound: false,
        textStyle: {
          fontFamily: "Helvetica, Arial, sans-serif",
          fontWeight: "bold",
          color: () => {
            const colors = [
              "#5b8ff9",
              "#f6bd16",
              "#5ad8a6",
              "#ff6f91",
              "#6f42c1",
            ];
            return colors[Math.floor(Math.random() * colors.length)];
          },
        },
        emphasis: {
          textStyle: {
            shadowBlur: 8,
            shadowColor: "#333",
            color: "#f00",
          },
        },
        data: props.keywords,
      },
    ],
  });
};

watch(
  () => props.keywords,
  () => {
    renderChart();
  }
);

onMounted(() => {
  initChart();
  window.addEventListener("resize", resizeChart);
});

onUnmounted(() => {
  if (chartInstance) chartInstance.dispose();
  window.removeEventListener("resize", resizeChart);
});

const resizeChart = () => {
  if (chartInstance) chartInstance.resize();
};
</script>

<style scoped>
div {
  padding: 10px;
}
</style>
