<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="排产编码" prop="scheduleCode"><el-input v-model="queryParams.scheduleCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="工单" prop="workOrderId"><el-select v-model="queryParams.workOrderId" clearable filterable><el-option v-for="w in workOrderOptions" :key="w.workOrderId" :label="`${w.workOrderCode} ${w.productName || ''}`" :value="w.workOrderId" /></el-select></el-form-item>
      <el-form-item label="资源" prop="resourceId"><el-select v-model="queryParams.resourceId" clearable filterable><el-option v-for="r in resourceOptions" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" /></el-select></el-form-item>
      <el-form-item label="状态" prop="status"><el-select v-model="queryParams.status" clearable><el-option v-for="d in mom_schedule_status" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:schedule:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:schedule:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:schedule:remove']">删除</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:schedule:export']">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="rows" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="45" />
      <el-table-column label="排产编码" prop="scheduleCode" min-width="150" />
      <el-table-column label="工单" prop="workOrderCode" min-width="150" />
      <el-table-column label="产品" prop="productName" min-width="120" />
      <el-table-column label="工序" min-width="130"><template #default="s">{{ s.row.operationCode }} {{ s.row.operationName }}</template></el-table-column>
      <el-table-column label="资源" prop="resourceName" min-width="120" />
      <el-table-column label="计划开始" prop="planStartTime" width="160" />
      <el-table-column label="计划结束" prop="planEndTime" width="160" />
      <el-table-column label="计划数量" prop="planQty" width="100" />
      <el-table-column label="已报工" prop="reportedQty" width="100" />
      <el-table-column label="状态" prop="status" width="90"><template #default="s"><dict-tag :options="mom_schedule_status" :value="s.row.status" /></template></el-table-column>
      <el-table-column label="操作" fixed="right" width="260">
        <template #default="s">
          <el-button link type="primary" icon="Edit" v-if="s.row.status === 'draft' || s.row.status === 'released'" @click="handleUpdate(s.row)" v-hasPermi="['mom:schedule:edit']">修改</el-button>
          <el-button link type="primary" icon="Position" v-if="s.row.status === 'draft'" @click="handleRelease(s.row)" v-hasPermi="['mom:schedule:release']">下达</el-button>
          <el-button link type="primary" icon="VideoPlay" v-if="s.row.status === 'released'" @click="handleStart(s.row)" v-hasPermi="['mom:schedule:start']">开工</el-button>
          <el-button link type="primary" icon="CircleCheck" v-if="s.row.status === 'released' || s.row.status === 'running'" @click="handleFinish(s.row)" v-hasPermi="['mom:schedule:finish']">完工</el-button>
          <el-button link type="primary" icon="Close" v-if="s.row.status !== 'finished' && s.row.status !== 'cancelled'" @click="handleCancelSchedule(s.row)" v-hasPermi="['mom:schedule:cancel']">取消</el-button>
          <el-button link type="primary" icon="Delete" v-if="s.row.status === 'draft'" @click="handleDelete(s.row)" v-hasPermi="['mom:schedule:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="720px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="95px">
        <el-row>
          <el-col :span="12"><el-form-item label="排产编码" prop="scheduleCode"><el-input v-model="form.scheduleCode" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="工单" prop="workOrderId"><el-select v-model="form.workOrderId" filterable @change="handleWorkOrderChange"><el-option v-for="w in schedulableOrders" :key="w.workOrderId" :label="`${w.workOrderCode} ${w.productName || ''}`" :value="w.workOrderId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="工序" prop="operationId"><el-select v-model="form.operationId" clearable filterable><el-option v-for="o in operationOptions" :key="o.operationId" :label="`${o.operationCode} ${o.operationName}`" :value="o.operationId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="资源" prop="resourceId"><el-select v-model="form.resourceId" filterable><el-option v-for="r in resourceOptions" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="开始时间" prop="planStartTime"><el-date-picker v-model="form.planStartTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="结束时间" prop="planEndTime"><el-date-picker v-model="form.planEndTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="计划数量" prop="planQty"><el-input-number v-model="form.planQty" :min="0.000001" :precision="6" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="状态" prop="status"><el-select v-model="form.status"><el-option v-for="d in mom_schedule_status" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item></el-col>
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
const { mom_schedule_status } = proxy.useDict('mom_schedule_status')
const rows = ref([]), workOrderOptions = ref([]), resourceOptions = ref([]), operationOptions = ref([])
const open = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), total = ref(0), title = ref('')
const data = reactive({
  form: {},
  queryParams: { pageNum: 1, pageSize: 10, scheduleCode: undefined, workOrderId: undefined, resourceId: undefined, status: undefined },
  rules: {
    scheduleCode: [{ required: true, message: '排产编码不能为空', trigger: 'blur' }],
    workOrderId: [{ required: true, message: '工单不能为空', trigger: 'change' }],
    resourceId: [{ required: true, message: '资源不能为空', trigger: 'change' }],
    planStartTime: [{ required: true, message: '开始时间不能为空', trigger: 'change' }],
    planEndTime: [{ required: true, message: '结束时间不能为空', trigger: 'change' }],
    planQty: [{ required: true, message: '计划数量不能为空', trigger: 'blur' }]
  }
})
const { form, queryParams, rules } = toRefs(data)
const schedulableOrders = computed(() => workOrderOptions.value.filter(i => i.status !== 'closed' && i.status !== 'finished'))
function getList() { loading.value = true; scheduleApi.list(queryParams.value).then(r => { rows.value = r.rows; total.value = r.total; loading.value = false }) }
function loadOptions() {
  workOrderApi.list({ pageNum: 1, pageSize: 999 }).then(r => { workOrderOptions.value = r.rows || [] })
  resourceApi.options().then(r => { resourceOptions.value = r.data })
}
function reset() { form.value = { scheduleId: undefined, scheduleCode: undefined, workOrderId: undefined, operationId: undefined, resourceId: undefined, planStartTime: undefined, planEndTime: undefined, planQty: 1, status: 'draft', remark: undefined }; operationOptions.value = []; proxy.resetForm('formRef') }
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.scheduleId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleWorkOrderChange(id) {
  const order = workOrderOptions.value.find(i => i.workOrderId === id)
  form.value.planQty = order?.planQty ? Number(order.planQty) : form.value.planQty
  form.value.operationId = undefined
  reportApi.operations(id).then(r => { operationOptions.value = r.data || [] })
}
function handleAdd() { reset(); open.value = true; title.value = '新增生产排产' }
function handleUpdate(row) { reset(); scheduleApi.get(row?.scheduleId || ids.value[0]).then(r => { form.value = r.data; open.value = true; title.value = '修改生产排产'; if (form.value.workOrderId) handleWorkOrderChange(form.value.workOrderId) }) }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; const save = form.value.scheduleId ? scheduleApi.update : scheduleApi.add; save(form.value).then(() => { proxy.$modal.msgSuccess('保存成功'); open.value = false; getList(); loadOptions() }) }) }
function handleDelete(row) { const delIds = row?.scheduleId || ids.value; proxy.$modal.confirm('确认删除选中的草稿排产吗？').then(() => scheduleApi.remove(delIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleExport() { proxy.download(scheduleApi.exportUrl, { ...queryParams.value }, `schedule_${new Date().getTime()}.xlsx`) }
function handleRelease(row) { proxy.$modal.confirm(`确认下达排产 ${row.scheduleCode} 吗？`).then(() => scheduleApi.release(row.scheduleId)).then(() => { getList(); proxy.$modal.msgSuccess('下达成功') }) }
function handleStart(row) { proxy.$modal.confirm(`确认排产 ${row.scheduleCode} 开工吗？`).then(() => scheduleApi.start(row.scheduleId)).then(() => { getList(); proxy.$modal.msgSuccess('开工成功') }) }
function handleFinish(row) { proxy.$modal.confirm(`确认排产 ${row.scheduleCode} 完工吗？`).then(() => scheduleApi.finish(row.scheduleId)).then(() => { getList(); proxy.$modal.msgSuccess('完工成功') }) }
function handleCancelSchedule(row) { proxy.$modal.confirm(`确认取消排产 ${row.scheduleCode} 吗？`).then(() => scheduleApi.cancel(row.scheduleId)).then(() => { getList(); proxy.$modal.msgSuccess('取消成功') }) }
loadOptions(); getList()
</script>
