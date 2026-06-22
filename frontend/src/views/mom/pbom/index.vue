<template>
  <div class="app-container pbom-page">
    <div class="pbom-query">
      <el-form :model="queryParams" ref="queryRef" :inline="true">
        <el-form-item label="PBOM编码" prop="pbomCode">
          <el-input v-model="queryParams.pbomCode" placeholder="输入编码" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item label="PBOM名称" prop="pbomName">
          <el-input v-model="queryParams.pbomName" placeholder="输入名称" clearable @keyup.enter="handleQuery" />
        </el-form-item>
        <el-form-item class="query-actions">
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="pbom-workbench">
      <section class="pbom-panel master-panel">
        <div class="panel-head">
          <div>
            <div class="panel-title">PBOM清单</div>
            <div class="panel-subtitle">维护成品物料的设计 BOM</div>
          </div>
          <div class="panel-actions">
            <el-button type="primary" plain icon="Plus" @click="openForm()" v-hasPermi="['mom:pbom:add']">新增</el-button>
            <el-button type="success" plain icon="Edit" :disabled="single" @click="openForm(selection[0])" v-hasPermi="['mom:pbom:edit']">修改</el-button>
            <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="remove(selection.map(i => i.pbomId).join(','))" v-hasPermi="['mom:pbom:remove']">删除</el-button>
            <el-button type="info" plain icon="Upload" @click="handleImport" v-hasPermi="['mom:pbom:add']">导入</el-button>
            <el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:pbom:export']">导出</el-button>
          </div>
        </div>

        <el-table
          v-loading="loading"
          :data="rows"
          height="calc(100vh - 330px)"
          highlight-current-row
          class="pbom-table"
          :row-class-name="masterRowClassName"
          @selection-change="selection = $event"
          @row-click="selectPbom"
        >
          <el-table-column type="selection" width="42" />
          <el-table-column label="PBOM信息" min-width="260">
            <template #default="scope">
              <div class="pbom-code">{{ scope.row.pbomCode }}</div>
              <div class="pbom-name">{{ scope.row.pbomName }}</div>
            </template>
          </el-table-column>
          <el-table-column label="成品物料" min-width="180">
            <template #default="scope">
              <div class="product-name">{{ scope.row.productName }}</div>
              <div class="muted-text">版本 {{ scope.row.version || '-' }}</div>
            </template>
          </el-table-column>
          <el-table-column label="状态" width="86" align="center">
            <template #default="scope"><el-tag size="small" :type="String(scope.row.status) === '0' ? 'success' : 'info'">{{ String(scope.row.status) === '0' ? '正常' : '停用' }}</el-tag></template>
          </el-table-column>
          <el-table-column label="操作" width="150" fixed="right" align="center" class-name="action-column">
            <template #default="scope">
              <div class="table-actions">
                <el-button link type="primary" icon="Edit" @click.stop="openForm(scope.row)" v-hasPermi="['mom:pbom:edit']">修改</el-button>
                <el-button link type="danger" icon="Delete" @click.stop="remove(scope.row.pbomId)" v-hasPermi="['mom:pbom:remove']">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
      </section>

      <section class="pbom-panel detail-panel">
        <div class="detail-hero" :class="{ 'is-empty': !current }">
          <div>
            <div class="panel-title">{{ current ? current.pbomCode : 'PBOM明细' }}</div>
            <div class="panel-subtitle">{{ current ? `${current.pbomName || '-'} / ${current.productName || '-'}` : '请先在左侧选择一条 PBOM' }}</div>
          </div>
          <div class="detail-stats" v-if="current">
            <span>版本 {{ current.version || '-' }}</span>
            <span>{{ items.length }} 项物料</span>
            <el-tag size="small" :type="String(current.status) === '0' ? 'success' : 'info'">{{ String(current.status) === '0' ? '正常' : '停用' }}</el-tag>
          </div>
          <div class="panel-actions">
            <el-button type="primary" plain icon="Plus" :disabled="!current" @click="openItem()" v-hasPermi="['mom:pbom:add']">新增明细</el-button>
          </div>
        </div>

        <el-empty v-if="!current" class="detail-empty" description="选择 PBOM 后维护物料、数量和投料工位" />
        <div v-else class="pbom-detail-body">
          <div class="summary-strip">
            <div class="summary-item">
              <span class="summary-label">成品编码</span>
              <strong>{{ current.productCode || '-' }}</strong>
            </div>
            <div class="summary-item">
              <span class="summary-label">成品名称</span>
              <strong>{{ current.productName || '-' }}</strong>
            </div>
            <div class="summary-item">
              <span class="summary-label">明细数量</span>
              <strong>{{ items.length }}</strong>
            </div>
            <div class="summary-item">
              <span class="summary-label">涉及工位</span>
              <strong>{{ resourceCount }}</strong>
            </div>
          </div>

          <el-table :data="items" height="calc(100vh - 410px)" class="pbom-table detail-table">
            <el-table-column label="行号" prop="itemSeq" width="74" align="center">
              <template #default="scope"><span class="seq-pill">{{ scope.row.itemSeq }}</span></template>
            </el-table-column>
            <el-table-column label="物料" min-width="240">
              <template #default="scope">
                <div class="pbom-code">{{ scope.row.materialCode }}</div>
                <div class="pbom-name">{{ scope.row.materialName }}</div>
              </template>
            </el-table-column>
            <el-table-column label="规格型号" prop="specModel" min-width="130" show-overflow-tooltip />
            <el-table-column label="工位" min-width="160">
              <template #default="scope">
                <el-tag v-if="scope.row.resourceCode" size="small" effect="plain">{{ scope.row.resourceCode }}</el-tag>
                <span class="muted-text resource-name">{{ scope.row.resourceName || '' }}</span>
              </template>
            </el-table-column>
            <el-table-column label="数量" width="110" align="right">
              <template #default="scope"><span class="qty-text">{{ scope.row.quantity }}</span><span class="muted-text unit-text">{{ scope.row.unit }}</span></template>
            </el-table-column>
            <el-table-column label="状态" width="86" align="center">
              <template #default="scope"><el-tag size="small" :type="String(scope.row.status) === '0' ? 'success' : 'info'">{{ String(scope.row.status) === '0' ? '正常' : '停用' }}</el-tag></template>
            </el-table-column>
            <el-table-column label="备注" prop="remark" min-width="140" show-overflow-tooltip />
            <el-table-column label="操作" width="150" align="center" fixed="right" class-name="action-column">
              <template #default="scope">
                <div class="table-actions">
                  <el-button link type="primary" icon="Edit" @click="openItem(scope.row)" v-hasPermi="['mom:pbom:edit']">编辑</el-button>
                  <el-button link type="danger" icon="Delete" @click="removeItem(scope.row.itemId)" v-hasPermi="['mom:pbom:remove']">删除</el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </section>
    </div>

    <el-dialog v-model="open" :title="form.pbomId ? '修改PBOM' : '新增PBOM'" :width="form.pbomId ? '620px' : '1080px'" append-to-body class="pbom-form-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="96px">
        <div class="dialog-section">
          <div class="dialog-section-title">基本信息</div>
          <el-row :gutter="16">
            <el-col :span="12"><el-form-item label="PBOM编码" prop="pbomCode"><el-input v-model="form.pbomCode" placeholder="留空时自动生成" /></el-form-item></el-col>
            <el-col :span="12"><el-form-item label="PBOM名称" prop="pbomName"><el-input v-model="form.pbomName" placeholder="请输入 PBOM 名称" /></el-form-item></el-col>
            <el-col :span="12">
              <el-form-item label="成品物料" prop="productId">
                <el-select v-model="form.productId" filterable placeholder="请选择成品物料">
                  <el-option v-for="p in products" :key="p.productId" :label="`${p.productCode || ''} ${p.productName}`" :value="p.productId" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="6"><el-form-item label="版本" prop="version"><el-input v-model="form.version" /></el-form-item></el-col>
            <el-col :span="6">
              <el-form-item label="状态" prop="status">
                <el-radio-group v-model="form.status">
                  <el-radio label="0">正常</el-radio>
                  <el-radio label="1">停用</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="24"><el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" :rows="2" /></el-form-item></el-col>
          </el-row>
        </div>

        <div v-if="!form.pbomId" class="dialog-section detail-editor">
          <div class="dialog-section-head">
            <div>
              <div class="dialog-section-title">PBOM明细物料</div>
              <div class="dialog-section-subtitle">保存 PBOM 时同步创建这些明细，工位会用于后续 MBOM 自动投料绑定</div>
            </div>
            <el-button type="primary" plain icon="Plus" @click="addDraftItem">新增明细</el-button>
          </div>
          <el-table :data="draftItems" size="small" max-height="280" class="pbom-table draft-table">
            <el-table-column label="行号" width="110" align="center">
              <template #default="scope"><el-input-number v-model="scope.row.itemSeq" :min="1" :step="10" controls-position="right" /></template>
            </el-table-column>
            <el-table-column label="物料" min-width="240">
              <template #default="scope">
                <el-select v-model="scope.row.materialId" filterable placeholder="请选择物料" @change="handleDraftMaterialChange(scope.row)">
                  <el-option v-for="m in materials" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="投料工位" min-width="220">
              <template #default="scope">
                <el-select v-model="scope.row.resourceId" filterable placeholder="请选择工位">
                  <el-option v-for="r in stations" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="数量" width="130" align="center">
              <template #default="scope"><el-input-number v-model="scope.row.quantity" :min="0.001" :precision="3" controls-position="right" /></template>
            </el-table-column>
            <el-table-column label="备注" min-width="180">
              <template #default="scope"><el-input v-model="scope.row.remark" placeholder="投料说明" /></template>
            </el-table-column>
            <el-table-column label="操作" width="90" align="center" class-name="action-column">
              <template #default="scope"><div class="table-actions is-single"><el-button link type="danger" icon="Delete" @click="removeDraftItem(scope.$index)">删除</el-button></div></template>
            </el-table-column>
          </el-table>
          <el-empty v-if="!draftItems.length" description="可先保存 PBOM，也可以在这里直接维护明细物料" :image-size="70" />
        </div>
      </el-form>
      <template #footer>
        <el-button @click="open = false">取消</el-button>
        <el-button type="primary" @click="submit">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="itemOpen" :title="itemForm.itemId ? '修改PBOM明细' : '新增PBOM明细'" width="640px" append-to-body>
      <el-form ref="itemRef" :model="itemForm" :rules="itemRules" label-width="96px">
        <el-form-item label="物料" prop="materialId">
          <el-select v-model="itemForm.materialId" filterable placeholder="请选择物料" @change="handleMaterialChange">
            <el-option v-for="m in materials" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" />
          </el-select>
        </el-form-item>
        <el-form-item label="投料工位" prop="resourceId">
          <el-select v-model="itemForm.resourceId" filterable placeholder="请选择工位">
            <el-option v-for="r in stations" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" />
          </el-select>
        </el-form-item>
        <el-row :gutter="16">
          <el-col :span="12"><el-form-item label="行号" prop="itemSeq"><el-input-number v-model="itemForm.itemSeq" :min="1" :step="10" controls-position="right" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="数量" prop="quantity"><el-input-number v-model="itemForm.quantity" :min="0.001" :precision="3" controls-position="right" /></el-form-item></el-col>
        </el-row>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="itemForm.status">
            <el-radio label="0">正常</el-radio>
            <el-radio label="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="itemForm.remark" placeholder="可填写替代、损耗或投料说明" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="itemOpen = false">取消</el-button>
        <el-button type="primary" @click="submitItem">确定</el-button>
      </template>
    </el-dialog>

    <excel-import-dialog ref="importPbomRef" title="PBOM导入" :action="pbomApi.importUrl" :template-action="pbomApi.importTemplateUrl" template-file-name="pbom_import_template" update-support-label="是否更新已存在的PBOM并重建明细" @success="handleImportSuccess" />
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import ExcelImportDialog from '@/components/ExcelImportDialog'
import { pbomApi } from '@/api/mom/console'
import { productApi, materialApi, resourceApi } from '@/api/mom/base'

