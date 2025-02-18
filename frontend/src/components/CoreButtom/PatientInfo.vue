<template>
  <div>
    <el-button type="primary" @click="openDialog">查看患者信息</el-button>

    <!-- 患者信息弹出框 -->
    <el-dialog
      title="患者信息"
      :visible.sync="dialogVisible"
      width="80%"
      :before-close="handleClose"
    >
      <el-tabs v-model="activeTab">
        <!-- Tab 1: 患者基本信息 -->
        <el-tab-pane label="患者信息">
          <el-form :model="patientInfo" label-width="120px">
            <el-form-item label="姓名">
              <el-input v-model="patientInfo.name" disabled></el-input>
            </el-form-item>
            <el-form-item label="性别">
              <el-input v-model="patientInfo.sex" disabled></el-input>
            </el-form-item>
            <el-form-item label="身份证类型">
              <el-input v-model="patientInfo.idType" disabled></el-input>
            </el-form-item>
            <el-form-item label="电话">
              <el-input v-model="patientInfo.telno" disabled></el-input>
            </el-form-item>
            <el-form-item label="地址">
              <el-input v-model="patientInfo.address" disabled></el-input>
            </el-form-item>
            <el-form-item label="民族">
              <el-input v-model="patientInfo.ethnicity" disabled></el-input>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <!-- Tab 2: 过敏信息 -->
        <el-tab-pane label="过敏信息">
          <el-table :data="allergyInfo" style="width: 100%">
            <el-table-column label="过敏原" prop="allergy_name"></el-table-column>
            <el-table-column label="严重程度" prop="severity"></el-table-column>
            <el-table-column label="备注" prop="remark"></el-table-column>
          </el-table>
        </el-tab-pane>

        <!-- Tab 3: 既往史 -->
        <el-tab-pane label="既往史">
          <el-table :data="medicalHistories" style="width: 100%">
            <el-table-column label="病情名称" prop="condition_name"></el-table-column>
            <el-table-column label="诊断日期" prop="diagnosis_date"></el-table-column>
            <el-table-column label="备注" prop="remark"></el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>

      <!-- 关闭按钮 -->
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">关闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  data() {
    return {
      dialogVisible: false, // 控制弹出框显示
      activeTab: "1", // 默认显示的 tab
      patientInfo: {
        name: "张三",
        sex: "男",
        idType: "身份证",
        telno: "1234567890",
        address: "某地某街道",
        ethnicity: "汉族",
      },
      allergyInfo: [
        { allergy_name: "花粉", severity: "轻度", remark: "无明显症状" },
        { allergy_name: "尘螨", severity: "重度", remark: "呼吸困难" },
      ],
      medicalHistories: [
        { condition_name: "高血压", diagnosis_date: "2015-10-10", remark: "长期服药" },
        { condition_name: "糖尿病", diagnosis_date: "2018-05-20", remark: "稳定" },
      ],
    };
  },
  methods: {
    openDialog() {
      this.dialogVisible = true; // 打开 Dialog
    },
    handleClose(done) {
      done(); // 关闭 Dialog
    },
  },
};
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}
</style>
