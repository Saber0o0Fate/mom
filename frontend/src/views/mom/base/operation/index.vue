<template>
  <div class="app-container">
    <el-form :model="queryParams" :inline="true">
      <el-form-item label="工艺路线" prop="routingId"><el-select v-model="queryParams.routingId" filterable clearable @change="handleQuery"><el-option v-for="r in routingOptions" :key="r.routingId" :label="`${r.routingCode} ${r.routingName}`" :value="r.routingId" /></el-select></el-form-item>
      <el-form-item label="工序编码" prop="operationCode"><el-input v-model="queryParams.operationCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="12">
      <el-col :span="13">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5"><el-button type="primary" plain icon="Plus" :disabled="!queryParams.routingId" @click="handleAddOperation" v-hasPermi="['mom:base:operation:add']">新增工序</el-button></el-col>
          <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExportOperation" v-hasPermi="['mom:base:operation:export']">导出工序</el-button></el-col>
        </el-row>
        <el-table v-loading="operationLoading" :data="operationRows" highlight-current-row @current-change="selectOperation">
          <el-table-column label="路线编码" prop="routingCode" />
          <el-table-column label="顺序" prop="operationSeq" width="70" />
          <el-table-column label="工序编码" prop="operationCode" />
          <el-table-column label="工序名称" prop="operationName" />
          <el-table-column label="资源类型" prop="resourceType"><template #default="s"><dict-tag :options="mom_resource_type" :value="s.row.resourceType"/></template></el-table-column>
          <el-table-column label="操作" width="150"><template #default="s"><el-button link type="primary" icon="Edit" @click.stop="handleUpdateOperation(s.row)" v-hasPermi="['mom:base:operation:edit']">修改</el-button><el-button link type="primary" icon="Delete" @click.stop="handleDeleteOperation(s.row)" v-hasPermi="['mom:base:operation:remove']">删除</el-button></template></el-table-column>
        </el-table>
        <pagination v-show="operationTotal > 0" :total="operationTotal" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getOperationList" />
      </el-col>
      <el-col :span="11">
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5"><el-button type="primary" plain icon="Plus" :disabled="!currentOperation" @click="handleAddStep" v-hasPermi="['mom:base:step:add']">新增工步</el-button></el-col>
          <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExportStep" v-hasPermi="['mom:base:step:export']">导出工步</el-button></el-col>
        </el-row>
        <el-table v-loading="stepLoading" :data="stepRows">
          <el-table-column label="工序编码" prop="operationCode" />
          <el-table-column label="顺序" prop="stepSeq" width="70" />
          <el-table-column label="工步编码" prop="stepCode" />
          <el-table-column label="工步名称" prop="stepName" />
          <el-table-column label="图片" width="82">
            <template #default="s">
              <el-image v-if="stepImages(s.row.imageUrl).length" class="step-thumb" :src="imageSrc(stepImages(s.row.imageUrl)[0])" :preview-src-list="stepImages(s.row.imageUrl).map(imageSrc)" preview-teleported fit="cover" />
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="报工点" prop="isReportPoint" width="90"><template #default="s"><dict-tag :options="mom_yes_no" :value="s.row.isReportPoint"/></template></el-table-column>
          <el-table-column label="操作" width="150"><template #default="s"><el-button link type="primary" icon="Edit" @click="handleUpdateStep(s.row)" v-hasPermi="['mom:base:step:edit']">修改</el-button><el-button link type="primary" icon="Delete" @click="handleDeleteStep(s.row)" v-hasPermi="['mom:base:step:remove']">删除</el-button></template></el-table-column>
        </el-table>
      </el-col>
    </el-row>

    <el-dialog title="工序维护" v-model="operationOpen" width="520px" append-to-body>
      <el-form ref="operationRef" :model="operationForm" :rules="operationRules" label-width="90px">
        <el-form-item label="工艺路线" prop="routingId"><el-select v-model="operationForm.routingId" filterable><el-option v-for="r in routingOptions" :key="r.routingId" :label="`${r.routingCode} ${r.routingName}`" :value="r.routingId" /></el-select></el-form-item>
        <el-form-item label="工序编码" prop="operationCode"><el-input v-model="operationForm.operationCode" placeholder="为空时自动生成" /></el-form-item>
        <el-form-item label="工序名称" prop="operationName"><el-input v-model="operationForm.operationName" /></el-form-item>
        <el-form-item label="顺序" prop="operationSeq"><el-input-number v-model="operationForm.operationSeq" :min="1" /></el-form-item>
        <el-form-item label="标准分钟" prop="standardMinutes"><el-input-number v-model="operationForm.standardMinutes" :min="0" /></el-form-item>
        <el-form-item label="资源类型" prop="resourceType"><el-select v-model="operationForm.resourceType" clearable><el-option v-for="d in mom_resource_type" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="operationForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitOperation">确定</el-button><el-button @click="operationOpen = false">取消</el-button></div></template>
    </el-dialog>
    <el-dialog title="工步维护" v-model="stepOpen" width="720px" append-to-body>
      <el-form ref="stepRef" :model="stepForm" :rules="stepRules" label-width="90px">
        <el-form-item label="工序" prop="operationId"><el-select v-model="stepForm.operationId" filterable><el-option v-for="o in operationRows" :key="o.operationId" :label="`${o.operationCode} ${o.operationName}`" :value="o.operationId" /></el-select></el-form-item>
        <el-form-item label="工步编码" prop="stepCode"><el-input v-model="stepForm.stepCode" placeholder="为空时自动生成" /></el-form-item>
        <el-form-item label="工步名称" prop="stepName"><el-input v-model="stepForm.stepName" /></el-form-item>
        <el-form-item label="顺序" prop="stepSeq"><el-input-number v-model="stepForm.stepSeq" :min="1" /></el-form-item>
        <el-form-item label="标准分钟" prop="standardMinutes"><el-input-number v-model="stepForm.standardMinutes" :min="0" /></el-form-item>
        <el-form-item label="报工点" prop="isReportPoint"><el-radio-group v-model="stepForm.isReportPoint"><el-radio v-for="d in mom_yes_no" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="作业类型"><el-select v-model="stepForm.operationType" clearable><el-option label="备料" value="prepare" /><el-option label="装配" value="assemble" /><el-option label="锁附" value="screw" /><el-option label="拍照" value="camera" /><el-option label="测试" value="test" /><el-option label="包装" value="pack" /></el-select></el-form-item>
        <el-form-item label="作业指导"><el-input v-model="stepForm.stepDesc" type="textarea" :rows="3" /></el-form-item>
        <el-form-item label="螺孔检测"><el-input-number v-model="stepForm.screwCheckCount" :min="0" /></el-form-item>
        <el-form-item label="视觉程序"><el-input v-model="stepForm.visionProgram" placeholder="如 HK-VISION-001" /></el-form-item>
        <el-form-item label="指引ID"><el-input v-model="stepForm.guideTaskId" placeholder="智能指引软件任务ID" /></el-form-item>
        <el-form-item label="工步图片"><image-upload v-model="stepForm.imageUrl" :limit="20" /></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="stepForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitStep">确定</el-button><el-button @click="stepOpen = false">取消</el-button></div></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { routingApi, operationApi, stepApi } from '@/api/mom/base'
