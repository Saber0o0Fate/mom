<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="工单编码" prop="workOrderCode"><el-input v-model="queryParams.workOrderCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="产品" prop="productId"><el-select v-model="queryParams.productId" clearable filterable><el-option v-for="p in productOptions" :key="p.productId" :label="`${p.productCode} ${p.productName}`" :value="p.productId" /></el-select></el-form-item>
      <el-form-item label="状态" prop="status"><el-select v-model="queryParams.status" clearable><el-option v-for="d in mom_work_order_status" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
      <el-form-item label="来源单号" prop="sourceOrderCode"><el-input v-model="queryParams.sourceOrderCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:workorder:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:workorder:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:workorder:remove']">删除</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:workorder:export']">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="rows" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="45" />
      <el-table-column label="工单编码" prop="workOrderCode" min-width="150" />
      <el-table-column label="工单名称" prop="workOrderName" min-width="150" />
      <el-table-column label="产品" prop="productName" min-width="120" />
      <el-table-column label="计划数量" prop="planQty" width="100" />
      <el-table-column label="完工数量" prop="completedQty" width="100" />
      <el-table-column label="单位" prop="unit" width="70" />
      <el-table-column label="资源" prop="resourceName" min-width="120" />
      <el-table-column label="计划开始" prop="planStartDate" width="110" />
      <el-table-column label="计划结束" prop="planEndDate" width="110" />
      <el-table-column label="优先级" prop="priority" width="90"><template #default="s"><dict-tag :options="mom_work_order_priority" :value="s.row.priority" /></template></el-table-column>
      <el-table-column label="状态" prop="status" width="90"><template #default="s"><dict-tag :options="mom_work_order_status" :value="s.row.status" /></template></el-table-column>
      <el-table-column label="操作" fixed="right" width="260">
        <template #default="s">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(s.row)" v-hasPermi="['mom:workorder:edit']">修改</el-button>
          <el-button link type="primary" icon="Position" v-if="s.row.status === 'draft'" @click="handleRelease(s.row)" v-hasPermi="['mom:workorder:release']">下达</el-button>
          <el-button link type="primary" icon="VideoPlay" v-if="s.row.status === 'released'" @click="handleStart(s.row)" v-hasPermi="['mom:workorder:start']">开工</el-button>
          <el-button link type="primary" icon="CircleCheck" v-if="s.row.status === 'released' || s.row.status === 'running'" @click="handleFinish(s.row)" v-hasPermi="['mom:workorder:finish']">完工</el-button>
          <el-button link type="primary" icon="Lock" v-if="s.row.status !== 'closed'" @click="handleClose(s.row)" v-hasPermi="['mom:workorder:close']">关闭</el-button>
          <el-button link type="primary" icon="Delete" v-if="s.row.status === 'draft'" @click="handleDelete(s.row)" v-hasPermi="['mom:workorder:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />

    <el-dialog :title="title" v-model="open" width="760px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="95px">
        <el-row>
          <el-col :span="12"><el-form-item label="工单编码" prop="workOrderCode"><el-input v-model="form.workOrderCode" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="工单名称" prop="workOrderName"><el-input v-model="form.workOrderName" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="产品" prop="productId"><el-select v-model="form.productId" filterable @change="handleProductChange"><el-option v-for="p in productOptions" :key="p.productId" :label="`${p.productCode} ${p.productName}`" :value="p.productId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="MBOM" prop="mbomId"><el-select v-model="form.mbomId" clearable filterable><el-option v-for="m in formMbomOptions" :key="m.mbomId" :label="`${m.mbomCode} ${m.version}`" :value="m.mbomId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="工艺路线" prop="routingId"><el-select v-model="form.routingId" clearable filterable><el-option v-for="r in formRoutingOptions" :key="r.routingId" :label="`${r.routingCode} ${r.version}`" :value="r.routingId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="生产资源" prop="resourceId"><el-select v-model="form.resourceId" clearable filterable><el-option v-for="r in resourceOptions" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="计划数量" prop="planQty"><el-input-number v-model="form.planQty" :min="0.000001" :precision="6" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="完工数量" prop="completedQty"><el-input-number v-model="form.completedQty" :min="0" :precision="6" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="单位" prop="unit"><el-input v-model="form.unit" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="优先级" prop="priority"><el-select v-model="form.priority"><el-option v-for="d in mom_work_order_priority" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="计划开始" prop="planStartDate"><el-date-picker v-model="form.planStartDate" type="date" value-format="YYYY-MM-DD" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="计划结束" prop="planEndDate"><el-date-picker v-model="form.planEndDate" type="date" value-format="YYYY-MM-DD" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="来源单号" prop="sourceOrderCode"><el-input v-model="form.sourceOrderCode" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="状态" prop="status"><el-select v-model="form.status"><el-option v-for="d in mom_work_order_status" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item></el-col>
          <el-col :span="24"><el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>

    <el-dialog title="工单完工" v-model="finishOpen" width="420px" append-to-body>
      <el-form ref="finishRef" :model="finishForm" label-width="95px">
        <el-form-item label="工单编码"><el-input v-model="finishForm.workOrderCode" disabled /></el-form-item>
        <el-form-item label="计划数量"><el-input-number v-model="finishForm.planQty" disabled /></el-form-item>
        <el-form-item label="完工数量" prop="completedQty"><el-input-number v-model="finishForm.completedQty" :min="0" :max="finishForm.planQty || 0" :precision="6" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitFinish">确定</el-button><el-button @click="finishOpen = false">取消</el-button></div></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { workOrderApi } from '@/api/mom/workorder'
