<template>
  <div class="app-container routing-page">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="路线编码" prop="routingCode"><el-input v-model="queryParams.routingCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="产品" prop="productId"><el-select v-model="queryParams.productId" clearable filterable><el-option v-for="p in productOptions" :key="p.productId" :label="`${p.productCode} ${p.productName}`" :value="p.productId" /></el-select></el-form-item>
      <el-form-item label="状态" prop="status"><el-select v-model="queryParams.status" clearable><el-option v-for="d in sys_normal_disable" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:base:routing:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:base:routing:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:base:routing:remove']">删除</el-button></el-col>
      <el-col :span="1.5"><el-button type="info" plain icon="Upload" @click="handleImport" v-hasPermi="['mom:base:routing:add']">导入</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:base:routing:export']">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>
    <el-row :gutter="12">
      <el-col :span="13">
        <el-table v-loading="loading" :data="rows" highlight-current-row @current-change="selectRouting" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="45" />
          <el-table-column label="路线编码" prop="routingCode" />
          <el-table-column label="路线名称" prop="routingName" />
          <el-table-column label="产品" prop="productName" />
          <el-table-column label="版本" prop="version" width="90" />
          <el-table-column label="状态" prop="status" width="80"><template #default="s"><dict-tag :options="sys_normal_disable" :value="s.row.status"/></template></el-table-column>
          <el-table-column label="操作" width="145"><template #default="s"><el-button link type="primary" icon="Edit" @click.stop="handleUpdate(s.row)" v-hasPermi="['mom:base:routing:edit']">修改</el-button><el-button link type="primary" icon="Delete" @click.stop="handleDelete(s.row)" v-hasPermi="['mom:base:routing:remove']">删除</el-button></template></el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
      </el-col>
      <el-col :span="11">
        <div class="route-structure">
          <div class="structure-head">
            <div>
              <div class="structure-title">{{ currentRouting ? currentRouting.routingCode : '工艺层级' }}</div>
              <div class="structure-subtitle">{{ currentRouting ? `${currentRouting.routingName || '-'} / ${currentRouting.productName || '-'}` : '请选择左侧工艺路线查看层级' }}</div>
            </div>
            <el-button type="primary" plain icon="Plus" size="small" :disabled="!currentRouting" @click="handleAddOperation" v-hasPermi="['mom:base:operation:add']">工序</el-button>
          </div>
          <div v-if="currentRouting" class="structure-summary">
            <span>版本 {{ currentRouting.version || '-' }}</span>
            <span>{{ operationRows.length }} 道工序</span>
            <span>{{ stepTotal }} 个工步</span>
            <dict-tag :options="sys_normal_disable" :value="currentRouting.status"/>
          </div>
          <el-empty v-if="!currentRouting" description="请选择一条工艺路线" :image-size="80" />
          <el-empty v-else-if="!operationRows.length" description="暂无工序，请先新增工序" :image-size="80" />
          <div v-else class="operation-flow">
            <div v-for="(operation, index) in operationRows" :key="operation.operationId" class="operation-node">
              <div class="operation-marker">
                <span>{{ index + 1 }}</span>
              </div>
              <div class="operation-card">
                <div class="operation-main">
                  <div class="operation-name">
                    <span class="operation-code">{{ operation.operationCode || '自动编码' }}</span>
                    <strong>{{ operation.operationName }}</strong>
                  </div>
                  <div class="operation-meta">
                    <el-tag size="small" effect="plain">顺序 {{ operation.operationSeq }}</el-tag>
                    <dict-tag :options="mom_resource_type" :value="operation.resourceType"/>
                    <el-tag v-if="operation.resourceName || operation.resourceCode" size="small" type="warning" effect="plain">{{ operation.resourceCode || operation.resourceName }}</el-tag>
                    <span>{{ (operation.steps || []).length }} 个工步</span>
                  </div>
                  <div class="operation-actions">
                    <el-button link type="primary" icon="Plus" @click="handleAddStep(operation)" v-hasPermi="['mom:base:step:add']">工步</el-button>
                    <el-button link type="primary" icon="Edit" @click="handleUpdateOperation(operation)" v-hasPermi="['mom:base:operation:edit']">编辑</el-button>
                    <el-button link type="danger" icon="Delete" @click="handleDeleteOperation(operation)" v-hasPermi="['mom:base:operation:remove']">删除</el-button>
                  </div>
                </div>
                <div v-if="(operation.steps || []).length" class="step-list">
                  <div v-for="step in operation.steps" :key="step.stepId" class="step-row">
                    <div class="step-seq">{{ step.stepSeq }}</div>
                    <div class="step-info">
                      <span class="step-code">{{ step.stepCode || '自动编码' }}</span>
                      <strong>{{ step.stepName }}</strong>
                      <span v-if="step.stepDesc" class="step-desc">{{ step.stepDesc }}</span>
                    </div>
                    <div class="step-images">
                      <el-image v-for="img in stepImages(step.imageUrl).slice(0, 3)" :key="img" class="step-thumb" :src="imageSrc(img)" :preview-src-list="stepImages(step.imageUrl).map(imageSrc)" preview-teleported fit="cover" />
                      <span v-if="stepImages(step.imageUrl).length > 3" class="image-count">+{{ stepImages(step.imageUrl).length - 3 }}</span>
                      <span v-if="!stepImages(step.imageUrl).length" class="muted">无图</span>
                    </div>
                    <dict-tag :options="mom_yes_no" :value="step.isReportPoint"/>
                    <div class="step-actions">
                      <el-button link type="primary" icon="Edit" @click="handleUpdateStep(step)" v-hasPermi="['mom:base:step:edit']">编辑</el-button>
                      <el-button link type="danger" icon="Delete" @click="handleDeleteStep(step)" v-hasPermi="['mom:base:step:remove']">删除</el-button>
                    </div>
                  </div>
                </div>
                <button v-else class="empty-step" type="button" @click="handleAddStep(operation)" v-hasPermi="['mom:base:step:add']">
                  + 新增该工序下的第一个工步
                </button>
              </div>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-dialog :title="title" v-model="open" width="560px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="路线编码" prop="routingCode"><el-input v-model="form.routingCode" placeholder="为空时自动生成" /></el-form-item>
        <el-form-item label="路线名称" prop="routingName"><el-input v-model="form.routingName" /></el-form-item>
        <el-form-item label="产品" prop="productId"><el-select v-model="form.productId" filterable><el-option v-for="p in productOptions" :key="p.productId" :label="`${p.productCode} ${p.productName}`" :value="p.productId" /></el-select></el-form-item>
        <el-form-item label="版本" prop="version"><el-input v-model="form.version" /></el-form-item>
        <el-form-item label="状态" prop="status"><el-radio-group v-model="form.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>
    <el-dialog title="工序维护" v-model="operationOpen" width="520px" append-to-body>
      <el-form ref="operationRef" :model="operationForm" :rules="operationRules" label-width="90px">
        <el-form-item label="工序编码" prop="operationCode"><el-input v-model="operationForm.operationCode" placeholder="为空时自动生成" /></el-form-item>
        <el-form-item label="工序名称" prop="operationName"><el-input v-model="operationForm.operationName" /></el-form-item>
        <el-form-item label="顺序" prop="operationSeq"><el-input-number v-model="operationForm.operationSeq" :min="1" /></el-form-item>
        <el-form-item label="标准分钟" prop="standardMinutes"><el-input-number v-model="operationForm.standardMinutes" :min="0" /></el-form-item>
        <el-form-item label="资源类型" prop="resourceType"><el-select v-model="operationForm.resourceType" clearable><el-option v-for="d in mom_resource_type" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
        <el-form-item label="工位" prop="resourceId"><el-select v-model="operationForm.resourceId" clearable filterable><el-option v-for="r in stationOptions" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" /></el-select></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="operationForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitOperation">确定</el-button><el-button @click="operationOpen = false">取消</el-button></div></template>
    </el-dialog>
    <el-dialog title="工步维护" v-model="stepOpen" width="520px" append-to-body>
      <el-form ref="stepRef" :model="stepForm" :rules="stepRules" label-width="90px">
        <el-form-item label="工步编码" prop="stepCode"><el-input v-model="stepForm.stepCode" placeholder="为空时自动生成" /></el-form-item>
        <el-form-item label="工步名称" prop="stepName"><el-input v-model="stepForm.stepName" /></el-form-item>
        <el-form-item label="顺序" prop="stepSeq"><el-input-number v-model="stepForm.stepSeq" :min="1" /></el-form-item>
        <el-form-item label="标准分钟" prop="standardMinutes"><el-input-number v-model="stepForm.standardMinutes" :min="0" /></el-form-item>
        <el-form-item label="报工点" prop="isReportPoint"><el-radio-group v-model="stepForm.isReportPoint"><el-radio v-for="d in mom_yes_no" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="作业类型" prop="operationType"><el-input v-model="stepForm.operationType" /></el-form-item>
        <el-form-item label="螺孔检测" prop="screwCheckCount"><el-input-number v-model="stepForm.screwCheckCount" :min="0" /></el-form-item>
        <el-form-item label="视觉程序" prop="visionProgram"><el-input v-model="stepForm.visionProgram" /></el-form-item>
        <el-form-item label="指引ID" prop="guideTaskId"><el-input v-model="stepForm.guideTaskId" /></el-form-item>
        <el-form-item label="工步图片" prop="imageUrl"><image-upload v-model="stepForm.imageUrl" :limit="20" /></el-form-item>
        <el-form-item label="作业指导" prop="stepDesc"><el-input v-model="stepForm.stepDesc" type="textarea" /></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="stepForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitStep">确定</el-button><el-button @click="stepOpen = false">取消</el-button></div></template>
    </el-dialog>
    <excel-import-dialog ref="importRoutingRef" title="工艺路线导入" :action="routingApi.importUrl" :template-action="routingApi.importTemplateUrl" template-file-name="routing_step_template" update-support-label="是否更新已经存在的工艺路线（会重建该路线下工序和工步）" @success="handleImportSuccess" />
  </div>
