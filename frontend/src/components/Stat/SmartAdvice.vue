<template>
    <el-card class="summary-card" shadow="hover">
      <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; gap: 10px">
        <span>🧠 特别关注建议</span>
        <div>
          <el-button
            type="primary"
            size="small"
            :loading="isGenerating"
            :disabled="isGenerating"
            @click="generateAttention"
          >
            {{ isGenerating ? '生成中...' : aiAttentionContent ? '重新生成' : '生成建议' }}
          </el-button>
          <el-button
            type="danger"
            size="small"
            plain
            v-if="isGenerating"
            @click="cancelGenerateAttention"
          >
            取消生成
          </el-button>
        </div>
      </div>
  
      <div v-if="aiAttentionContent">
        <div v-html="renderMarkdown(aiAttentionContent)" class="markdown-output"></div>
      </div>
      <div v-else class="empty-tip">
        <el-empty description="尚未生成 AI 建议，请点击生成" />
      </div>
    </el-card>
  </template>
  
  <script setup>
  import { ref, computed,onMounted } from 'vue';
  import api from '@/services/api';
  import { useStore } from 'vuex';
  import { ElMessage } from 'element-plus';
  import markdownit from 'markdown-it';
  
  const md = markdownit();
  const aiAttentionContent = ref('');
  const isGenerating = ref(false);
  const abortControllerRef = ref(null);
  
  const store = useStore();
  const operationIdFromStore = computed(() => store.state.operation_id || '20250');

onMounted(() => {
  generateAttention();
});
  
  const renderMarkdown = (text) => {
    return md.render(text);
  };
  
  const generateAttention = async () => {
    isGenerating.value = true;
    aiAttentionContent.value = '';
  
    abortControllerRef.value = new AbortController();
    const signal = abortControllerRef.value.signal;
  
    try {
      const response = await api.post(
        '/chat/patient_attention_suggestion',
        {
          operation_id: operationIdFromStore.value,
          message: '请基于当前急救记录与该患者历史记录，指出是否存在值得特别关注的问题',
          prompt_type: "patient_attention_suggestion",
          signal
        },
        { responseType: 'text' }
      );
  
      const lines = response.data.split('\n');
      let content = '';
  
      for (const line of lines) {
        if (signal.aborted) break;
        if (line.startsWith('data:')) {
          const raw = line.replace(/^data:\s*/, '').trim();
          try {
            const parsed = JSON.parse(raw);
            if (parsed.response) {
              content += parsed.response;
            }
          } catch (e) {
            console.warn('[AI关注] 跳过解析失败内容:', raw);
          }
        }
      }
  
      if (signal.aborted) {
        console.log('[AI关注] 已取消生成');
        return;
      }
  
      aiAttentionContent.value = content.trim();
  
      if (!aiAttentionContent.value) {
        ElMessage.warning('AI 返回为空，请检查数据或稍后重试');
      } else {
        ElMessage.success('AI 建议生成完毕');
      }
    } catch (err) {
      if (err.name === 'CanceledError') {
        ElMessage.warning('AI 建议生成已取消');
      } else {
        console.error('[AI关注] 错误:', err);
        ElMessage.error('生成失败，请稍后重试');
      }
    } finally {
      isGenerating.value = false;
      abortControllerRef.value = null;
    }
  };
  
  const cancelGenerateAttention = () => {
    if (abortControllerRef.value) {
      abortControllerRef.value.abort();
      isGenerating.value = false;
      aiAttentionContent.value = '';
      api.post(`/chat/abort/${operationIdFromStore.value}_patient_attention_suggestion`).catch(console.error);
      ElMessage.warning('生成已终止');
    }
  };
  </script>
  
  <style scoped>
  .card-header {
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 8px;
  }
  .empty-tip {
    margin-top: 20px;
  }
  .markdown-output {
    padding: 10px;
    line-height: 1.6;
  }
  </style>
  