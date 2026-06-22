<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="工单" prop="workOrderId"><el-select v-model="queryParams.workOrderId" clearable filterable><el-option v-for="w in workOrderOptions" :key="w.workOrderId" :label="`${w.workOrderCode} ${w.productName || ''}`" :value="w.workOrderId" /></el-select></el-form-item>
      <el-form-item label="排产" prop="scheduleId"><el-select v-model="queryParams.scheduleId" clearable filterable><el-option v-for="s in scheduleOptions" :key="s.scheduleId" :label="s.scheduleCode" :value="s.scheduleId" /></el-select></el-form-item>
      <el-form-item label="资源" prop="resourceId"><el-select v-model="queryParams.resourceId" clearable filterable><el-option v-for="r in resourceOptions" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:report:add']">新增报工</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:report:remove']">删除</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:report:export']">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="rows" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="45" />
      <el-table-column label="工单" prop="workOrderCode" min-width="150" />
      <el-table-column label="产品" prop="productName" min-width="120" />
      <el-table-column label="排产ID" prop="scheduleId" width="90" />
      <el-table-column label="工序" min-width="130"><template #default="s">{{ s.row.operationCode }} {{ s.row.operationName }}</template></el-table-column>
      <el-table-column label="工步" min-width="150"><template #default="s">{{ s.row.stepCode }} {{ s.row.stepName }}</template></el-table-column>
      <el-table-column label="资源" prop="resourceName" min-width="120" />
      <el-table-column label="合格" prop="goodQty" width="90" />
      <el-table-column label="不良" prop="badQty" width="90" />
      <el-table-column label="报工人" prop="reportUser" width="100" />
      <el-table-column label="报工时间" prop="reportTime" width="160" />
      <el-table-column label="状态" prop="status" width="90"><template #default="s"><dict-tag :options="mom_report_status" :value="s.row.status" /></template></el-table-column>
      <el-table-column label="操作" fixed="right" width="90">
        <template #default="s"><el-button link type="primary" icon="Delete" @click="handleDelete(s.row)" v-hasPermi="['mom:report:remove']">删除</el-button></template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="新增工步报工" v-model="open" width="720px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="95px">
        <el-row>
          <el-col :span="12"><el-form-item label="工单" prop="workOrderId"><el-select v-model="form.workOrderId" filterable @change="handleWorkOrderChange"><el-option v-for="w in reportableOrders" :key="w.workOrderId" :label="`${w.workOrderCode} ${w.productName || ''}`" :value="w.workOrderId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="排产" prop="scheduleId"><el-select v-model="form.scheduleId" clearable filterable @change="handleScheduleChange"><el-option v-for="s in formScheduleOptions" :key="s.scheduleId" :label="`${s.scheduleCode} ${s.operationName || ''}`" :value="s.scheduleId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="工序" prop="operationId"><el-select v-model="form.operationId" filterable @change="handleOperationChange"><el-option v-for="o in operationOptions" :key="o.operationId" :label="`${o.operationCode} ${o.operationName}`" :value="o.operationId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="工步" prop="stepId"><el-select v-model="form.stepId" filterable><el-option v-for="s in formStepOptions" :key="s.stepId" :label="`${s.stepCode} ${s.stepName}`" :value="s.stepId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="资源" prop="resourceId"><el-select v-model="form.resourceId" clearable filterable><el-option v-for="r in resourceOptions" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="报工时间" prop="reportTime"><el-date-picker v-model="form.reportTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="合格数量" prop="goodQty"><el-input-number v-model="form.goodQty" :min="0" :precision="6" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="不良数量" prop="badQty"><el-input-number v-model="form.badQty" :min="0" :precision="6" /></el-form-item></el-col>
          <el-col :span="24"><el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { scheduleApi, reportApi } from '@/api/mom/production'
import { workOrderApi } from '@/api/mom/workorder'
import { resourceApi } from '@/api/mom/base'
const { proxy } = getCurrentInstance()
const { mom_report_status } = proxy.useDict('mom_report_status')
const rows = ref([]), workOrderOptions = ref([]), scheduleOptions = ref([]), resourceOptions = ref([]), operationOptions = ref([]), stepOptions = ref([])
const open = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), multiple = ref(true), total = ref(0)
const data = reactive({
  form: {},
  queryParams: { pageNum: 1, pageSize: 10, workOrderId: undefined, scheduleId: undefined, resourceId: undefined },
  rules: {
    workOrderId: [{ required: true, message: '工单不能为空', trigger: 'change' }],
    operationId: [{ required: true, message: '工序不能为空', trigger: 'change' }],
    stepId: [{ required: true, message: '工步不能为空', trigger: 'change' }],
    goodQty: [{ required: true, message: '合格数量不能为空', trigger: 'blur' }]
  }
})
const { form, queryParams, rules } = toRefs(data)
const reportableOrders = computed(() => workOrderOptions.value.filter(i => i.status === 'released' || i.status === 'running'))
const formScheduleOptions = computed(() => form.value.workOrderId ? scheduleOptions.value.filter(i => i.workOrderId === form.value.workOrderId && i.status !== 'cancelled' && i.status !== 'finished') : scheduleOptions.value)
const formStepOptions = computed(() => form.value.operationId ? stepOptions.value.filter(i => i.operationId === form.value.operationId) : stepOptions.value)
function getList() { loading.value = true; reportApi.list(queryParams.value).then(r => { rows.value = r.rows; total.value = r.total; loading.value = false }) }
function loadOptions() {
  workOrderApi.list({ pageNum: 1, pageSize: 999 }).then(r => { workOrderOptions.value = r.rows || [] })
  scheduleApi.list({ pageNum: 1, pageSize: 999 }).then(r => { scheduleOptions.value = r.rows || [] })
  resourceApi.options().then(r => { resourceOptions.value = r.data })
}
function reset() { form.value = { workOrderId: undefined, scheduleId: undefined, operationId: undefined, stepId: undefined, resourceId: undefined, goodQty: 1, badQty: 0, reportTime: undefined, remark: undefined }; operationOptions.value = []; stepOptions.value = []; proxy.resetForm('formRef') }
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.reportId); multiple.value = !sel.length }
function handleAdd() { reset(); open.value = true }
function handleWorkOrderChange(id) {
  form.value.scheduleId = undefined; form.value.operationId = undefined; form.value.stepId = undefined; form.value.resourceId = undefined
  reportApi.operations(id).then(r => { operationOptions.value = r.data || [] })
  reportApi.steps(id).then(r => { stepOptions.value = r.data || [] })
}
function handleScheduleChange(id) {
  const schedule = scheduleOptions.value.find(i => i.scheduleId === id)
  if (!schedule) return
  form.value.workOrderId = schedule.workOrderId
  form.value.operationId = schedule.operationId
  form.value.resourceId = schedule.resourceId
  if (form.value.workOrderId) {
    reportApi.operations(form.value.workOrderId).then(r => { operationOptions.value = r.data || [] })
    reportApi.steps(form.value.workOrderId).then(r => { stepOptions.value = r.data || [] })
  }
}
function handleOperationChange() { form.value.stepId = undefined }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; reportApi.add(form.value).then(() => { proxy.$modal.msgSuccess('报工成功'); open.value = false; getList(); loadOptions() }) }) }
function handleDelete(row) { const delIds = row?.reportId || ids.value; proxy.$modal.confirm('确认删除选中的报工记录吗？删除后不会回滚工单累计数量。').then(() => reportApi.remove(delIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleExport() { proxy.download(reportApi.exportUrl, { ...queryParams.value }, `step_report_${new Date().getTime()}.xlsx`) }
loadOptions(); getList()
</script>
