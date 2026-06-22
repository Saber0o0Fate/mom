<template>
  <div class="app-container code-rule-page">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="规则编码" prop="ruleCode">
        <el-input
          v-model="queryParams.ruleCode"
          placeholder="规则编码"
          clearable
          style="width: 220px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item v-if="advancedSearch" label="规则名称" prop="ruleName">
        <el-input
          v-model="queryParams.ruleName"
          placeholder="规则名称"
          clearable
          style="width: 220px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item v-if="advancedSearch" label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 160px">
          <el-option v-for="dict in sys_normal_disable" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Search" @click="advancedSearch = !advancedSearch">高级查询</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['system:codeRule:add']">新建</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate" v-hasPermi="['system:codeRule:edit']">编辑</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete" v-hasPermi="['system:codeRule:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['system:codeRule:export']">导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="info" plain icon="Refresh" :disabled="single" @click="handleResetSerial" v-hasPermi="['system:codeRule:edit']">刷新缓存</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button plain icon="Tickets" :disabled="single" @click="handlePreview" v-hasPermi="['system:codeRule:query']">测试生成</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="codeRuleList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="序号" type="index" width="70" align="center" />
      <el-table-column label="规则编码" prop="ruleCode" min-width="150" align="center" :show-overflow-tooltip="true">
        <template #default="scope">
          <el-link type="primary" :underline="false" @click="handleUpdate(scope.row)">{{ scope.row.ruleCode }}</el-link>
        </template>
      </el-table-column>
      <el-table-column label="规则名称" prop="ruleName" min-width="140" align="center" :show-overflow-tooltip="true" />
      <el-table-column label="编码前缀" prop="prefix" width="110" align="center" />
      <el-table-column label="日期格式" prop="dateFormat" width="130" align="center">
        <template #default="scope">{{ formatOptionLabel(dateFormatOptions, scope.row.dateFormat) }}</template>
      </el-table-column>
      <el-table-column label="流水号位数" prop="serialLength" width="110" align="center" />
      <el-table-column label="分隔符" prop="separator" width="90" align="center">
        <template #default="scope">{{ scope.row.separator || '无' }}</template>
      </el-table-column>
      <el-table-column label="重置周期" prop="resetPeriod" width="110" align="center">
        <template #default="scope">{{ formatOptionLabel(resetPeriodOptions, scope.row.resetPeriod) }}</template>
      </el-table-column>
      <el-table-column label="当前序号" prop="currentSerial" width="110" align="center" />
      <el-table-column label="最后生成时间" prop="lastGenerateTime" width="170" align="center">
        <template #default="scope">{{ parseTime(scope.row.lastGenerateTime) }}</template>
      </el-table-column>
      <el-table-column label="状态" prop="status" width="90" align="center">
        <template #default="scope"><dict-tag :options="sys_normal_disable" :value="scope.row.status" /></template>
      </el-table-column>
      <el-table-column label="备注" prop="remark" min-width="160" align="center" :show-overflow-tooltip="true" />
      <el-table-column label="创建" prop="createBy" width="100" align="center" />
      <el-table-column label="操作" align="center" width="230" fixed="right" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handlePreview(scope.row)" v-hasPermi="['system:codeRule:query']">测试</el-button>
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:codeRule:edit']">编辑</el-button>
          <el-button link type="warning" icon="Refresh" @click="handleResetSerial(scope.row)" v-hasPermi="['system:codeRule:edit']">重置</el-button>
          <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['system:codeRule:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <el-dialog :title="title" v-model="open" width="800px" append-to-body>
      <el-form ref="codeRuleRef" :model="form" :rules="rules" label-width="100px">
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="规则编码" prop="ruleCode">
              <el-input v-model="form.ruleCode" placeholder="请输入规则编码" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="规则名称" prop="ruleName">
              <el-input v-model="form.ruleName" placeholder="请输入规则名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="编码前缀" prop="prefix">
              <el-input v-model="form.prefix" placeholder="请输入编码前缀" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="日期格式" prop="dateFormat">
              <el-select v-model="form.dateFormat" placeholder="请选择日期格式" clearable>
                <el-option v-for="item in dateFormatOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="流水号位数" prop="serialLength">
              <el-input-number v-model="form.serialLength" :min="1" :max="12" controls-position="right" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="分隔符" prop="separator">
              <el-input v-model="form.separator" placeholder="如：- 或 _" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="重置周期" prop="resetPeriod">
              <el-select v-model="form.resetPeriod" placeholder="请选择重置周期">
                <el-option v-for="item in resetPeriodOptions" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="启用状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in sys_normal_disable" :key="dict.value" :value="dict.value">{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注信息" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="CodeRule">
import { listCodeRule, getCodeRule, delCodeRule, addCodeRule, updateCodeRule, resetCodeRule, previewCode } from '@/api/system/codeRule'

const { proxy } = getCurrentInstance()
const { sys_normal_disable } = proxy.useDict('sys_normal_disable')

const codeRuleList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const advancedSearch = ref(false)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref('')

const dateFormatOptions = [
  { label: '无日期', value: 'NONE' },
  { label: 'YYYY', value: 'yyyy' },
  { label: 'YYYYMM', value: 'yyyyMM' },
  { label: 'YYYYMMDD', value: 'yyyyMMdd' },
  { label: 'YYYYMMDDHHmmss', value: 'yyyyMMddHHmmss' }
]

const resetPeriodOptions = [
  { label: '不重置', value: 'NONE' },
  { label: '每日重置', value: 'DAILY' },
  { label: '每月重置', value: 'MONTHLY' },
  { label: '每年重置', value: 'YEARLY' }
]

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    ruleCode: undefined,
    ruleName: undefined,
    status: undefined
  },
  rules: {
    ruleCode: [{ required: true, message: '规则编码不能为空', trigger: 'blur' }],
    ruleName: [{ required: true, message: '规则名称不能为空', trigger: 'blur' }],
    serialLength: [{ required: true, message: '流水号位数不能为空', trigger: 'change' }],
    resetPeriod: [{ required: true, message: '重置周期不能为空', trigger: 'change' }]
  }
})