const { proxy } = getCurrentInstance()
const { mom_resource_type, mom_yes_no } = proxy.useDict('mom_resource_type', 'mom_yes_no')
const routingOptions = ref([]), operationRows = ref([]), stepRows = ref([]), currentOperation = ref(null)
const operationLoading = ref(false), stepLoading = ref(false), operationOpen = ref(false), stepOpen = ref(false), operationTotal = ref(0)
const queryParams = ref({ pageNum: 1, pageSize: 10, routingId: undefined, operationCode: undefined })
const operationForm = ref({}), stepForm = ref({})
const operationRules = { routingId: [{ required: true, message: '工艺路线不能为空', trigger: 'change' }], operationName: [{ required: true, message: '工序名称不能为空', trigger: 'blur' }], operationSeq: [{ required: true, message: '顺序不能为空', trigger: 'blur' }] }
const stepRules = { operationId: [{ required: true, message: '工序不能为空', trigger: 'change' }], stepName: [{ required: true, message: '工步名称不能为空', trigger: 'blur' }], stepSeq: [{ required: true, message: '顺序不能为空', trigger: 'blur' }] }
function loadRoutingOptions() { routingApi.list({ pageNum: 1, pageSize: 999 }).then(r => { routingOptions.value = r.rows || [] }) }
function getOperationList() { operationLoading.value = true; operationApi.list(queryParams.value).then(r => { operationRows.value = r.rows; operationTotal.value = r.total; operationLoading.value = false; if (!currentOperation.value && operationRows.value.length) selectOperation(operationRows.value[0]) }) }
function getStepList() { if (!currentOperation.value) { stepRows.value = []; return } stepLoading.value = true; stepApi.list({ operationId: currentOperation.value.operationId }).then(r => { stepRows.value = r.rows; stepLoading.value = false }) }
function selectOperation(row) { currentOperation.value = row; getStepList() }
function handleQuery() { queryParams.value.pageNum = 1; currentOperation.value = null; getOperationList() }
function resetQuery() { queryParams.value = { pageNum: 1, pageSize: 10, routingId: undefined, operationCode: undefined }; currentOperation.value = null; stepRows.value = []; getOperationList() }
function handleAddOperation() { operationForm.value = { routingId: queryParams.value.routingId, operationSeq: (operationRows.value.length + 1) * 10, status: '0' }; operationOpen.value = true }
function handleUpdateOperation(row) { operationApi.get(row.operationId).then(r => { operationForm.value = r.data; operationOpen.value = true }) }
function submitOperation() { proxy.$refs.operationRef.validate(valid => { if (!valid) return; const fn = operationForm.value.operationId ? operationApi.update : operationApi.add; fn(operationForm.value).then(() => { proxy.$modal.msgSuccess('保存成功'); operationOpen.value = false; getOperationList() }) }) }
function handleDeleteOperation(row) { proxy.$modal.confirm('确认删除该工序及其工步吗？').then(() => operationApi.remove(row.operationId)).then(() => { currentOperation.value = null; getOperationList(); stepRows.value = []; proxy.$modal.msgSuccess('删除成功') }) }
function handleAddStep() { stepForm.value = { operationId: currentOperation.value.operationId, stepSeq: (stepRows.value.length + 1) * 10, isReportPoint: 'Y', status: '0' }; stepOpen.value = true }
function handleUpdateStep(row) { stepApi.get(row.stepId).then(r => { stepForm.value = r.data; stepOpen.value = true }) }
function submitStep() { proxy.$refs.stepRef.validate(valid => { if (!valid) return; const fn = stepForm.value.stepId ? stepApi.update : stepApi.add; fn(stepForm.value).then(() => { proxy.$modal.msgSuccess('保存成功'); stepOpen.value = false; getStepList() }) }) }
function handleDeleteStep(row) { proxy.$modal.confirm('确认删除该工步吗？').then(() => stepApi.remove(row.stepId)).then(() => { getStepList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleExportOperation() { proxy.download(operationApi.exportUrl, { ...queryParams.value }, `operation_${new Date().getTime()}.xlsx`) }
function handleExportStep() { proxy.download(stepApi.exportUrl, { operationId: currentOperation.value?.operationId }, `step_${new Date().getTime()}.xlsx`) }
function stepImages(value) { return value ? String(value).split(',').filter(Boolean) : [] }
function imageSrc(value) { return value && !value.startsWith('http') ? import.meta.env.VITE_APP_BASE_API + value : value }
loadRoutingOptions(); getOperationList()
</script>

<style scoped>
.step-thumb { width: 38px; height: 38px; border-radius: 4px; vertical-align: middle; }
</style>
