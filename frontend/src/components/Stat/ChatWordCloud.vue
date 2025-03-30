<template>
    <el-card class="summary-card" shadow="hover">
      <div class="card-header">
        <span>🗣️ 聊天关键词词云</span>
        <el-button
          type="primary"
          size="small"
          :loading="loading"
          :disabled="loading"
          @click="fetchChatKeywords"
        >
          {{ loading ? '生成中...' : '重新生成' }}
        </el-button>
      </div>
  
      <div v-if="keywords.length">
        <WordCloudChart :keywords="keywords" />
      </div>
      <div v-else class="empty-tip">
        <el-empty description="暂无关键词，请点击生成" />
      </div>
    </el-card>
  </template>
  
  <script setup>
  import { ref, computed,onMounted } from 'vue';
  import api from '@/services/api';
  import { useStore } from 'vuex';
  import WordCloudChart from './WordCloudChart.vue';
  
  const store = useStore();
  const operationIdFromStore = computed(() => store.state.operation_id || '20250');
  
  const loading = ref(false);
  const keywords = ref([]);
  onMounted(() => {
    fetchChatKeywords();
  })
  
  const fetchChatKeywords = async () => {
    loading.value = true;
    keywords.value = [];
  
    try {
      const response = await api.post(
        '/chat/chat_keyword_extraction',
        {
          operation_id: operationIdFromStore.value,
          message: '请从该急救操作的完整对话中提取关键词及其重要程度，用于生成词云图',
          prompt_type: 'chat_keyword_extraction'
        },
        { responseType: 'text' }
      );
  
      let raw = '';
      const lines = response.data.split('\n');
      for (const line of lines) {
        if (line.startsWith('data:')) {
          const payload = line.replace(/^data:\s*/, '').trim();
          try {
            const parsed = JSON.parse(payload);
            if (parsed.response) raw += parsed.response;
          } catch {
            console.warn('[词云AI] 跳过解析失败数据:', payload);
          }
        }
      }
  
      const jsonMatch = raw.match(/\[.*\]/s);
      if (jsonMatch) {
        const result = JSON.parse(jsonMatch[0]);
        if (Array.isArray(result)) {
          keywords.value = result;
        }
      }
  
      if (!keywords.value.length) {
        console.warn('[词云AI] 返回关键词为空');
      }
    } catch (err) {
      console.error('[词云AI] 请求失败:', err);
    } finally {
      loading.value = false;
    }
  };
  </script>
  
  <style scoped>
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 8px;
  }
  .empty-tip {
    margin-top: 20px;
  }
  </style>
  