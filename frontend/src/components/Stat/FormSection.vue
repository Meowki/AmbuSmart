<template>
  <el-card class="form-card" shadow="hover">
        <span style="font-weight: bold; font-size: 16px; margin-bottom: 8px;">📄 急救记录完善</span>
        <el-form :model="form" label-width="120px">
          <!-- 分组1：主诉与初步诊断 -->
          <el-divider content-position="left">
            <el-icon><EditPen /></el-icon>
            主诉与初步诊断
          </el-divider>

          <el-form-item label="患者主诉">
            <el-input
              type="textarea"
              v-model="form.chief_complaint"
              rows="3"
              placeholder="填写患者主诉..."
            />
          </el-form-item>

          <el-form-item label="初步诊断">
            <el-input
              type="textarea"
              v-model="form.initial_diagnosis"
              rows="3"
              placeholder="填写初步诊断..."
            />
          </el-form-item>

          <!-- 分组2：急救过程与用药 -->
          <el-divider content-position="left">
            <el-icon><Suitcase /></el-icon>
            急救过程与用药
          </el-divider>

          <el-form-item label="急救过程">
            <el-input
              type="textarea"
              v-model="form.procedures"
              rows="4"
              placeholder="描述急救过程..."
            />
          </el-form-item>

          <el-form-item label="药物使用">
            <el-input
              type="textarea"
              v-model="form.medicine"
              rows="3"
              placeholder="记录药物使用情况..."
            />
          </el-form-item>

          <el-form-item label="急救结果">
            <el-input
              type="textarea"
              v-model="form.outcome"
              rows="3"
              placeholder="填写急救结果..."
            />
          </el-form-item>

          <!-- 分组3：院内交接 -->
          <el-divider content-position="left">
            <el-icon><User /></el-icon>
            院内交接
          </el-divider>

          <el-form-item label="院内接收者">
            <el-select
              v-model="form.recipient"
              filterable
              placeholder="请选择院内接收者"
              @focus="fetchRecipients"
              style="max-width: 300px"
            >
              <el-option
                v-for="person in recipientList"
                :key="person.id"
                :label="person.name"
                :value="person.name"
              >
                <div
                  style="
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                  "
                >
                  {{ person.name }}
                </div>
              </el-option>
            </el-select>
          </el-form-item>

          <!-- 提交区域 -->
          <el-form-item>
            <div style="display: flex; gap: 12px">
              <el-button type="primary" @click="handleSubmit">
                <el-icon><CircleCheck /></el-icon> 提交记录
              </el-button>
              <el-button @click="handleReset">
                <el-icon><Refresh /></el-icon> 恢复
              </el-button>
              <el-button
                type="warning"
                :loading="isOptimizing"
                :disabled="isOptimizing"
                @click="handleAIOptimize"
              >
              <el-icon><MagicStick /></el-icon>
              {{ isOptimizing ? '生成中...' : 'AI 优化' }}
              </el-button>

              <!-- 新增取消按钮（仅在生成中显示） -->
              <el-button type="danger" @click="cancelAIOptimize" plain
              v-if="isOptimizing">
                <el-icon><Close /></el-icon>
                取消生成
              </el-button>
            </div>
          </el-form-item>
        </el-form>
      </el-card>
</template>


<script setup>
import { computed, ref, onMounted } from "vue";
import api from "@/services/api";
import { useStore } from "vuex";
import { ElMessage } from "element-plus";

import {
  EditPen,
  Suitcase,
  User,
  MagicStick,
  CircleCheck,
  Refresh,
  Close,
} from "@element-plus/icons-vue";

const store = useStore();

const isOptimizing = ref(false); // 控制按钮 loading

// 表单数据增加 chief_complaint 字段
const form = ref({
  chief_complaint: "",
  initial_diagnosis: "",
  procedures: "",
  medicine: "",
  outcome: "",
  recipient: "",
});

const operationIdFromStore = computed(
  () => store.state.operation_id || "20250"
);

const fetchOperationData = async () => {
  try {
    const response = await api.get(
      `/operation_histories/operationId/${operationIdFromStore.value}`
    );
    const data = response.data;

    // 根据后端字段结构对应填入
    form.value.chief_complaint = data.chief_complaint || "";
    form.value.initial_diagnosis = data.initial_diagnosis || "";
    form.value.procedures = data.procedures || "";
    form.value.medicine = data.medicine || "";
    form.value.outcome = data.outcome || "";
    form.value.recipient = data.recipient || "";
  } catch (error) {
    console.error("获取急救记录失败:", error);
  }
};

const handleSubmit = async () => {
  try {
    const operationHistoryData = {
      chief_complaint: form.value.chief_complaint,
      initial_diagnosis: form.value.initial_diagnosis,
      procedures: form.value.procedures,
      medicine: form.value.medicine,
      outcome: form.value.outcome,
      recipient: form.value.recipient,
    };

    // eslint-disable-next-line no-unused-vars
    const response = await api.put(
      `/operation_histories/update/${operationIdFromStore.value}`,
      operationHistoryData
    );

    ElMessage.success("急救记录已成功提交");
  } catch (error) {
    console.error("提交失败:", error);
    ElMessage.error("提交失败，请重试");
  }
};

