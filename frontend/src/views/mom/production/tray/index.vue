<template>
  <div class="app-container tray-page">
    <el-form v-show="showSearch" :model="queryParams" ref="queryRef" inline class="search-bar">
      <el-form-item label="托盘编码" prop="trayCode">
        <el-input v-model="queryParams.trayCode" placeholder="请输入托盘编码" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="托盘名称" prop="trayName">
        <el-input v-model="queryParams.trayName" placeholder="请输入托盘名称" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="所属工位" prop="resourceId">
        <el-select v-model="queryParams.resourceId" placeholder="请选择工位" clearable filterable>
          <el-option v-for="r in resources" :key="r.resourceId" :label="`${r.resourceCode || ''} ${r.resourceName || ''}`" :value="r.resourceId" />
        </el-select>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable>
          <el-option label="正常" value="0" />
          <el-option label="停用" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="12" class="toolbar-row">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="openTray()" v-hasPermi="['mom:tray:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="!current" @click="openTray(current)" v-hasPermi="['mom:tray:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="!current" @click="removeTray(current?.trayId)" v-hasPermi="['mom:tray:remove']">删除</el-button></el-col>
      <el-col :span="1.5"><el-button type="info" plain icon="Upload" @click="handleImport" v-hasPermi="['mom:tray:add']">导入</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:tray:export']">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="loadTrays" />
    </el-row>

    <div class="tray-layout">
      <section class="tray-panel">
        <div class="panel-head">
          <div>
            <h3>形迹托盘</h3>
            <p>选择一条托盘后维护右侧物料明细</p>
          </div>
        </div>
        <el-table :data="trays" v-loading="loading" height="520" highlight-current-row @row-click="selectTray">
          <el-table-column type="selection" width="42" />
          <el-table-column label="托盘信息" min-width="220">
            <template #default="scope">
              <div class="main-code">{{ scope.row.trayCode }}</div>
              <div class="sub-text">{{ scope.row.trayName || '-' }}</div>
            </template>
          </el-table-column>
          <el-table-column label="工位" min-width="130">
            <template #default="scope">
              <el-tag v-if="scope.row.resourceName" effect="plain">{{ scope.row.resourceName }}</el-tag>
              <span v-else class="sub-text">未绑定</span>
            </template>
          </el-table-column>
          <el-table-column label="状态" width="90">
            <template #default="scope">
              <el-tag :type="scope.row.status === '0' ? 'success' : 'info'" effect="light">{{ scope.row.status === '0' ? '正常' : '停用' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="132" fixed="right">
            <template #default="scope">
              <div class="nowrap-actions">
                <el-button link type="primary" icon="Edit" @click.stop="openTray(scope.row)">编辑</el-button>
                <el-button link type="danger" icon="Delete" @click.stop="removeTray(scope.row.trayId)">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="loadTrays" />
      </section>

      <section class="tray-panel detail-panel">
        <div class="panel-head">
          <div>
            <h3>{{ current?.trayCode || '请选择托盘' }} 托盘物料</h3>
            <p>{{ current?.trayName || '左侧选择托盘后展示并维护物料明细' }}</p>
          </div>
          <el-button type="primary" plain icon="Plus" :disabled="!current" @click="openItem()" v-hasPermi="['mom:tray:add']">新增物料</el-button>
        </div>
        <el-table :data="items" height="520" empty-text="请选择托盘或维护托盘物料">
          <el-table-column prop="locationCode" label="托盘位" width="110" />
          <el-table-column label="物料" min-width="240">
            <template #default="scope">
              <div class="main-code">{{ scope.row.materialCode }}</div>
              <div class="sub-text">{{ scope.row.materialName }}</div>
            </template>
          </el-table-column>
          <el-table-column prop="quantity" label="数量" width="110" />
          <el-table-column label="操作" width="132" fixed="right">
            <template #default="scope">
              <div class="nowrap-actions">
                <el-button link type="primary" icon="Edit" @click="openItem(scope.row)">编辑</el-button>
                <el-button link type="danger" icon="Delete" @click="removeItem(scope.row.itemId)">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </section>
    </div>

    <el-dialog v-model="trayOpen" :title="trayForm.trayId ? '编辑形迹托盘' : '新增形迹托盘'" width="960px" append-to-body>
      <el-form ref="trayRef" :model="trayForm" :rules="trayRules" label-width="96px">
        <div class="form-section">
          <div class="section-title">基本信息</div>
          <el-row :gutter="16">
            <el-col :span="12">
              <el-form-item label="托盘编码" prop="trayCode"><el-input v-model="trayForm.trayCode" placeholder="请输入托盘编码" /></el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="托盘名称" prop="trayName"><el-input v-model="trayForm.trayName" placeholder="请输入托盘名称" /></el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="所属工位" prop="resourceId">
                <el-select v-model="trayForm.resourceId" placeholder="请选择工位" filterable clearable>
                  <el-option v-for="r in resources" :key="r.resourceId" :label="`${r.resourceCode || ''} ${r.resourceName || ''}`" :value="r.resourceId" />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="状态" prop="status">
                <el-radio-group v-model="trayForm.status"><el-radio label="0">正常</el-radio><el-radio label="1">停用</el-radio></el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="备注"><el-input v-model="trayForm.remark" type="textarea" placeholder="请输入备注" /></el-form-item>
            </el-col>
          </el-row>
        </div>

        <div class="form-section">
          <div class="section-title">
            <span>托盘物料明细</span>
            <el-button type="primary" plain icon="Plus" @click="addFormItem">新增明细</el-button>
          </div>
          <el-table :data="trayItemsForm" border>
            <el-table-column label="托盘位" width="140">
              <template #default="scope"><el-input v-model="scope.row.locationCode" placeholder="如 P01" /></template>
            </el-table-column>
            <el-table-column label="物料" min-width="260">
              <template #default="scope">
                <el-select v-model="scope.row.materialId" placeholder="请选择物料" filterable clearable>
                  <el-option v-for="m in materials" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="数量" width="150">
              <template #default="scope"><el-input-number v-model="scope.row.quantity" :min="0" :precision="3" controls-position="right" /></template>
            </el-table-column>
            <el-table-column label="备注" min-width="160">
              <template #default="scope"><el-input v-model="scope.row.remark" placeholder="备注" /></template>
            </el-table-column>
            <el-table-column label="操作" width="90">
              <template #default="scope">
                <el-button link type="danger" icon="Delete" @click="removeFormItem(scope.$index)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-form>
      <template #footer>
        <el-button @click="trayOpen = false">取消</el-button>
        <el-button type="primary" @click="submitTray">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="itemOpen" title="托盘物料" width="520px" append-to-body>
      <el-form :model="itemForm" label-width="96px">
        <el-form-item label="物料"><el-select v-model="itemForm.materialId" filterable><el-option v-for="m in materials" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" /></el-select></el-form-item>
        <el-form-item label="托盘位"><el-input v-model="itemForm.locationCode" /></el-form-item>
        <el-form-item label="数量"><el-input-number v-model="itemForm.quantity" :min="0" :precision="3" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="itemForm.remark" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="itemOpen=false">取消</el-button><el-button type="primary" @click="submitItem">确定</el-button></template>
    </el-dialog>

    <excel-import-dialog ref="importTrayRef" title="形迹托盘导入" :action="trayApi.importUrl" :template-action="trayApi.importTemplateUrl" template-file-name="tray_import_template" update-support-label="是否更新已存在的托盘并重建明细" @success="handleImportSuccess" />
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import { trayApi } from '@/api/mom/console'
import { resourceApi, materialApi } from '@/api/mom/base'

const { proxy } = getCurrentInstance()
const loading = ref(false)
const showSearch = ref(true)
const trays = ref([])
const items = ref([])
const total = ref(0)
const current = ref(null)
const resources = ref([])
const materials = ref([])
const trayOpen = ref(false)
const itemOpen = ref(false)
const trayItemsForm = ref([])
const queryParams = reactive({ pageNum: 1, pageSize: 10, trayCode: undefined, trayName: undefined, resourceId: undefined, status: undefined })
const trayForm = reactive({})
const itemForm = reactive({})
const trayRules = {
  trayCode: [{ required: true, message: '托盘编码不能为空', trigger: 'blur' }]
}

function loadTrays() {
  loading.value = true
  trayApi.list(queryParams).then(res => {
    trays.value = res.rows || []
    total.value = res.total || 0
    if (current.value) {
      const selected = trays.value.find(row => row.trayId === current.value.trayId)
      if (selected) selectTray(selected)
    }
  }).finally(() => loading.value = false)
}
function handleQuery() { queryParams.pageNum = 1; loadTrays() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function selectTray(row) { current.value = row; trayApi.items(row.trayId).then(res => items.value = res.data || []) }
function resetTrayForm() {
  Object.keys(trayForm).forEach(key => delete trayForm[key])
  Object.assign(trayForm, { status: '0', trayType: 'shape' })
  trayItemsForm.value = []
}
function openTray(row) {
  resetTrayForm()
  if (row) {
    Object.assign(trayForm, { ...row })
    trayApi.items(row.trayId).then(res => {
      trayItemsForm.value = (res.data || []).map(item => ({ ...item }))
      trayOpen.value = true
    })
  } else {
    addFormItem()
    trayOpen.value = true
  }
}
function addFormItem() { trayItemsForm.value.push({ locationCode: '', materialId: undefined, quantity: 1, status: '0', remark: '' }) }
function removeFormItem(index) { trayItemsForm.value.splice(index, 1) }
function submitTray() {
  proxy.$refs.trayRef.validate(valid => {
    if (!valid) return
    const payload = { ...trayForm, items: trayItemsForm.value.filter(item => item.materialId || item.locationCode) }
    const save = payload.trayId ? trayApi.update : trayApi.add
    save(payload).then(() => {
      ElMessage.success('保存成功')
      trayOpen.value = false
      loadTrays()
    })
  })
}
function removeTray(id) {
  ElMessageBox.confirm('确认删除托盘？').then(() => trayApi.remove(id).then(() => {
    ElMessage.success('删除成功')
    loadTrays()
    current.value = null
    items.value = []
  }))
}
function openItem(row) { Object.assign(itemForm, row || { trayId: current.value.trayId, quantity: 1, status: '0' }); itemOpen.value = true }
function submitItem() {
  const save = itemForm.itemId ? trayApi.updateItem : trayApi.addItem
  save(itemForm).then(() => { ElMessage.success('保存成功'); itemOpen.value = false; selectTray(current.value) })
}
function removeItem(id) { ElMessageBox.confirm('确认删除托盘物料？').then(() => trayApi.removeItem(id).then(() => { ElMessage.success('删除成功'); selectTray(current.value) })) }
function handleImport() { proxy.$refs.importTrayRef.open() }
function handleImportSuccess() { loadTrays(); if (current.value) selectTray(current.value) }
function handleExport() { proxy.download(trayApi.exportUrl, { ...queryParams }, `tray_${new Date().getTime()}.xlsx`) }

onMounted(() => {
  loadTrays()
  resourceApi.options().then(res => resources.value = (res.data || []).filter(i => i.resourceType === 'station'))
  materialApi.options().then(res => materials.value = res.data || [])
})
</script>

<style scoped>
.tray-page { background: #f6f8fb; min-height: calc(100vh - 84px); }
.search-bar { padding: 14px 16px 4px; margin-bottom: 10px; background: #fff; border: 1px solid #e7ebf2; border-radius: 6px; }
.toolbar-row { margin-bottom: 10px; }
.tray-layout { display: grid; grid-template-columns: minmax(520px, 46%) 1fr; gap: 12px; align-items: stretch; }
.tray-panel { background: #fff; border: 1px solid #e7ebf2; border-radius: 6px; overflow: hidden; display: flex; flex-direction: column; min-height: 620px; }
.panel-head { min-height: 64px; padding: 14px 16px; border-bottom: 1px solid #edf0f5; display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.panel-head h3 { margin: 0; font-size: 16px; color: #1f2d3d; }
.panel-head p { margin: 4px 0 0; font-size: 12px; color: #8492a6; }
.main-code { color: #1683ff; font-weight: 600; line-height: 20px; }
.sub-text { color: #8492a6; font-size: 12px; line-height: 18px; }
.nowrap-actions { display: inline-flex; align-items: center; gap: 8px; white-space: nowrap; }
.form-section { border: 1px solid #e7ebf2; border-radius: 6px; padding: 14px; margin-bottom: 12px; }
.section-title { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; font-weight: 600; color: #1f2d3d; }
:deep(.el-select) { width: 100%; }
:deep(.el-input-number) { width: 100%; }
:deep(.pagination-container) { margin-top: auto; padding: 12px 16px; border-top: 1px solid #edf0f5; }
</style>