const { proxy } = getCurrentInstance()
const loading = ref(false)
const rows = ref([])
const total = ref(0)
const selection = ref([])
const current = ref(null)
const items = ref([])
const open = ref(false)
const itemOpen = ref(false)
const products = ref([])
const materials = ref([])
const stations = ref([])
const draftItems = ref([])
const queryParams = reactive({ pageNum: 1, pageSize: 10, pbomCode: '', pbomName: '' })
const form = reactive({})
const itemForm = reactive({})
const rules = {
  pbomName: [{ required: true, message: 'PBOM名称不能为空', trigger: 'blur' }],
  productId: [{ required: true, message: '成品物料不能为空', trigger: 'change' }],
  version: [{ required: true, message: '版本不能为空', trigger: 'blur' }]
}
const itemRules = {
  materialId: [{ required: true, message: '物料不能为空', trigger: 'change' }],
  resourceId: [{ required: true, message: '投料工位不能为空', trigger: 'change' }],
  itemSeq: [{ required: true, message: '行号不能为空', trigger: 'blur' }],
  quantity: [{ required: true, message: '数量不能为空', trigger: 'blur' }]
}
const single = computed(() => selection.value.length !== 1)
const multiple = computed(() => selection.value.length === 0)
const resourceCount = computed(() => new Set(items.value.filter(i => i.resourceId).map(i => i.resourceId)).size)

