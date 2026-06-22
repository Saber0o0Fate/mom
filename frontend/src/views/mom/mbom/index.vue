<template>
  <div class="app-container mbom-page">
    <div class="mbom-query" v-show="showSearch">
      <el-form :model="queryParams" ref="queryRef" :inline="true">
        <el-form-item label="MBOM编码" prop="mbomCode">
          <el-input v-model="queryParams.mbomCode" placeholder="输入编码" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="成品物料" prop="productId">
          <el-select v-model="queryParams.productId" clearable filterable placeholder="请选择">
            <el-option v-for="p in productOptions" :key="p.productId" :label="`${p.productCode} ${p.productName}`" :value="p.productId" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" clearable placeholder="请选择">
            <el-option v-for="d in sys_normal_disable" :key="d.value" :label="d.label" :value="d.value" />
          </el-select>
        </el-form-item>
        <el-form-item class="query-actions">
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="mbom-workbench">
      <section class="mbom-panel master-panel">
        <div class="panel-head">
          <div>
            <div class="panel-title">MBOM清单</div>
            <div class="panel-subtitle">选择一条数据后维护右侧用料结构</div>
          </div>
          <div class="panel-actions">
            <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:mbom:add']">新增</el-button>
            <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:mbom:edit']">修改</el-button>
            <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:mbom:remove']">删除</el-button>
            <el-button type="info" plain icon="Upload" @click="handleImport" v-hasPermi="['mom:mbom:add']">导入</el-button>
            <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:mbom:export']">导出</el-button>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
          </div>
        </div>
        <el-table
          v-loading="loading"
          :data="rows"
          height="calc(100vh - 330px)"
          highlight-current-row
          class="mbom-table"
          :row-class-name="masterRowClassName"
          @row-click="selectMbom"
          @selection-change="handleSelectionChange"
        >
          <el-table-column type="selection" width="42" />
          <el-table-column label="MBOM信息" min-width="260">
            <template #default="s">
              <div class="mbom-code">{{ s.row.mbomCode }}</div>
              <div class="mbom-name">{{ s.row.mbomName }}</div>
            </template>
          </el-table-column>
          <el-table-column label="成品物料" min-width="180">
            <template #default="s">
              <div class="product-name">{{ s.row.productName }}</div>
              <div class="muted-text">版本 {{ s.row.version || '-' }}</div>
            </template>
          </el-table-column>
          <el-table-column label="状态" prop="status" width="86" align="center">
            <template #default="s"><dict-tag :options="sys_normal_disable" :value="s.row.status"/></template>
          </el-table-column>
          <el-table-column label="操作" width="150" align="center" fixed="right" class-name="action-column">
            <template #default="s">
              <div class="table-actions">
                <el-button link type="primary" icon="Edit" @click.stop="handleUpdate(s.row)" v-hasPermi="['mom:mbom:edit']">修改</el-button>
                <el-button link type="danger" icon="Delete" @click.stop="handleDelete(s.row)" v-hasPermi="['mom:mbom:remove']">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
      </section>

      <section class="mbom-panel detail-panel">
        <div class="detail-hero" :class="{ 'is-empty': !currentMbom }">
          <div>
            <div class="panel-title">{{ currentMbom ? currentMbom.mbomCode : 'MBOM明细' }}</div>
            <div class="panel-subtitle">{{ currentMbom ? `${currentMbom.mbomName || '-'} / ${currentMbom.productName || '-'}` : '请先在左侧选择一条 MBOM' }}</div>
          </div>
          <div class="detail-stats" v-if="currentMbom">
            <span>版本 {{ currentMbom.version || '-' }}</span>
            <span>{{ flatItemRows.length }} 项用料</span>
            <dict-tag :options="sys_normal_disable" :value="currentMbom.status" />
          </div>
          <div class="panel-actions">
            <el-button type="primary" plain icon="Plus" :disabled="!currentMbom" @click="handleAddItem()" v-hasPermi="['mom:mbom:item:add']">新增明细</el-button>
            <el-button type="warning" plain icon="Download" :disabled="!currentMbom" @click="handleItemExport" v-hasPermi="['mom:mbom:item:export']">导出明细</el-button>
          </div>
        </div>
        <el-empty v-if="!currentMbom" class="detail-empty" description="选择左侧 MBOM 后维护工序、工步和投料" />
        <div v-else class="mbom-structure">
          <el-empty v-if="!mbomStructure.length" description="当前 MBOM 暂无投料明细">
            <el-button type="primary" icon="Plus" @click="handleAddItem()" v-hasPermi="['mom:mbom:item:add']">新增投料</el-button>
          </el-empty>
          <div v-for="operation in mbomStructure" :key="operation.key" class="operation-card">
            <div class="operation-head">
              <div class="level-badge">工序</div>
              <div class="operation-main">
                <div class="operation-code">{{ operation.code }}</div>
                <div class="operation-name">{{ operation.name }}</div>
              </div>
              <div class="operation-meta">{{ operation.itemCount }} 项投料</div>
            </div>

            <div v-for="step in operation.steps" :key="step.key" class="step-block">
              <div class="step-head">
                <div class="step-title">
                  <span class="level-badge step-badge">工步</span>
                  <span class="step-code">{{ step.code }}</span>
                  <span class="step-name">{{ step.name }}</span>
                </div>
                <el-button link type="primary" icon="Plus" @click="handleAddItem(step)" v-hasPermi="['mom:mbom:item:add']">新增投料</el-button>
              </div>

              <el-table :data="step.items" size="small" class="mbom-table feed-table">
                <el-table-column label="行号" prop="itemSeq" width="74" align="center">
                  <template #default="s"><span class="seq-pill">{{ s.row.itemSeq }}</span></template>
                </el-table-column>
                <el-table-column label="工步投料" min-width="230">
                  <template #default="s">
                    <div class="mbom-code">{{ s.row.materialCode }}</div>
                    <div class="mbom-name">{{ s.row.materialName }}</div>
                  </template>
                </el-table-column>
                <el-table-column label="规格" prop="specModel" min-width="110" show-overflow-tooltip />
                <el-table-column label="用量" width="110" align="right">
                  <template #default="s"><span class="qty-text">{{ s.row.quantity }}</span><span class="muted-text unit-text">{{ s.row.unit }}</span></template>
                </el-table-column>
                <el-table-column label="投料方式" prop="issueType" width="118" align="center">
                  <template #default="s"><dict-tag :options="mom_issue_type" :value="s.row.issueType"/></template>
                </el-table-column>
                <el-table-column label="操作" width="150" align="center" class-name="action-column">
                  <template #default="s">
                    <div class="table-actions">
                      <el-button link type="primary" icon="Edit" @click="handleUpdateItem(s.row)" v-hasPermi="['mom:mbom:item:edit']">编辑</el-button>
                      <el-button link type="danger" icon="Delete" @click="handleDeleteItem(s.row)" v-hasPermi="['mom:mbom:item:remove']">删除</el-button>
                    </div>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </div>
        </div>
      </section>
    </div>

    <el-dialog :title="title" v-model="open" :width="form.mbomId ? '560px' : '1280px'" append-to-body class="mbom-create-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="96px">
        <div class="create-basic">
          <div class="create-section-title">基本信息</div>
          <el-row :gutter="16">
            <el-col :span="8" v-if="!form.mbomId">
              <el-form-item label="关联PBOM" prop="pbomId">
                <el-select v-model="form.pbomId" filterable @change="handlePbomChange">
                  <el-option v-for="p in pbomOptions" :key="p.pbomId" :label="`${p.pbomCode} ${p.pbomName}`" :value="p.pbomId" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8" v-if="!form.mbomId">
              <el-form-item label="工艺路线" prop="routingId">
                <el-select v-model="form.routingId" filterable @change="handleRoutingChange">
                  <el-option v-for="r in formRoutingOptions" :key="r.routingId" :label="`${r.routingCode} ${r.routingName}`" :value="r.routingId" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="成品物料" prop="productId"><el-select v-model="form.productId" filterable :disabled="!form.mbomId"><el-option v-for="p in productOptions" :key="p.productId" :label="`${p.productCode} ${p.productName}`" :value="p.productId" /></el-select></el-form-item>
            </el-col>
            <el-col :span="8"><el-form-item label="MBOM编码" prop="mbomCode"><el-input v-model="form.mbomCode" /></el-form-item></el-col>
            <el-col :span="8"><el-form-item label="MBOM名称" prop="mbomName"><el-input v-model="form.mbomName" /></el-form-item></el-col>
            <el-col :span="4"><el-form-item label="版本" prop="version"><el-input v-model="form.version" /></el-form-item></el-col>
            <el-col :span="6"><el-form-item label="生效日期" prop="effectiveDate"><el-date-picker v-model="form.effectiveDate" type="date" value-format="YYYY-MM-DD" /></el-form-item></el-col>
            <el-col :span="6"><el-form-item label="失效日期" prop="expireDate"><el-date-picker v-model="form.expireDate" type="date" value-format="YYYY-MM-DD" /></el-form-item></el-col>
            <el-col :span="6" v-if="!form.mbomId"><el-form-item label="重复编码" prop="updateSupport"><el-switch v-model="form.updateSupport" active-text="更新" inactive-text="拦截" /></el-form-item></el-col>
            <el-col :span="6"><el-form-item label="状态" prop="status"><el-radio-group v-model="form.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item></el-col>
            <el-col :span="24"><el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" :rows="2" /></el-form-item></el-col>
          </el-row>
        </div>

        <div v-if="!form.mbomId" class="generate-workbench">
          <div class="generate-left">
            <div class="create-section-title">工序列表</div>
            <el-table :data="previewOperations" height="260" size="small" highlight-current-row>
              <el-table-column label="顺序" prop="operationSeq" width="70" align="center" />
              <el-table-column label="工序编码" prop="operationCode" min-width="120" />
              <el-table-column label="工序名称" prop="operationName" min-width="150" />
              <el-table-column label="工位" min-width="130">
                <template #default="s"><el-tag size="small" effect="plain">{{ s.row.resourceCode || '未维护' }}</el-tag></template>
              </el-table-column>
              <el-table-column label="匹配" width="80" align="center">
                <template #default="s"><el-tag size="small" :type="matchedCountByResource[s.row.resourceId] ? 'success' : 'info'">{{ matchedCountByResource[s.row.resourceId] || 0 }} 项</el-tag></template>
              </el-table-column>
            </el-table>
          </div>
          <div class="generate-right">
            <div class="create-section-title">投料预览</div>
            <el-tabs model-value="feed">
              <el-tab-pane label="按工位自动绑定" name="feed">
                <el-empty v-if="!generatedFeedRows.length" description="选择PBOM和工艺路线后自动预览投料" :image-size="80" />
                <el-table v-else :data="generatedFeedRows" height="260" size="small">
                  <el-table-column label="工序" min-width="180">
                    <template #default="s"><span class="mbom-code">{{ s.row.operationCode }}</span> {{ s.row.operationName }}</template>
                  </el-table-column>
                  <el-table-column label="工位" prop="resourceCode" width="120" />
                  <el-table-column label="物料编码" prop="materialCode" width="140" />
                  <el-table-column label="物料名称" prop="materialName" min-width="170" />
                  <el-table-column label="数量" prop="quantity" width="90" align="right" />
                </el-table>
              </el-tab-pane>
              <el-tab-pane label="未匹配明细" name="miss">
                <el-empty v-if="!unmatchedPbomRows.length" description="PBOM明细均已匹配到工序工位" :image-size="80" />
                <el-table v-else :data="unmatchedPbomRows" height="260" size="small">
                  <el-table-column label="物料编码" prop="materialCode" width="140" />
                  <el-table-column label="物料名称" prop="materialName" min-width="180" />
                  <el-table-column label="工位" prop="resourceCode" width="140" />
                  <el-table-column label="数量" prop="quantity" width="100" />
                </el-table>
              </el-tab-pane>
            </el-tabs>
          </div>
        </div>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>

    <el-dialog title="工步投料" v-model="itemOpen" width="620px" append-to-body>
      <el-form ref="itemRef" :model="itemForm" :rules="itemRules" label-width="95px">
        <el-form-item label="工序" prop="operationId"><el-select v-model="itemForm.operationId" clearable filterable @change="itemForm.stepId = undefined"><el-option v-for="o in operationOptions" :key="o.operationId" :label="`${o.operationCode} ${o.operationName}`" :value="o.operationId" /></el-select></el-form-item>
        <el-form-item label="工步" prop="stepId"><el-select v-model="itemForm.stepId" clearable filterable><el-option v-for="s in filteredStepOptions" :key="s.stepId" :label="`${s.stepCode} ${s.stepName}`" :value="s.stepId" /></el-select></el-form-item>
        <el-form-item label="投料物料" prop="materialId"><el-select v-model="itemForm.materialId" filterable @change="fillMaterial"><el-option v-for="m in materialOptions" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" /></el-select></el-form-item>
        <el-form-item label="行号" prop="itemSeq"><el-input-number v-model="itemForm.itemSeq" :min="1" /></el-form-item>
        <el-form-item label="用量" prop="quantity"><el-input-number v-model="itemForm.quantity" :min="0.000001" :precision="6" /></el-form-item>
        <el-form-item label="损耗率" prop="scrapRate"><el-input-number v-model="itemForm.scrapRate" :min="0" :precision="4" /></el-form-item>
        <el-form-item label="投料方式" prop="issueType"><el-select v-model="itemForm.issueType"><el-option v-for="d in mom_issue_type" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
        <el-form-item label="状态" prop="status"><el-radio-group v-model="itemForm.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="itemForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitItem">确定</el-button><el-button @click="itemOpen = false">取消</el-button></div></template>
    </el-dialog>

    <excel-import-dialog ref="importMbomRef" title="MBOM导入" :action="mbomApi.importUrl" :template-action="mbomApi.importTemplateUrl" template-file-name="mbom_import_template" update-support-label="是否更新已存在的MBOM并重建明细" @success="handleImportSuccess" />
  </div>