</template>

<script setup>
import { productApi, routingApi, operationApi, stepApi, resourceApi } from '@/api/mom/base'
import ExcelImportDialog from '@/components/ExcelImportDialog'
const { proxy } = getCurrentInstance()
const { sys_normal_disable, mom_resource_type, mom_yes_no } = proxy.useDict('sys_normal_disable', 'mom_resource_type', 'mom_yes_no')
const rows = ref([]), productOptions = ref([]), stationOptions = ref([]), operationRows = ref([]), currentRouting = ref(null)
const open = ref(false), operationOpen = ref(false), stepOpen = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), total = ref(0), title = ref('')
const operationForm = ref({}), stepForm = ref({})
const data = reactive({ form: {}, queryParams: { pageNum: 1, pageSize: 10, routingCode: undefined, productId: undefined, status: undefined }, rules: { routingName: [{ required: true, message: '路线名称不能为空', trigger: 'blur' }], productId: [{ required: true, message: '产品不能为空', trigger: 'change' }], version: [{ required: true, message: '版本不能为空', trigger: 'blur' }] } })
const { queryParams, form, rules } = toRefs(data)
const stepTotal = computed(() => operationRows.value.reduce((total, item) => total + (item.steps || []).length, 0))
const operationRules = { operationName: [{ required: true, message: '工序名称不能为空', trigger: 'blur' }], operationSeq: [{ required: true, message: '顺序不能为空', trigger: 'blur' }], resourceId: [{ required: true, message: '工位不能为空', trigger: 'change' }] }
const stepRules = { stepName: [{ required: true, message: '工步名称不能为空', trigger: 'blur' }], stepSeq: [{ required: true, message: '顺序不能为空', trigger: 'blur' }] }
function getList() { loading.value = true; routingApi.list(queryParams.value).then(r => { rows.value = r.rows; total.value = r.total; loading.value = false; if (!currentRouting.value && rows.value.length) selectRouting(rows.value[0]) }) }
function loadOptions() { productApi.options().then(r => { productOptions.value = r.data }); resourceApi.options().then(r => { stationOptions.value = (r.data || []).filter(i => i.resourceType === 'station') }) }
function selectRouting(row) { if (!row) return; currentRouting.value = row; refreshDetail() }
function refreshDetail() { if (!currentRouting.value) return; routingApi.detail(currentRouting.value.routingId).then(r => { currentRouting.value = r.data; operationRows.value = r.data?.operations || [] }) }
function reset() { form.value = { routingId: undefined, routingCode: undefined, routingName: undefined, productId: undefined, version: 'V1', status: '0', remark: undefined }; proxy.resetForm('formRef') }
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; currentRouting.value = null; operationRows.value = []; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.routingId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleAdd() { reset(); open.value = true; title.value = '新增工艺路线' }
function handleUpdate(row) { reset(); routingApi.get(row?.routingId || ids.value[0]).then(r => { form.value = r.data; open.value = true; title.value = '修改工艺路线' }) }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; const save = form.value.routingId ? routingApi.update : routingApi.add; save(form.value).then(() => { proxy.$modal.msgSuccess('保存成功'); open.value = false; getList() }) }) }
function handleDelete(row) { const delIds = row?.routingId || ids.value; proxy.$modal.confirm('确认删除选中的工艺路线数据吗？').then(() => routingApi.remove(delIds)).then(() => { currentRouting.value = null; operationRows.value = []; getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleImport() { proxy.$refs.importRoutingRef.open() }
function handleImportSuccess() { currentRouting.value = null; operationRows.value = []; getList() }
function handleExport() { proxy.download(routingApi.exportUrl, { ...queryParams.value }, `routing_step_${new Date().getTime()}.xlsx`) }
function handleAddOperation() { operationForm.value = { routingId: currentRouting.value.routingId, operationSeq: (operationRows.value.length + 1) * 10, resourceType: 'station', status: '0' }; operationOpen.value = true }
function handleUpdateOperation(row) { operationApi.get(row.operationId).then(r => { operationForm.value = r.data; operationOpen.value = true }) }
function handleDeleteOperation(row) { proxy.$modal.confirm('确认删除该工序及其工步吗？').then(() => operationApi.remove(row.operationId)).then(() => { refreshDetail(); proxy.$modal.msgSuccess('删除成功') }) }
function handleAddStep(row) { stepForm.value = { operationId: row.operationId, stepSeq: ((row.steps || []).length + 1) * 10, isReportPoint: 'Y', status: '0' }; stepOpen.value = true }
function handleUpdateStep(row) { stepApi.get(row.stepId).then(r => { stepForm.value = r.data; stepOpen.value = true }) }
function handleDeleteStep(row) { proxy.$modal.confirm('确认删除该工步吗？').then(() => stepApi.remove(row.stepId)).then(() => { refreshDetail(); proxy.$modal.msgSuccess('删除成功') }) }
function submitOperation() { proxy.$refs.operationRef.validate(valid => { if (!valid) return; const fn = operationForm.value.operationId ? operationApi.update : operationApi.add; fn(operationForm.value).then(() => { proxy.$modal.msgSuccess('保存成功'); operationOpen.value = false; refreshDetail() }) }) }
function submitStep() { proxy.$refs.stepRef.validate(valid => { if (!valid) return; const fn = stepForm.value.stepId ? stepApi.update : stepApi.add; fn(stepForm.value).then(() => { proxy.$modal.msgSuccess('保存成功'); stepOpen.value = false; refreshDetail() }) }) }
function stepImages(value) { return value ? String(value).split(',').filter(Boolean) : [] }
function imageSrc(value) { return value && !value.startsWith('http') ? import.meta.env.VITE_APP_BASE_API + value : value }

loadOptions(); getList()
</script>

<style scoped>
.route-structure {
  min-height: 420px;
  border-left: 1px solid #e5eaf3;
  padding-left: 16px;
}
.structure-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #edf0f5;
}
.structure-title {
  color: #1f2d3d;
  font-size: 16px;
  font-weight: 700;
  line-height: 24px;
}
.structure-subtitle {
  max-width: 430px;
  overflow: hidden;
  color: #7a8799;
  font-size: 13px;
  line-height: 20px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.structure-summary {
  display: flex;
  align-items: center;
  gap: 8px;
  min-height: 34px;
  margin: 10px 0 12px;
  color: #607085;
  font-size: 13px;
}
.structure-summary span {
  padding: 3px 8px;
  background: #f6f8fb;
  border: 1px solid #edf0f5;
  border-radius: 4px;
}
.operation-flow {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 2px 0 8px;
}
.operation-flow::before {
  position: absolute;
  top: 18px;
  bottom: 18px;
  left: 17px;
  width: 2px;
  background: #d7e8ff;
  content: "";
}
.operation-node {
  position: relative;
  display: grid;
  grid-template-columns: 36px minmax(0, 1fr);
  gap: 10px;
}
.operation-marker {
  position: relative;
  z-index: 1;
  display: flex;
  justify-content: center;
}
.operation-marker span {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  color: #fff;
  font-weight: 700;
  background: #409eff;
  border: 3px solid #e8f3ff;
  border-radius: 50%;
}
.operation-card {
  overflow: hidden;
  background: #fff;
  border: 1px solid #dce8f6;
  border-radius: 6px;
}
.operation-main {
  display: grid;
  grid-template-columns: minmax(180px, 1fr) auto auto;
  align-items: center;
  gap: 10px;
  min-height: 56px;
  padding: 10px 12px;
  background: #f7fbff;
  border-bottom: 1px solid #e3eefb;
}
.operation-name,
.step-info {
  min-width: 0;
}
.operation-code,
.step-code {
  display: block;
  overflow: hidden;
  color: #409eff;
  font-size: 13px;
  font-weight: 600;
  line-height: 18px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.operation-name strong,
.step-info strong {
  display: block;
  overflow: hidden;
  color: #2f3b52;
  font-size: 14px;
  line-height: 20px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.operation-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #7a8799;
  font-size: 12px;
  white-space: nowrap;
}
.operation-actions,
.step-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 4px;
  white-space: nowrap;
}
.step-list {
  display: flex;
  flex-direction: column;
}
.step-row {
  display: grid;
  grid-template-columns: 48px minmax(150px, 1fr) 116px 72px 100px;
  align-items: center;
  gap: 10px;
  min-height: 56px;
  padding: 8px 12px;
  border-bottom: 1px solid #eef2f7;
}
.step-row:last-child {
  border-bottom: 0;
}
.step-seq {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 24px;
  color: #65758b;
  font-weight: 600;
  background: #f4f7fb;
  border: 1px solid #e3e8f0;
  border-radius: 4px;
}
.step-desc {
  display: block;
  overflow: hidden;
  color: #8b98aa;
  font-size: 12px;
  line-height: 18px;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.step-images {
  display: flex;
  align-items: center;
  gap: 4px;
  min-width: 0;
}
.step-thumb {
  width: 30px;
  height: 30px;
  border: 1px solid #e3e8f0;
  border-radius: 4px;
  vertical-align: middle;
}
.image-count,
.muted {
  color: #8b98aa;
  font-size: 12px;
}
.empty-step {
  width: calc(100% - 24px);
  height: 34px;
  margin: 10px 12px;
  color: #409eff;
  cursor: pointer;
  background: #f8fbff;
  border: 1px dashed #a6d2ff;
  border-radius: 4px;
}
.empty-step:hover {
  background: #ecf5ff;
}

@media (max-width: 1360px) {
  .operation-main {
    grid-template-columns: minmax(160px, 1fr);
  }
  .operation-meta,
  .operation-actions {
    justify-content: flex-start;
  }
  .step-row {
    grid-template-columns: 42px minmax(130px, 1fr) 96px;
  }
  .step-actions {
    grid-column: 2 / 4;
    justify-content: flex-start;
  }
}
</style>