function getList() {
  loading.value = true
  pbomApi.list(queryParams).then(res => {
    rows.value = res.rows || []
    total.value = res.total || 0
    if (!current.value && rows.value.length) selectPbom(rows.value[0])
  }).finally(() => loading.value = false)
}

function handleQuery() {
  queryParams.pageNum = 1
  current.value = null
  items.value = []
  getList()
}

function resetQuery() {
  Object.assign(queryParams, { pageNum: 1, pbomCode: '', pbomName: '' })
  handleQuery()
}

function resetForm() {
  Object.keys(form).forEach(key => delete form[key])
  Object.assign(form, { status: '0', version: 'V1' })
  draftItems.value = []
}

function openForm(row) {
  resetForm()
  Object.assign(form, row || {})
  if (!row) addDraftItem()
  open.value = true
  nextTick(() => proxy.resetForm('formRef'))
}

function submit() {
  proxy.$refs.formRef.validate(valid => {
    if (!valid) return
    if (!form.pbomId && draftItems.value.length) {
      const message = validateDraftItems()
      if (message) {
        ElMessage.warning(message)
        return
      }
    }
    const api = form.pbomId ? pbomApi.update : pbomApi.add
    api(form).then(res => {
      if (form.pbomId || !draftItems.value.length) {
        ElMessage.success('保存成功')
        open.value = false
        getList()
        return
      }
      const pbomId = form.pbomId || findCreatedPbomId(res)
      if (pbomId) {
        saveDraftItems(pbomId).then(() => finishCreateWithItems(pbomId))
      } else {
        pbomApi.list({ pageNum: 1, pageSize: 10, pbomCode: form.pbomCode }).then(res => {
          const created = (res.rows || []).find(row => row.pbomCode === form.pbomCode)
          if (!created?.pbomId) {
            ElMessage.warning('PBOM已保存，但未获取到PBOM ID，请在右侧明细区继续维护物料')
            open.value = false
            getList()
            return
          }
          saveDraftItems(created.pbomId).then(() => finishCreateWithItems(created.pbomId))
        })
      }
    })
  })
}