const { queryParams, form, rules } = toRefs(data)

function getList() {
  loading.value = true
  listCodeRule(queryParams.value).then(response => {
    codeRuleList.value = response.rows
    total.value = response.total
    loading.value = false
  })
}

function cancel() {
  open.value = false
  reset()
}

function reset() {
  form.value = {
    ruleId: undefined,
    ruleCode: undefined,
    ruleName: undefined,
    prefix: undefined,
    dateFormat: 'yyyyMMdd',
    serialLength: 4,
    separator: '-',
    resetPeriod: 'DAILY',
    currentSerial: 0,
    status: '0',
    remark: undefined
  }
  proxy.resetForm('codeRuleRef')
}

function handleQuery() {
  queryParams.value.pageNum = 1
  getList()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  handleQuery()
}

function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.ruleId)
  single.value = selection.length !== 1
  multiple.value = !selection.length
}

function handleAdd() {
  reset()
  open.value = true
  title.value = '新增规则'
}

function handleUpdate(row) {
  reset()
  const ruleId = row?.ruleId || ids.value[0]
  getCodeRule(ruleId).then(response => {
    form.value = response.data
    open.value = true
    title.value = '修改规则'
  })
}

function submitForm() {
  proxy.$refs.codeRuleRef.validate(valid => {
    if (!valid) return
    const save = form.value.ruleId ? updateCodeRule : addCodeRule
    save(form.value).then(() => {
      proxy.$modal.msgSuccess('保存成功')
      open.value = false
      getList()
    })
  })
}

function handleDelete(row) {
  const ruleIds = row?.ruleId || ids.value
  proxy.$modal.confirm('确认删除选中的编码规则吗？').then(() => delCodeRule(ruleIds)).then(() => {
    getList()
    proxy.$modal.msgSuccess('删除成功')
  }).catch(() => {})
}

function handleResetSerial(row) {
  const ruleId = row?.ruleId || ids.value[0]
  proxy.$modal.confirm('确认将当前序号重置为0吗？').then(() => resetCodeRule(ruleId)).then(() => {
    getList()
    proxy.$modal.msgSuccess('重置成功')
  }).catch(() => {})
}

function handlePreview(row) {
  const ruleId = row?.ruleId || ids.value[0]
  previewCode(ruleId).then(response => {
    proxy.$modal.alert(response.data, '测试生成结果')
  })
}

function handleExport() {
  proxy.download('system/codeRule/export', { ...queryParams.value }, `code_rule_${new Date().getTime()}.xlsx`)
}

function formatOptionLabel(options, value) {
  return options.find(item => item.value === value)?.label || value || ''
}

getList()
</script>

<style scoped>
.code-rule-page :deep(.el-dialog__body) {
  padding-bottom: 8px;
}

.code-rule-page :deep(.el-select) {
  width: 100%;
}
</style>