import { productApi, routingApi, resourceApi } from '@/api/mom/base'
import { mbomApi } from '@/api/mom/mbom'
const { proxy } = getCurrentInstance()
const { mom_work_order_status, mom_work_order_priority } = proxy.useDict('mom_work_order_status', 'mom_work_order_priority')
const rows = ref([]), productOptions = ref([]), mbomOptions = ref([]), routingOptions = ref([]), resourceOptions = ref([])
const open = ref(false), finishOpen = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), total = ref(0), title = ref('')
const data = reactive({
  form: {},
  finishForm: {},
  queryParams: { pageNum: 1, pageSize: 10, workOrderCode: undefined, productId: undefined, status: undefined, sourceOrderCode: undefined },
  rules: {
    workOrderCode: [{ required: true, message: '工单编码不能为空', trigger: 'blur' }],
    workOrderName: [{ required: true, message: '工单名称不能为空', trigger: 'blur' }],
    productId: [{ required: true, message: '产品不能为空', trigger: 'change' }],
    planQty: [{ required: true, message: '计划数量不能为空', trigger: 'blur' }]
  }
})
const { form, finishForm, queryParams, rules } = toRefs(data)
const formMbomOptions = computed(() => form.value.productId ? mbomOptions.value.filter(i => i.productId === form.value.productId) : mbomOptions.value)
const formRoutingOptions = computed(() => form.value.productId ? routingOptions.value.filter(i => i.productId === form.value.productId) : routingOptions.value)
function getList() { loading.value = true; workOrderApi.list(queryParams.value).then(r => { rows.value = r.rows; total.value = r.total; loading.value = false }) }
function loadOptions() {
  productApi.options().then(r => { productOptions.value = r.data })
  mbomApi.list({ pageNum: 1, pageSize: 999 }).then(r => { mbomOptions.value = r.rows || [] })
  routingApi.list({ pageNum: 1, pageSize: 999 }).then(r => { routingOptions.value = r.rows || [] })
  resourceApi.options().then(r => { resourceOptions.value = r.data })
}
function reset() { form.value = { workOrderId: undefined, workOrderCode: undefined, workOrderName: undefined, productId: undefined, mbomId: undefined, routingId: undefined, resourceId: undefined, planQty: 1, completedQty: 0, unit: undefined, priority: 'normal', sourceOrderCode: undefined, planStartDate: undefined, planEndDate: undefined, status: 'draft', remark: undefined }; proxy.resetForm('formRef') }
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.workOrderId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleProductChange(productId) { const p = productOptions.value.find(i => i.productId === productId); form.value.unit = p?.unit || form.value.unit; form.value.mbomId = undefined; form.value.routingId = undefined }
function handleAdd() { reset(); open.value = true; title.value = '新增生产工单' }
function handleUpdate(row) { reset(); workOrderApi.get(row?.workOrderId || ids.value[0]).then(r => { form.value = r.data; open.value = true; title.value = '修改生产工单' }) }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; const save = form.value.workOrderId ? workOrderApi.update : workOrderApi.add; save(form.value).then(() => { proxy.$modal.msgSuccess('保存成功'); open.value = false; getList() }) }) }
function handleDelete(row) { const delIds = row?.workOrderId || ids.value; proxy.$modal.confirm('确认删除选中的草稿工单吗？').then(() => workOrderApi.remove(delIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleExport() { proxy.download(workOrderApi.exportUrl, { ...queryParams.value }, `work_order_${new Date().getTime()}.xlsx`) }
function handleRelease(row) { proxy.$modal.confirm(`确认下达工单 ${row.workOrderCode} 吗？`).then(() => workOrderApi.release(row.workOrderId)).then(() => { getList(); proxy.$modal.msgSuccess('下达成功') }) }
function handleStart(row) { proxy.$modal.confirm(`确认工单 ${row.workOrderCode} 开工吗？`).then(() => workOrderApi.start(row.workOrderId)).then(() => { getList(); proxy.$modal.msgSuccess('开工成功') }) }
function handleFinish(row) { finishForm.value = { workOrderId: row.workOrderId, workOrderCode: row.workOrderCode, planQty: Number(row.planQty), completedQty: Number(row.planQty) }; finishOpen.value = true }
function submitFinish() { workOrderApi.finish(finishForm.value.workOrderId, finishForm.value.completedQty).then(() => { finishOpen.value = false; getList(); proxy.$modal.msgSuccess('完工成功') }) }
function handleClose(row) { proxy.$modal.confirm(`确认关闭工单 ${row.workOrderCode} 吗？`).then(() => workOrderApi.close(row.workOrderId)).then(() => { getList(); proxy.$modal.msgSuccess('关闭成功') }) }
loadOptions(); getList()
</script>