function findCreatedPbomId(res) {
  return res?.data?.pbomId || res?.data?.data?.pbomId || form.pbomId
}

function finishCreateWithItems(pbomId) {
  ElMessage.success('保存成功')
  open.value = false
  getList()
  pbomApi.get(pbomId).then(res => {
    if (res.data) selectPbom(res.data)
  })
}

function addDraftItem() {
  const nextSeq = draftItems.value.length ? Math.max(...draftItems.value.map(i => Number(i.itemSeq) || 0)) + 10 : 10
  draftItems.value.push({
    localId: Date.now() + Math.random(),
    parentItemId: 0,
    itemSeq: nextSeq,
    quantity: 1,
    status: '0',
    materialId: undefined,
    resourceId: undefined,
    remark: undefined
  })
}

function removeDraftItem(index) {
  draftItems.value.splice(index, 1)
}

function handleDraftMaterialChange(row) {
  const material = materials.value.find(i => i.materialId === row.materialId)
  if (material && !row.remark) row.remark = material.materialName
}

function validateDraftItems() {
  for (let index = 0; index < draftItems.value.length; index++) {
    const row = draftItems.value[index]
    const rowNo = index + 1
    if (!row.materialId) return `第 ${rowNo} 行明细未选择物料`
    if (!row.resourceId) return `第 ${rowNo} 行明细未选择投料工位`
    if (!row.itemSeq) return `第 ${rowNo} 行明细未填写行号`
    if (!row.quantity || Number(row.quantity) <= 0) return `第 ${rowNo} 行明细数量必须大于 0`
  }
  return ''
}

