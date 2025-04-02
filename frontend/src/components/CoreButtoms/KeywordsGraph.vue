<template>
  <!-- 外层按钮：打开Dialog -->
  <el-button
    class="uniform-button"
    type="primary"
    @click="dialogVisible = true"
  >
    关键词知识图谱
  </el-button>

  <!-- 弹窗 -->
  <el-dialog
    v-model="dialogVisible"
    title="关键词知识图谱"
    width="70%"
    :close-on-click-modal="false"
  >
    <!-- 弹窗内的标题 & 按钮区 -->
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

    <!-- 弹窗内主体区域：如果有数据，就展示 KnowledgeGraph，否则显示空提示 -->
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
    const subGraphs = {}
      for (let i = 0; i < keywordsArr.length; i++) {
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

        console.log(`[关键词图谱] ${kw} => status: ${res.status}`);
        console.log(`[关键词图谱] ${kw} => data:`, res.data);

        subGraphs[kw] = res.data;
      } catch (err) {
        console.error(`[关键词图谱] 请求关键词 ${kw} 失败:`, err);
        // 如果后端返回详细报错，可以查看 err.response.data
        if (err.response) {
          console.log('[关键词图谱] 后端错误信息:', err.response.data);
        }
        throw err; // 重新抛出以让后续 catch 捕获
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

  const merged = { "多关键词": {} };

  for (const [kw, data] of Object.entries(subGraphs)) {
    console.log(`[mergeGraphs] 处理关键词: ${kw}`, data);

    // realKey 通常就是 kw (若后端返回 { [kw]: {...} })
    // 但也可能是别的(若后端返回 { \"静脉补液\": {...} })
    const realKey = Object.keys(data)[0];
    if (!realKey) {
      console.log(`[mergeGraphs] 跳过关键词 ${kw}, 因为 data 没有任何 key`);
      continue;
    }
    if (!data[realKey]) {
      console.log(`[mergeGraphs] 跳过关键词 ${kw}, data[${realKey}] 不存在`);
      continue;
    }

    console.log(`[mergeGraphs] realKey = ${realKey}, data[realKey] = `, data[realKey]);

    // 遍历 realKey 下的所有 relation, 例如 \"病因\"/\"症状\"
    // data[realKey][relation] => [ [\"尾实体\", \"ID\"], ...]
    for (const relation in data[realKey]) {
      // 如果 merged['多关键词'] 里还没有这个 relation，就先建空数组
      if (!merged["多关键词"][relation]) {
        merged["多关键词"][relation] = [];
      }

      console.log(`[mergeGraphs] relation=${relation}, data[realKey][relation]=`, data[realKey][relation]);
      // 合并到 merged["多关键词"][relation]
      merged["多关键词"][relation].push(...data[realKey][relation]);
    }
  }

  // 最后打印合并结果
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
