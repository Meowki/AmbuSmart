<template>
  <el-card class="summary-card" shadow="hover">
    <div class="card-header">
      <span>🗣️ 聊天关键词词云</span>
      <div>
        <el-button
          type="primary"
          size="small"
          :loading="loading"
          :disabled="loading"
          @click="fetchChatKeywords"
        >
          {{
            loading ? "生成中..." : keywords.length ? "重新生成" : "生成词云"
          }}
        </el-button>
        <el-button
          v-if="loading"
          type="danger"
          size="small"
          plain
          @click="cancelChatKeywords"
        >
          取消生成
        </el-button>
      </div>
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
import { ref, computed, onMounted } from "vue";
import api from "@/services/api";
import { useStore } from "vuex";
import { ElMessage } from 'element-plus';
import WordCloudChart from "./WordCloudChart.vue";

const store = useStore();
const operationIdFromStore = computed(
  () => store.state.operation_id || "20250"
);

const loading = ref(false);
const keywords = ref([]);
onMounted(() => {
  fetchChatKeywords();
});

const abortControllerRef = ref(null);

const cancelChatKeywords = () => {
  if (abortControllerRef.value) {
    abortControllerRef.value.abort();
    keywords.value = [];
    loading.value = false;

    // 若使用统一 abort 接口
    api
      .post(`/chat/abort/${operationIdFromStore.value}_chat_keyword_extraction`)
      .catch(console.error);

    // ElMessage.warning("词云生成已取消");
  }
};

const fetchChatKeywords = async () => {
  loading.value = true;
  keywords.value = [];

  abortControllerRef.value = new AbortController();
  const signal = abortControllerRef.value.signal;

  try {
    const response = await api.post(
      "/chat/chat_keyword_extraction",
      {
        operation_id: operationIdFromStore.value,
        message:
          "请从该急救操作的完整对话中提取关键词及其重要程度，用于生成词云图",
        prompt_type: "chat_keyword_extraction",
      },
      {
        responseType: "text",
        signal, 
      }
    );

    let raw = "";
    const lines = response.data.split("\n");
    for (const line of lines) {
      if (signal.aborted) return;
      if (line.startsWith("data:")) {
        const payload = line.replace(/^data:\s*/, "").trim();
        try {
          const parsed = JSON.parse(payload);
          if (parsed.response) raw += parsed.response;
        } catch {
          console.warn("[词云AI] 跳过解析失败数据:", payload);
        }
      }
    }

    if (signal.aborted) return;

    const jsonMatch = raw.match(/\[.*\]/s);
    if (jsonMatch) {
      const result = JSON.parse(jsonMatch[0]);
      if (Array.isArray(result)) {
        keywords.value = result;
      }
    }

    if (!keywords.value.length) {
      console.warn("[词云AI] 返回关键词为空");
    } else {
      ElMessage.success("词云生成完毕");
    }
  } catch (err) {
    if (err.name === "CanceledError") {
      ElMessage.warning("词云生成已取消");
    } else {
      console.error("[词云AI] 请求失败:", err);
      ElMessage.error("生成失败，请稍后重试");
    }
  } finally {
    loading.value = false;
    abortControllerRef.value = null;
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