function saveDraftItems(pbomId) {
  const message = validateDraftItems()
  if (message) {
    ElMessage.warning(message)
    return Promise.reject(new Error(message))
  }
  return Promise.all(draftItems.value.map(row => pbomApi.addItem({
    pbomId,
    parentItemId: 0,
    materialId: row.materialId,
    resourceId: row.resourceId,
    itemSeq: row.itemSeq,
    quantity: row.quantity,
    status: row.status || '0',
    remark: row.remark
  })))
}

function remove(ids) {
  ElMessageBox.confirm('确认删除选中的PBOM？').then(() => pbomApi.remove(ids).then(() => {
    ElMessage.success('删除成功')
    current.value = null
    items.value = []
    getList()
  }))
}

function selectPbom(row) {
  current.value = row
  pbomApi.items(row.pbomId).then(res => { items.value = res.data || [] })
}

function resetItemForm() {
  Object.keys(itemForm).forEach(key => delete itemForm[key])
  const nextSeq = items.value.length ? Math.max(...items.value.map(i => Number(i.itemSeq) || 0)) + 10 : 10
  Object.assign(itemForm, { pbomId: current.value?.pbomId, parentItemId: 0, itemSeq: nextSeq, quantity: 1, status: '0' })
}

function openItem(row) {
  if (!current.value) return
  resetItemForm()
  Object.assign(itemForm, row || {})
  itemOpen.value = true
  nextTick(() => proxy.resetForm('itemRef'))
}

function handleMaterialChange(materialId) {
  const material = materials.value.find(i => i.materialId === materialId)
  if (material && !itemForm.remark) itemForm.remark = material.materialName
}

function submitItem() {
  proxy.$refs.itemRef.validate(valid => {
    if (!valid) return
    const api = itemForm.itemId ? pbomApi.updateItem : pbomApi.addItem
    api(itemForm).then(() => {
      ElMessage.success('保存成功')
      itemOpen.value = false
      selectPbom(current.value)
    })
  })
}

function removeItem(id) {
  ElMessageBox.confirm('确认删除该PBOM明细？').then(() => pbomApi.removeItem(id).then(() => {
    ElMessage.success('删除成功')
    selectPbom(current.value)
  }))
}

function handleImport() { proxy.$refs.importPbomRef.open() }
function handleImportSuccess() { current.value = null; items.value = []; getList() }
function handleExport() { proxy.download(pbomApi.exportUrl, { ...queryParams }, `pbom_${new Date().getTime()}.csv`) }
function masterRowClassName({ row }) { return current.value?.pbomId === row.pbomId ? 'current-master-row' : '' }