onMounted(() => {
  fetchOperationData();
});

const aiAccumulatedText = ref("");

const abortControllerRef = ref(null);

// AI 优化按钮功能
// 如需修改后进行AI优化，请先提交再点击
const handleAIOptimize = async () => {
  isOptimizing.value = true;
  try {
    aiAccumulatedText.value = ""; // 重置

    // 创建新的 AbortController
    abortControllerRef.value = new AbortController();
    const signal = abortControllerRef.value.signal;

    const response = await api.post(
      `/chat/optimize_full_entry`,
      {
        operation_id: operationIdFromStore.value,
        message: "生成完整急救记录草稿",
        prompt_type: "optimize_full_entry",
        signal: signal,
      },
      { responseType: "text" }
    );

    // 检查是否已取消
    if (signal.aborted) {
      console.log("[AI优化] 请求已被取消");
      return;
    }

    // ✅ Axios 收到的是拼接好的字符串，直接处理
    const rawText = response.data;
    console.log("[SSE] 收到完整文本:", rawText);

    // 逐行解析 response
    const lines = rawText.split("\n");
    for (const line of lines) {
      if (signal.aborted) break; // 如果已取消，停止处理
      if (line.startsWith("data:")) {
        const raw = line.replace(/^data:\s*/, "").trim();
        try {
          const parsed = JSON.parse(raw);
          if (parsed.response) {
            aiAccumulatedText.value += parsed.response;
          }
        } catch (e) {
          console.warn("[SSE] 跳过无法解析的行:", raw);
        }
      }
    }

    if (signal.aborted) {
      console.log("[AI优化] 处理过程中被取消");
      return;
    }

    // 现在 aiAccumulatedText.value 应该是 ```json\n{...}\n``` 这样的结构
    const result = extractLastJSON(aiAccumulatedText.value);
    Object.assign(form.value, result); // ✅ 自动填表
    ElMessage.success("AI 优化内容已自动填入表单");
  } catch (e) {
    if (e.name === "CanceledError") {
      console.log("[AI优化] 请求已被用户取消");
      ElMessage.warning("AI 优化已取消");
    } else {
      console.error("[AI 优化失败]", e);
      ElMessage.error("AI 生成失败，请稍后重试");
    }
  } // 修改优化函数的 finally
finally {
  // 确保任何情况下都能解除状态
  isOptimizing.value = false
  abortControllerRef.value = null
}
};

// 取消函数强化
const cancelAIOptimize = () => {
  if (abortControllerRef.value) {
    // 发送取消信号
    abortControllerRef.value.abort()
    
    // 强制清理
    aiAccumulatedText.value = ""
    isOptimizing.value = false
    
    // 发送后端中断请求
    api.post(`/chat/abort/${operationIdFromStore.value}_optimize_full_entry`).catch(console.error)
    
    ElMessage.warning("生成已终止")
  }
}

// 工具函数：提取最后一个 JSON 对象
function extractLastJSON(text) {
  console.log("[🧪 step 0] AI 原始返回内容 ↓↓↓");
  console.log(text);

  // Step 1: 尝试提取 JSON 结构中包含目标字段的部分
  const jsonMatch = text.match(
    /{[\s\S]*?(chief_complaint|initial_diagnosis|procedures|medicine|outcome)[\s\S]*?}/
  );

  if (!jsonMatch || !jsonMatch[0]) {
    console.warn("⚠️ 未匹配到包含关键字段的 JSON 结构");
    throw new Error("未找到有效 JSON 内容");
  }

  const jsonCandidate = jsonMatch[0];
  console.log("[🧪 step 1] ✅ 匹配到 JSON 候选:", jsonCandidate);

  try {
    const parsed = JSON.parse(jsonCandidate);
    console.log("[🧪 step 2] ✅ 成功解析 JSON:", parsed);
    return parsed;
  } catch (e) {
    console.error("[🧪 step 3] ❌ JSON 解析失败:", e);
    throw new Error("匹配内容不是有效 JSON，请尝试重新生成");
  }
}

const recipientList = ref([]);

const fetchRecipients = async () => {
  try {
    const response = await api.get(`/health_personnel/dno/r1`);
    recipientList.value = response.data.map((person) => ({
      id: person.id,
      name: person.name,
    }));
  } catch (error) {
    console.error("获取院内接收者失败:", error);
  }
};

</script>

<style scoped>
.operation-form {
  max-width: 1000px;
  margin: 0 auto;
}

.form-card >>> .el-form-item {
  margin-bottom: 18px;
}

.card-header {
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 8px;
  }

.container {
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.form-card,
.table-card {
  padding: 20px;
}

</style>
