<template>
    <el-card class="summary-card" shadow="hover">
      <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; gap: 10px">
        <span>✅ 急救过程与结果一致性分析</span>
        <div>
          <el-button
            type="primary"
            size="small"
            :loading="isAnalyzing"
            :disabled="isAnalyzing"
            @click="analyzeConsistency"
          >
            {{ isAnalyzing ? '分析中...' : analysisResult ? '重新分析' : '生成分析' }}
          </el-button>
          <el-button
            type="danger"
            size="small"
            plain
            v-if="isAnalyzing"
            @click="cancelAnalysis"
          >
            取消分析
          </el-button>
        </div>
      </div>
  
      <div v-if="analysisResult">
        <div v-html="renderMarkdown(analysisResult)" class="markdown-output" />
      </div>
      <div v-else class="empty-tip">
        <el-empty description="尚未生成一致性分析结果，请点击生成" />
      </div>
    </el-card>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue';
  import api from '@/services/api';
  import { useStore } from 'vuex';
  import { ElMessage } from 'element-plus';
  import markdownit from 'markdown-it';
  
  const md = markdownit();
  const analysisResult = ref('');
  const isAnalyzing = ref(false);
  const abortControllerRef = ref(null);
  
  const store = useStore();
  const operationIdFromStore = computed(() => store.state.operation_id || '20250');
  
  const renderMarkdown = (text) => md.render(text);

  onMounted(() => {
    analyzeConsistency();
  })
  
  const analyzeConsistency = async () => {
    isAnalyzing.value = true;
    analysisResult.value = '';
    abortControllerRef.value = new AbortController();
    const signal = abortControllerRef.value.signal;
  
    try {
      const response = await api.post(
        '/chat/chat_consistency_check',
        {
          operation_id: operationIdFromStore.value,
          message: '请分析当前急救过程与最终结果之间是否存在逻辑一致性或矛盾点，简洁总结并提出优化建议。',
          prompt_type: "chat_consistency_check",
          signal
        },
        { responseType: 'text' }
      );
  
      let raw = '';
      const lines = response.data.split('\n');
      for (const line of lines) {
        if (signal.aborted) break;
        if (line.startsWith('data:')) {
          const payload = line.replace(/^data:\s*/, '').trim();
          try {
            const parsed = JSON.parse(payload);
            if (parsed.response) raw += parsed.response;
          } catch (e) {
            console.warn('[一致性分析] 跳过解析失败数据:', payload);
          }
        }
      }
  
      if (signal.aborted) return;
      analysisResult.value = raw.trim();
      if (!analysisResult.value) {
        ElMessage.warning('AI 返回为空，请检查数据或稍后重试');
      } else {
        ElMessage.success('一致性分析完成');
      }
    } catch (err) {
      if (err.name === 'CanceledError') {
        ElMessage.warning('一致性分析已取消');
      } else {
        console.error('[一致性分析] 错误:', err);
        ElMessage.error('生成失败，请稍后重试');
      }
    } finally {
      isAnalyzing.value = false;
      abortControllerRef.value = null;
    }
  };
  
  const cancelAnalysis = () => {
    if (abortControllerRef.value) {
      abortControllerRef.value.abort();
      isAnalyzing.value = false;
      analysisResult.value = '';
      api.post(`/chat/abort/${operationIdFromStore.value}_chat_consistency_check`).catch(console.error);
      ElMessage.warning('分析已终止');
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
  