onMounted(() => {
  getList()
  productApi.options().then(res => { products.value = res.data || [] })
  materialApi.options().then(res => { materials.value = res.data || [] })
  resourceApi.options().then(res => { stations.value = (res.data || []).filter(i => i.resourceType === 'station') })
})
</script>

<style scoped>
.pbom-page {
  background: #f6f8fb;
  min-height: calc(100vh - 84px);
}

.pbom-query {
  padding: 14px 16px 0;
  background: #fff;
  border: 1px solid #e7ecf3;
  border-radius: 6px;
  margin-bottom: 12px;
}

.pbom-workbench {
  display: grid;
  grid-template-columns: minmax(520px, 0.9fr) minmax(620px, 1.1fr);
  gap: 12px;
  min-height: calc(100vh - 220px);
}

.pbom-panel {
  background: #fff;
  border: 1px solid #e7ecf3;
  border-radius: 6px;
  overflow: hidden;
}

.panel-head,
.detail-hero {
  min-height: 64px;
  padding: 14px 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  border-bottom: 1px solid #edf1f6;
}

.detail-hero {
  background: linear-gradient(180deg, #f9fbff 0%, #fff 100%);
}

.detail-hero.is-empty {
  background: #fff;
}

.panel-title {
  font-size: 16px;
  font-weight: 700;
  color: #1f2d3d;
  line-height: 24px;
}

.panel-subtitle,
.muted-text {
  color: #8492a6;
  font-size: 12px;
}

.panel-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.detail-stats {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #5f6f86;
}

.pbom-table :deep(.current-master-row td) {
  background: #eaf4ff !important;
}

.pbom-table :deep(.action-column .cell) {
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

.table-actions.is-single {
  gap: 0;
}

.table-actions :deep(.el-button) {
  margin-left: 0;
  padding-left: 0;
  padding-right: 0;
}

.pbom-code {
  font-weight: 700;
  color: #2478ff;
  line-height: 22px;
}

.pbom-name,
.product-name {
  color: #314057;
  line-height: 22px;
}

.detail-empty {
  height: calc(100vh - 320px);
}

.pbom-detail-body {
  padding: 14px 16px 16px;
}

.summary-strip {
  display: grid;
  grid-template-columns: repeat(4, minmax(120px, 1fr));
  gap: 10px;
  margin-bottom: 12px;
}

.summary-item {
  border: 1px solid #e8eef6;
  border-radius: 6px;
  padding: 10px 12px;
  background: #fbfdff;
}

.summary-label {
  display: block;
  color: #8492a6;
  font-size: 12px;
  margin-bottom: 4px;
}

.summary-item strong {
  display: block;
  color: #1f2d3d;
  font-size: 14px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.seq-pill {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 34px;
  height: 24px;
  padding: 0 8px;
  border-radius: 4px;
  color: #2b6cb0;
  background: #edf6ff;
  font-weight: 700;
}

.qty-text {
  font-weight: 700;
  color: #1f2d3d;
}

.unit-text,
.resource-name {
  margin-left: 6px;
}

.dialog-section {
  border: 1px solid #e8eef6;
  border-radius: 6px;
  padding: 14px 16px 4px;
  background: #fbfdff;
}

.dialog-section + .dialog-section {
  margin-top: 12px;
}

.dialog-section-title {
  font-size: 15px;
  font-weight: 700;
  color: #1f2d3d;
  margin-bottom: 12px;
}

.dialog-section-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.dialog-section-head .dialog-section-title {
  margin-bottom: 2px;
}

.dialog-section-subtitle {
  color: #8492a6;
  font-size: 12px;
  line-height: 18px;
}

.detail-editor {
  padding-bottom: 14px;
}

.draft-table :deep(.el-input-number) {
  width: 100%;
}

.draft-table :deep(.el-select) {
  width: 100%;
}

@media (max-width: 1360px) {
  .pbom-workbench {
    grid-template-columns: 1fr;
  }

  .pbom-table {
    height: auto;
  }
}
</style>
