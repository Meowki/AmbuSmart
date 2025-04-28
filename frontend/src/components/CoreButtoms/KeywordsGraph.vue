<template>
  <el-button
    class="uniform-button"
    type="primary"
    @click="dialogVisible = true"
  >
    关键词知识图谱
  </el-button>

  <el-dialog
    v-model="dialogVisible"
    title="关键词知识图谱"
    width="70%"
  >
    <div class="dialog-header">
      <span>🗣️ 聊天关键词生成</span>
      <div>
        <el-button
          type="primary"
          size="small"
          :loading="loading"
          :disabled="loading"
          @click="fetchChatKeywords"
        >
          {{ loading ? '生成中...' : finalData ? '重新生成' : '生成图谱' }}
        </el-button>

        <el-button
          v-if="loading"
          type="danger"
          size="small"
          plain
          @click="cancelChatKeywords"
        >
          取消
        </el-button>
      </div>
    </div>

    <div class="dialog-body">
      <div v-if="finalData">
        <KnowledgeGraph :graphData="finalData" />
      </div>
      <div v-else class="empty-tip">
        <el-empty description="暂无数据，请点击生成" />
      </div>
    </div>
  </el-dialog>
</template>

<script setup>
import { ref, computed } from 'vue'
import api from '@/services/api'
import { useStore } from 'vuex'
import { ElMessage } from 'element-plus'
import KnowledgeGraph from '@/components/utils/KnowledgeGraph.vue'

// Vuex 取 operationId
const store = useStore()
const operationIdFromStore = computed(() => store.state.operation_id || '20250')

// UI 状态
const dialogVisible = ref(false)
const loading = ref(false)
const finalData = ref(null)
const abortControllerRef = ref(null)

/**
 * 点击“生成图谱” 或 “重新生成”:
 * 1. 通过流式文本解析方式获取关键词对象数组 [{name,value}...]
 * 2. 循环 /knowledge/schema?entity=xx
 * 3. 合并 => finalData
 */
async function fetchChatKeywords() {
  loading.value = true
  finalData.value = null

  abortControllerRef.value = new AbortController()
  const signal = abortControllerRef.value.signal

  try {
    // 1) 发起关键词提取(流式文本)
    const response = await api.post(
      '/chat/chat_keyword_extraction',
      {
        operation_id: operationIdFromStore.value,
        message: '请从该急救操作的对话中提取关键词，用于知识图谱',
        prompt_type: 'chat_keyword_extraction'
      },
      {
        responseType: 'text',
        signal
      }
    )

    // 2) 逐行解析
    let raw = ''
    const lines = response.data.split('\n')
    for (const line of lines) {
      if (signal.aborted) return
      if (line.startsWith('data:')) {
        const payload = line.replace(/^data:\s*/, '').trim()
        try {
          // 后端 typically: { response: '局部json字符串' }
          const parsed = JSON.parse(payload)
          if (parsed.response) {
            raw += parsed.response
          }
        } catch {
          console.warn('[关键词图谱] 跳过无法解析的数据:', payload)
        }
      }
    }

    if (signal.aborted) return

    // 3) 从 raw 中提取 JSON数组  => [{ name:'腹痛', value:9 }, ...]
    const jsonMatch = raw.match(/\[.*\]/s)
    if (!jsonMatch) {
      ElMessage.warning('关键词列表为空')
      return
    }
    const keywordsArr = JSON.parse(jsonMatch[0])
    if (!Array.isArray(keywordsArr) || !keywordsArr.length) {
      ElMessage.warning('关键词列表为空')
      return
    }

    ElMessage.success(`已提取关键词${keywordsArr.length}个，开始生成知识图谱...`)
     console.log('[关键词图谱] 收到关键词:', keywordsArr);

    // 4) 循环 /knowledge/schema 获取图谱
      const maxValidKeywords = 3;
let validCount = 0;
const subGraphs = {};

for (let i = 0; i < keywordsArr.length || validCount < maxValidKeywords; i++) {
  if (signal.aborted) return;

  const kwItem = keywordsArr[i];
      const kw = kwItem.name || ''; // name 字段
      if (!kw){
        console.warn('[关键词图谱] 跳过空关键词', kwItem);
        continue;
      } 

      console.log(`[关键词图谱] [${i+1}/${keywordsArr.length}] 查询: ${kw}`);

  try {
    // 请求 /knowledge/schema?entity=kw
    const res = await api.get('/knowledge/schema', {
      params: { entity: kw }
    });
    // console.log(`[关键词图谱] ${kw} => status: ${res.status}`);
    console.log(`[关键词图谱] ${kw} => data:`, res.data);
    
    // 判断返回数据是否有效（非空对象）
    if (res.data && Object.keys(res.data).length > 0) {
      subGraphs[kw] = res.data;
      validCount++;
    } else {
      console.log(`[关键词图谱] ${kw} 返回空数据，跳过`);
    }
  } catch (err) {
    console.error(`[关键词图谱] 请求关键词 ${kw} 失败:`, err);
    if (err.response) {
      console.log('[关键词图谱] 后端错误信息:', err.response.data);
    }
  }
}


    // 5) 合并 => finalData
    finalData.value = mergeGraphs(subGraphs)
    
    ElMessage.success('知识图谱已生成')
  } catch (err) {
    if (err.name === 'CanceledError') {
      ElMessage.warning('生成已取消')
    } else {
      console.error('[关键词图谱] 请求失败:', err)
      ElMessage.error('生成失败，请稍后重试')
    }
  } finally {
    loading.value = false
    abortControllerRef.value = null
  }
}

/**
 * 取消生成
 */
function cancelChatKeywords() {
  if (abortControllerRef.value) {
    abortControllerRef.value.abort()
    finalData.value = null
    loading.value = false

    api
      .post(`/chat/abort/${operationIdFromStore.value}_chat_keyword_extraction`)
      .catch(() => {})

    ElMessage.warning('已取消生成')
  }
}


function mergeGraphs(subGraphs) {
  console.log("[mergeGraphs] 收到 subGraphs:", subGraphs);

  const merged = { "中心词": {} };

  // 限制每个关键词的 relation 数量
  const maxRelationsPerKeyword = 30;
  // 限制每个 relation 下的尾实体数量
  const maxTailEntities = 20;

  for (const [kw, data] of Object.entries(subGraphs)) {
    const realKey = Object.keys(data)[0];
    if (!realKey || !data[realKey]) continue;

    // 1) 获取该关键词的所有 relation
    const allRelations = Object.keys(data[realKey]);
    // 2) 截取前 maxRelationsPerKeyword 条 relation
    const limitedRelations = allRelations.slice(0, maxRelationsPerKeyword);

    for (const relation of limitedRelations) {
      if (!merged["中心词"][relation]) {
        merged["中心词"][relation] = [];
      }
      // 原始数组  e.g. [ ["尾实体", "ID"], ... ]
      const originalArray = data[realKey][relation] || [];
      // 3) 截取前 maxTailEntities
      const truncatedArr = originalArray.slice(0, maxTailEntities);

      merged["中心词"][relation].push(...truncatedArr);
    }
  }

  console.log("[mergeGraphs] 最终 merged:", JSON.stringify(merged, null, 2));
  return merged;
}


</script>

<style scoped>
.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.dialog-body {
  min-height: 300px; 
}

.empty-tip {
  margin-top: 20px;
}

.uniform-button {
  width: 100%;
  min-height: 40px;
  font-size: 14px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: bold;
  font-size: 16px;
  margin-bottom: 8px;
}
</style>