</template>

<script setup>
import ExcelImportDialog from '@/components/ExcelImportDialog'
import { mbomApi, mbomItemApi } from '@/api/mom/mbom'
import { pbomApi } from '@/api/mom/console'
import { materialApi, productApi, operationApi, stepApi, routingApi } from '@/api/mom/base'
const { proxy } = getCurrentInstance()
const { sys_normal_disable, mom_issue_type } = proxy.useDict('sys_normal_disable', 'mom_issue_type')
const rows = ref([]), itemRows = ref([]), productOptions = ref([]), materialOptions = ref([]), operationOptions = ref([]), stepOptions = ref([]), pbomOptions = ref([]), routingOptions = ref([])
const currentPbom = ref(null), currentRoutingDetail = ref(null)
const currentMbom = ref(null), open = ref(false), itemOpen = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), total = ref(0), title = ref('')
const data = reactive({ form: {}, itemForm: {}, queryParams: { pageNum: 1, pageSize: 10, mbomCode: undefined, productId: undefined, status: undefined }, rules: { mbomCode: [{ required: true, message: 'MBOM编码不能为空', trigger: 'blur' }], mbomName: [{ required: true, message: 'MBOM名称不能为空', trigger: 'blur' }], productId: [{ required: true, message: '成品物料不能为空', trigger: 'change' }], pbomId: [{ required: true, message: '关联PBOM不能为空', trigger: 'change' }], routingId: [{ required: true, message: '工艺路线不能为空', trigger: 'change' }], version: [{ required: true, message: '版本不能为空', trigger: 'blur' }] }, itemRules: { materialId: [{ required: true, message: '物料不能为空', trigger: 'change' }], itemSeq: [{ required: true, message: '行号不能为空', trigger: 'blur' }], quantity: [{ required: true, message: '用量不能为空', trigger: 'blur' }] } })
const { form, itemForm, queryParams, rules, itemRules } = toRefs(data)
const filteredStepOptions = computed(() => itemForm.value.operationId ? stepOptions.value.filter(s => s.operationId === itemForm.value.operationId) : stepOptions.value)
const flatItemRows = computed(() => flattenItems(itemRows.value))
const mbomStructure = computed(() => buildMbomStructure(flatItemRows.value))
const formRoutingOptions = computed(() => form.value.productId ? routingOptions.value.filter(i => i.productId === form.value.productId) : routingOptions.value)
const previewOperations = computed(() => currentRoutingDetail.value?.operations || [])
const matchedCountByResource = computed(() => generatedFeedRows.value.reduce((map, row) => {
  map[row.resourceId] = (map[row.resourceId] || 0) + 1
  return map
}, {}))
const generatedFeedRows = computed(() => {
  const pbomItems = currentPbom.value?.items || []
  const rows = []
  const usedResourceIds = new Set()
  previewOperations.value.forEach(operation => {
    if (!operation.resourceId || usedResourceIds.has(operation.resourceId)) return
    usedResourceIds.add(operation.resourceId)
    pbomItems.filter(item => item.resourceId === operation.resourceId).forEach(item => {
      rows.push({ ...item, operationId: operation.operationId, operationCode: operation.operationCode, operationName: operation.operationName, resourceCode: operation.resourceCode })
    })
  })
  return rows
})
const unmatchedPbomRows = computed(() => {
  const matched = new Set(generatedFeedRows.value.map(row => row.itemId))
  return (currentPbom.value?.items || []).filter(row => !matched.has(row.itemId))
})
function getList() { loading.value = true; mbomApi.list(queryParams.value).then(r => { rows.value = r.rows; total.value = r.total; loading.value = false; if (!currentMbom.value && rows.value.length) selectMbom(rows.value[0]) }) }
function loadOptions() { productApi.options().then(r => { productOptions.value = r.data }); materialApi.options().then(r => { materialOptions.value = r.data }); operationApi.list({ pageNum: 1, pageSize: 999 }).then(r => { operationOptions.value = r.rows || [] }); stepApi.list({ pageNum: 1, pageSize: 999 }).then(r => { stepOptions.value = r.rows || [] }); pbomApi.list({ pageNum: 1, pageSize: 999 }).then(r => { pbomOptions.value = r.rows || [] }); routingApi.list({ pageNum: 1, pageSize: 999 }).then(r => { routingOptions.value = r.rows || [] }) }
function selectMbom(row) { if (!row) return; currentMbom.value = row; refreshDetail() }
function refreshDetail() { if (!currentMbom.value) return; mbomApi.detail(currentMbom.value.mbomId).then(r => { currentMbom.value = r.data; itemRows.value = r.data?.items || [] }) }
function reset() { form.value = { mbomId: undefined, mbomCode: undefined, mbomName: undefined, productId: undefined, pbomId: undefined, routingId: undefined, version: 'V1', effectiveDate: undefined, expireDate: undefined, status: '0', updateSupport: false, remark: undefined }; currentPbom.value = null; currentRoutingDetail.value = null; proxy.resetForm('formRef') }
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; currentMbom.value = null; itemRows.value = []; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.mbomId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleAdd() { reset(); open.value = true; title.value = '新增MBOM' }
function handleUpdate(row) { reset(); mbomApi.get(row?.mbomId || ids.value[0]).then(r => { form.value = r.data; open.value = true; title.value = '修改MBOM' }) }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; if (!form.value.mbomId && unmatchedPbomRows.value.length) { proxy.$modal.msgWarning('存在未匹配工位的PBOM明细，请先调整PBOM或工艺路线'); return } const save = form.value.mbomId ? mbomApi.update : mbomApi.generate; save(form.value).then(() => { proxy.$modal.msgSuccess(form.value.mbomId ? '保存成功' : 'MBOM生成成功'); open.value = false; currentMbom.value = null; itemRows.value = []; getList() }) }) }
function handleDelete(row) { const delIds = row?.mbomId || ids.value; proxy.$modal.confirm('确认删除选中的MBOM及明细吗？').then(() => mbomApi.remove(delIds)).then(() => { currentMbom.value = null; itemRows.value = []; getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleImport() { proxy.$refs.importMbomRef.open() }
function handleImportSuccess() { currentMbom.value = null; itemRows.value = []; getList() }
function handleExport() { proxy.download(mbomApi.exportUrl, { ...queryParams.value }, `mbom_${new Date().getTime()}.xlsx`) }
function handleAddItem(step) {
  const rows = step?.items || flatItemRows.value
  itemForm.value = {
    mbomId: currentMbom.value.mbomId,
    parentItemId: 0,
    operationId: step?.operationId,
    stepId: step?.stepId,
    itemSeq: nextSeq(rows),
    quantity: 1,
    scrapRate: 0,
    issueType: 'order',
    status: '0'
  }
  itemOpen.value = true
}
function handleUpdateItem(row) { mbomItemApi.get(row.itemId).then(r => { itemForm.value = r.data; itemOpen.value = true }) }
function submitItem() { proxy.$refs.itemRef.validate(valid => { if (!valid) return; const save = itemForm.value.itemId ? mbomItemApi.update : mbomItemApi.add; save(itemForm.value).then(() => { proxy.$modal.msgSuccess('保存成功'); itemOpen.value = false; refreshDetail() }) }) }
function handleDeleteItem(row) { proxy.$modal.confirm('确认删除该明细及子项吗？').then(() => mbomItemApi.remove(row.itemId)).then(() => { refreshDetail(); proxy.$modal.msgSuccess('删除成功') }) }
function handleItemExport() { proxy.download(mbomItemApi.exportUrl, { mbomId: currentMbom.value?.mbomId }, `mbom_item_${new Date().getTime()}.xlsx`) }
function handlePbomChange(id) {
  const pbom = pbomOptions.value.find(i => i.pbomId === id)
  if (pbom) {
    form.value.productId = pbom.productId
    form.value.mbomCode = form.value.mbomCode || `MBOM-${pbom.pbomCode || ''}`
    form.value.mbomName = form.value.mbomName || `${pbom.productName || pbom.pbomName || ''}制造BOM`
    form.value.version = form.value.version || pbom.version || 'V1'
  }
  currentPbom.value = null
  if (id) pbomApi.get(id).then(res => { currentPbom.value = res.data || null })
}
function handleRoutingChange(id) {
  currentRoutingDetail.value = null
  if (id) routingApi.detail(id).then(res => { currentRoutingDetail.value = res.data || null })
}
function fillMaterial(id) { const m = materialOptions.value.find(x => x.materialId === id); if (m && !itemForm.value.quantity) itemForm.value.quantity = 1 }
function nextSeq(rows) { return ((rows || []).length + 1) * 10 }
function flattenItems(rows) { return (rows || []).flatMap(row => [row, ...flattenItems(row.children)]) }
function masterRowClassName({ row }) { return currentMbom.value?.mbomId === row.mbomId ? 'is-current-mbom' : '' }
function buildMbomStructure(rows) {
  const operationMap = new Map()
  ;(rows || []).forEach(item => {
    const operation = getOperationMeta(item)
    const step = getStepMeta(item)
    if (!operationMap.has(operation.key)) {
      operationMap.set(operation.key, { ...operation, steps: new Map(), itemCount: 0 })
    }
    const operationGroup = operationMap.get(operation.key)
    if (!operationGroup.steps.has(step.key)) {
      operationGroup.steps.set(step.key, { ...step, operationId: operation.operationId, items: [] })
    }
    operationGroup.steps.get(step.key).items.push(item)
    operationGroup.itemCount += 1
  })
  return Array.from(operationMap.values()).map(operation => ({
    ...operation,
    steps: Array.from(operation.steps.values())
      .map(step => ({ ...step, items: step.items.sort(sortBySeq) }))
      .sort(sortStepGroup)
  })).sort(sortOperationGroup)
}
function getOperationMeta(item) {
  const option = operationOptions.value.find(o => o.operationId === item.operationId)
  const key = item.operationId || 'operation-empty'
  return {
    key,
    operationId: item.operationId,
    code: item.operationCode || option?.operationCode || '未指定工序',
    name: option?.operationName || (item.operationId ? '工序名称未维护' : '未指定工序'),
    seq: option?.operationSeq || 999999
  }
}
function getStepMeta(item) {
  const option = stepOptions.value.find(s => s.stepId === item.stepId)
  const key = item.stepId || `step-empty-${item.operationId || 'none'}`
  return {
    key,
    stepId: item.stepId,
    code: item.stepCode || option?.stepCode || '未指定工步',
    name: option?.stepName || (item.stepId ? '工步名称未维护' : '未指定工步'),
    seq: option?.stepSeq || 999999
  }
}
function sortBySeq(a, b) { return (a.itemSeq || 0) - (b.itemSeq || 0) }
function sortOperationGroup(a, b) { return (a.seq || 0) - (b.seq || 0) || String(a.code).localeCompare(String(b.code)) }
function sortStepGroup(a, b) { return (a.seq || 0) - (b.seq || 0) || String(a.code).localeCompare(String(b.code)) }
loadOptions(); getList()
</script>

<style scoped>
.mbom-page {
  padding: 14px 18px 18px;
  background: #f6f8fb;
  min-height: calc(100vh - 84px);
}

.mbom-query {
  background: #fff;
  border: 1px solid #e5eaf3;
  border-radius: 6px;
  padding: 14px 16px 0;
  margin-bottom: 12px;
}

.mbom-query :deep(.el-form-item) {
  margin-bottom: 14px;
}

.mbom-query :deep(.el-input),
.mbom-query :deep(.el-select) {
  width: 200px;
}

.query-actions :deep(.el-form-item__content) {
  gap: 8px;
}

.mbom-workbench {
  display: grid;
  grid-template-columns: minmax(520px, 0.48fr) minmax(620px, 0.52fr);
  gap: 12px;
  align-items: start;
}

.mbom-panel {
  min-width: 0;
  background: #fff;
  border: 1px solid #e5eaf3;
  border-radius: 6px;
  overflow: hidden;
}

.panel-head,
.detail-hero {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 16px;
  border-bottom: 1px solid #e8edf5;
  background: linear-gradient(180deg, #ffffff 0%, #f8fbff 100%);
}

.detail-hero {
  align-items: flex-start;
}

.detail-hero.is-empty {
  align-items: center;
}

.panel-title {
  color: #1f2d3d;
  font-size: 16px;
  font-weight: 700;
  line-height: 22px;
}

.panel-subtitle {
  margin-top: 4px;
  color: #7a8699;
  font-size: 12px;
  line-height: 18px;
}

.panel-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
  flex-wrap: wrap;
}

.detail-stats {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-left: auto;
  color: #5f6f89;
  font-size: 12px;
  white-space: nowrap;
}

.detail-stats span {
  display: inline-flex;
  align-items: center;
  height: 24px;
  padding: 0 9px;
  border: 1px solid #dce7f5;
  border-radius: 4px;
  background: #f4f8fd;
}

.mbom-table {
  --el-table-header-bg-color: #f5f7fb;
  --el-table-row-hover-bg-color: #eef6ff;
}

.mbom-table :deep(.el-table__header th) {
  color: #25364d;
  font-weight: 700;
}

.mbom-table :deep(.el-table__row) {
  cursor: pointer;
}

.mbom-table :deep(.is-current-mbom td) {
  background: #eaf4ff !important;
}

.mbom-code {
  color: #1682ff;
  font-weight: 700;
  line-height: 20px;
}

.mbom-name,
.product-name {
  color: #303b4f;
  line-height: 20px;
}

.muted-text {
  color: #8a96a8;
  font-size: 12px;
}

.seq-pill {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 32px;
  height: 24px;
  padding: 0 8px;
  border-radius: 4px;
  color: #42526e;
  background: #eef3fa;
  font-weight: 700;
}

.qty-text {
  color: #24364f;
  font-weight: 700;
}

.unit-text {
  margin-left: 4px;
}

.detail-empty {
  height: calc(100vh - 330px);
}

.mbom-structure {
  height: calc(100vh - 330px);
  padding: 12px;
  overflow: auto;
  background: #f8fafd;
}

.operation-card {
  border: 1px solid #dce8f7;
  border-radius: 6px;
  background: #fff;
  overflow: hidden;
}

.operation-card + .operation-card {
  margin-top: 12px;
}

.operation-head {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 14px;
  background: #eef6ff;
  border-bottom: 1px solid #dce8f7;
}

.level-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 24px;
  padding: 0 8px;
  border-radius: 4px;
  color: #0f66c2;
  background: #dbeeff;
  border: 1px solid #aed4ff;
  font-size: 12px;
  font-weight: 700;
  white-space: nowrap;
}

.operation-main {
  min-width: 0;
  flex: 1;
}

.operation-code {
  color: #15395f;
  font-size: 15px;
  font-weight: 700;
  line-height: 20px;
}

.operation-name {
  color: #64748b;
  font-size: 12px;
  line-height: 18px;
}

.operation-meta {
  color: #52657f;
  font-size: 12px;
  white-space: nowrap;
}

.step-block {
  margin: 12px;
  border: 1px solid #e6ebf3;
  border-radius: 6px;
  overflow: hidden;
  background: #fff;
}

.step-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  min-height: 42px;
  padding: 8px 12px;
  background: #fbfcfe;
  border-bottom: 1px solid #edf1f6;
}

.step-title {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 0;
}

.step-badge {
  color: #1d7f45;
  background: #e7f7ed;
  border-color: #bde8cb;
}

.step-code {
  color: #1682ff;
  font-weight: 700;
}

.step-name {
  color: #303b4f;
}

.feed-table :deep(.el-table__header th) {
  background: #f7f9fc !important;
}

.feed-table :deep(.el-table__cell) {
  padding: 7px 0;
}

.mbom-table :deep(.action-column .cell) {
  white-space: nowrap;
}

.table-actions {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  width: 100%;
  white-space: nowrap;
}

.table-actions :deep(.el-button) {
  margin-left: 0;
  padding-left: 0;
  padding-right: 0;
}

.mbom-create-dialog :deep(.el-dialog__body) {
  max-height: 72vh;
  overflow: auto;
}

.create-basic {
  border: 1px solid #e5eaf3;
  border-radius: 6px;
  padding: 12px 14px 0;
  background: #fbfdff;
}

.create-basic :deep(.el-select),
.create-basic :deep(.el-input),
.create-basic :deep(.el-date-editor) {
  width: 100%;
}

.create-section-title {
  color: #1f2d3d;
  font-size: 14px;
  font-weight: 700;
  line-height: 22px;
  margin-bottom: 12px;
}

.generate-workbench {
  display: grid;
  grid-template-columns: minmax(420px, 0.38fr) minmax(620px, 0.62fr);
  gap: 14px;
  margin-top: 14px;
}

.generate-left,
.generate-right {
  min-width: 0;
  border: 1px solid #e5eaf3;
  border-radius: 6px;
  padding: 12px;
  background: #fff;
}

.generate-right :deep(.el-tabs__header) {
  margin-bottom: 8px;
}

@media (max-width: 1360px) {
  .mbom-workbench {
    grid-template-columns: 1fr;
  }

  .mbom-table,
  .detail-empty,
  .mbom-structure {
    height: auto !important;
  }

  .generate-workbench {
    grid-template-columns: 1fr;
  }
}
</style>
