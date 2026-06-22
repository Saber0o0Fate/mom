<template>
  <div class="app-container resource-page">
    <el-row :gutter="14">
      <el-col :xs="24" :sm="7" :md="5" :lg="4" class="resource-aside">
        <div class="tree-title">工厂架构</div>
        <el-tree
          ref="treeRef"
          class="resource-tree"
          :data="treeData"
          :props="{ label: 'label', children: 'children' }"
          node-key="id"
          default-expand-all
          highlight-current
          :expand-on-click-node="false"
          @node-click="handleNodeClick"
        >
          <template #default="{ data }">
            <span class="tree-node">
              <span>{{ data.label }}</span>
              <el-tag v-if="data.type !== 'company'" size="small" effect="plain">{{ resourceTypeName(data.type) }}</el-tag>
            </span>
          </template>
        </el-tree>
      </el-col>

      <el-col :xs="24" :sm="17" :md="19" :lg="20">
        <div class="table-title">{{ tableTitle }}</div>
        <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" class="station-query">
          <el-form-item prop="resourceCode">
            <el-input v-model="queryParams.resourceCode" :placeholder="`${activeChildTypeName}编码`" clearable @keyup.enter="handleQuery" />
          </el-form-item>
          <el-form-item v-if="advancedSearch" prop="resourceName" :label="`${activeChildTypeName}名称`">
            <el-input v-model="queryParams.resourceName" clearable @keyup.enter="handleQuery" />
          </el-form-item>
          <el-form-item v-if="advancedSearch" prop="status" label="启用状态">
            <el-select v-model="queryParams.status" clearable>
              <el-option v-for="d in sys_normal_disable" :key="d.value" :label="d.label" :value="d.value" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
            <el-button icon="Search" plain @click="advancedSearch = !advancedSearch">高级查询</el-button>
            <el-button icon="Refresh" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:base:resource:add']">新建</el-button></el-col>
          <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:base:resource:edit']">编辑</el-button></el-col>
          <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:base:resource:remove']">删除</el-button></el-col>
          <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:base:resource:export']">导出</el-button></el-col>
          <right-toolbar v-model:showSearch="showSearch" @queryTable="refreshData" />
        </el-row>

        <el-table v-loading="loading" :data="pagedRows" border stripe @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="46" align="center" />
          <el-table-column label="序号" type="index" width="70" align="center" :index="tableIndex" />
          <el-table-column :label="`${activeChildTypeName}编码`" prop="resourceCode" min-width="130">
            <template #default="scope">
              <el-link type="primary" :underline="false" @click="handleUpdate(scope.row)">{{ scope.row.resourceCode }}</el-link>
            </template>
          </el-table-column>
          <el-table-column :label="`${activeChildTypeName}名称`" prop="resourceName" min-width="130" />
          <el-table-column v-if="!isStationTable" label="资源类型" prop="resourceType" width="110" align="center"><template #default="s"><el-tag effect="plain">{{ resourceTypeName(s.row.resourceType) }}</el-tag></template></el-table-column>
          <el-table-column v-if="isStationTable" label="是否报工备注" prop="stationNoteFlag" width="120" align="center"><template #default="s"><dict-tag :options="mom_yes_no" :value="s.row.stationNoteFlag || 'N'" /></template></el-table-column>
          <el-table-column v-if="isStationTable" label="是否打印箱码" prop="printBoxFlag" width="120" align="center"><template #default="s"><dict-tag :options="mom_yes_no" :value="s.row.printBoxFlag || 'N'" /></template></el-table-column>
          <el-table-column v-if="isStationTable" label="是否打印铭牌" prop="printNameplateFlag" width="120" align="center"><template #default="s"><dict-tag :options="mom_yes_no" :value="s.row.printNameplateFlag || 'N'" /></template></el-table-column>
          <el-table-column label="启用状态" prop="status" width="100" align="center"><template #default="s"><dict-tag :options="sys_normal_disable" :value="s.row.status" /></template></el-table-column>
          <el-table-column v-if="isStationTable" label="产线类型" prop="lineType" width="110" align="center"><template #default="s"><el-tag v-if="s.row.lineType" effect="plain">{{ lineTypeName(s.row.lineType) }}</el-tag></template></el-table-column>
          <el-table-column v-if="isStationTable" label="工位类型" prop="stationType" width="110" />
          <el-table-column v-if="isStationTable" label="工位技能要求" prop="skillRequire" min-width="150" show-overflow-tooltip />
          <el-table-column v-if="isStationTable" label="在制品容量" prop="wipCapacity" width="110" align="center" />
          <el-table-column v-if="!isStationTable" label="备注" prop="remark" min-width="150" show-overflow-tooltip />
          <el-table-column label="操作" width="140" fixed="right" align="center">
            <template #default="scope">
              <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['mom:base:resource:edit']">编辑</el-button>
              <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['mom:base:resource:remove']">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="applyStationFilters" />
      </el-col>
    </el-row>

    <el-dialog :title="title" v-model="open" width="640px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="110px">
        <el-row :gutter="14">
          <el-col :span="12"><el-form-item label="资源编码" prop="resourceCode"><el-input v-model="form.resourceCode" placeholder="为空时自动生成" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="资源名称" prop="resourceName"><el-input v-model="form.resourceName" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="资源类型" prop="resourceType"><el-select v-model="form.resourceType"><el-option v-for="d in mom_resource_type" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="上级资源" prop="parentId"><el-select v-model="form.parentId" clearable filterable><el-option v-for="r in parentOptions" :key="r.resourceId" :label="`${r.resourceCode} ${r.resourceName}`" :value="r.resourceId" /></el-select></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="车间" prop="workshop"><el-input v-model="form.workshop" /></el-form-item></el-col>
          <el-col :span="12"><el-form-item label="产线编码" prop="lineCode"><el-input v-model="form.lineCode" /></el-form-item></el-col>
          <template v-if="form.resourceType === 'station'">
            <el-col :span="12"><el-form-item label="报工备注" prop="stationNoteFlag"><el-radio-group v-model="form.stationNoteFlag"><el-radio label="Y">是</el-radio><el-radio label="N">否</el-radio></el-radio-group></el-form-item></el-col>
            <el-col :span="12"><el-form-item label="打印箱码" prop="printBoxFlag"><el-radio-group v-model="form.printBoxFlag"><el-radio label="Y">是</el-radio><el-radio label="N">否</el-radio></el-radio-group></el-form-item></el-col>
            <el-col :span="12"><el-form-item label="打印铭牌" prop="printNameplateFlag"><el-radio-group v-model="form.printNameplateFlag"><el-radio label="Y">是</el-radio><el-radio label="N">否</el-radio></el-radio-group></el-form-item></el-col>
            <el-col :span="12"><el-form-item label="产线类型" prop="lineType"><el-select v-model="form.lineType" clearable><el-option label="主线" value="main" /><el-option label="支线" value="branch" /></el-select></el-form-item></el-col>
            <el-col :span="12"><el-form-item label="工位类型" prop="stationType"><el-input v-model="form.stationType" /></el-form-item></el-col>
            <el-col :span="12"><el-form-item label="在制品容量" prop="wipCapacity"><el-input-number v-model="form.wipCapacity" :min="0" :precision="0" controls-position="right" /></el-form-item></el-col>
            <el-col :span="24"><el-form-item label="技能要求" prop="skillRequire"><el-input v-model="form.skillRequire" /></el-form-item></el-col>
          </template>
          <el-col :span="24"><el-form-item label="启用状态" prop="status"><el-radio-group v-model="form.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item></el-col>
          <el-col :span="24"><el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item></el-col>
        </el-row>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确定</el-button>
          <el-button @click="cancel">取消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { resourceApi } from '@/api/mom/base'

const { proxy } = getCurrentInstance()
const { sys_normal_disable, mom_resource_type, mom_yes_no } = proxy.useDict('sys_normal_disable', 'mom_resource_type', 'mom_yes_no')

const allResources = ref([])
const rows = ref([])
const treeData = ref([])
const parentOptions = ref([])
const selectedNode = ref({ id: 'company', parentId: 0, type: 'company', label: '公司', children: [] })
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const advancedSearch = ref(false)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref('')
const pagedRows = computed(() => {
  const start = (queryParams.value.pageNum - 1) * queryParams.value.pageSize
  return rows.value.slice(start, start + queryParams.value.pageSize)
})
const childTypeMap = { company: 'factory', factory: 'workshop', workshop: 'line', line: 'station', station: 'location' }
const activeChildType = computed(() => childTypeMap[selectedNode.value?.type] || 'factory')
const activeChildTypeName = computed(() => resourceTypeName(activeChildType.value))
const tableTitle = computed(() => `${activeChildTypeName.value}表`)
const isStationTable = computed(() => activeChildType.value === 'station')

const data = reactive({
  form: {},
  queryParams: { pageNum: 1, pageSize: 30, resourceCode: undefined, resourceName: undefined, status: undefined },
  rules: {
    resourceName: [{ required: true, message: '资源名称不能为空', trigger: 'blur' }],
    resourceType: [{ required: true, message: '资源类型不能为空', trigger: 'change' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function resourceTypeName(type) {
  const fallback = { company: '公司', factory: '工厂', workshop: '车间', line: '产线', station: '工位', location: '库位' }
  return mom_resource_type.value.find(item => item.value === type)?.label || fallback[type] || type
}

function lineTypeName(type) {
  return { main: '主线', branch: '支线' }[type] || type
}

function tableIndex(index) {
  return (queryParams.value.pageNum - 1) * queryParams.value.pageSize + index + 1
}

function buildResourceTree(list) {
  const allowedTypes = ['factory', 'workshop', 'line', 'station']
  const order = { factory: 1, workshop: 2, line: 3, station: 4 }
  const nodeMap = new Map()
  list.filter(item => allowedTypes.includes(item.resourceType)).forEach(item => nodeMap.set(item.resourceId, {
    id: item.resourceId,
    parentId: item.parentId || 0,
    type: item.resourceType,
    label: item.resourceName || item.resourceCode,
    resource: item,
    children: []
  }))
  const roots = []
  nodeMap.forEach(node => {
    const parent = nodeMap.get(node.parentId)
    if (parent) parent.children.push(node)
    else roots.push(node)
  })
  const sortNodes = nodes => nodes.sort((a, b) => (order[a.type] || 99) - (order[b.type] || 99) || String(a.label).localeCompare(String(b.label))).forEach(item => sortNodes(item.children))
  sortNodes(roots)
  return [{ id: 'company', parentId: 0, type: 'company', label: '公司', children: roots }]
}

function applyStationFilters() {
  let filtered = allResources.value.filter(item => {
    if (selectedNode.value?.type === 'company') return item.resourceType === 'factory' && Number(item.parentId || 0) === 0
    return item.resourceType === activeChildType.value && item.parentId === selectedNode.value?.id
  })
  const code = queryParams.value.resourceCode
  const name = queryParams.value.resourceName
  if (code) filtered = filtered.filter(item => item.resourceCode?.includes(code))
  if (name) filtered = filtered.filter(item => item.resourceName?.includes(name))
  if (queryParams.value.status) filtered = filtered.filter(item => item.status === queryParams.value.status)
  rows.value = filtered
  total.value = filtered.length
}

function refreshData() {
  loading.value = true
  Promise.all([
    resourceApi.options(),
    resourceApi.list({ pageNum: 1, pageSize: 9999 })
  ]).then(([optionsRes, listRes]) => {
    allResources.value = listRes.rows || []
    parentOptions.value = allResources.value.filter(item => ['factory', 'workshop', 'line', 'station'].includes(item.resourceType))
    treeData.value = buildResourceTree(optionsRes.data || [])
    if (!selectedNode.value) selectedNode.value = treeData.value[0]
    applyStationFilters()
    nextTick(() => proxy.$refs.treeRef?.setCurrentKey(selectedNode.value?.id || 'company'))
  }).finally(() => {
    loading.value = false
  })
}

function handleNodeClick(data) {
  selectedNode.value = data
  queryParams.value.pageNum = 1
  applyStationFilters()
}

function reset() {
  form.value = {
    resourceId: undefined,
    resourceCode: undefined,
    resourceName: undefined,
    resourceType: 'station',
    parentId: undefined,
    workshop: undefined,
    lineCode: undefined,
    status: '0',
    stationNoteFlag: 'N',
    printBoxFlag: 'N',
    printNameplateFlag: 'N',
    lineType: 'main',
    stationType: undefined,
    skillRequire: undefined,
    wipCapacity: 0,
    remark: undefined
  }
  proxy.resetForm('formRef')
}

function defaultChildType(type) {
  return { company: 'factory', factory: 'workshop', workshop: 'line', line: 'station', station: 'location', location: 'location' }[type] || 'factory'
}

function fillParentContext(parent) {
  if (!parent) return
  form.value.parentId = parent.resourceId
  form.value.workshop = parent.resourceType === 'workshop' ? parent.resourceName : parent.workshop
  form.value.lineCode = parent.resourceType === 'line' ? parent.resourceCode : parent.lineCode
  if (parent.resourceType === 'station') {
    form.value.workshop = parent.workshop
    form.value.lineCode = parent.lineCode
  }
}

function cancel() {
  open.value = false
  reset()
}

function handleQuery() {
  queryParams.value.pageNum = 1
  applyStationFilters()
}

function resetQuery() {
  proxy.resetForm('queryRef')
  queryParams.value.pageNum = 1
  selectedNode.value = treeData.value[0]
  proxy.$refs.treeRef?.setCurrentKey('company')
  applyStationFilters()
}

function handleSelectionChange(sel) {
  ids.value = sel.map(i => i.resourceId)
  single.value = sel.length !== 1
  multiple.value = !sel.length
}

function handleAdd() {
  reset()
  const node = selectedNode.value
  if (node) {
    form.value.resourceType = defaultChildType(node.type)
    if (node.type === 'company') form.value.parentId = 0
    else fillParentContext(node.resource)
  }
  open.value = true
  title.value = '新建资源'
}

function handleUpdate(row) {
  reset()
  resourceApi.get(row?.resourceId || ids.value[0]).then(r => {
    form.value = {
      stationNoteFlag: 'N',
      printBoxFlag: 'N',
      printNameplateFlag: 'N',
      lineType: 'main',
      wipCapacity: 0,
      ...r.data
    }
    open.value = true
    title.value = '编辑资源'
  })
}

function submitForm() {
  proxy.$refs.formRef.validate(valid => {
    if (!valid) return
    const save = form.value.resourceId ? resourceApi.update : resourceApi.add
    save(form.value).then(() => {
      proxy.$modal.msgSuccess('保存成功')
      open.value = false
      refreshData()
    })
  })
}

function handleDelete(row) {
  const delIds = row?.resourceId || ids.value
  proxy.$modal.confirm('确认删除选中的资源数据吗？').then(() => resourceApi.remove(delIds)).then(() => {
    refreshData()
    proxy.$modal.msgSuccess('删除成功')
  })
}

function handleExport() {
  proxy.download(resourceApi.exportUrl, { ...queryParams.value, resourceType: activeChildType.value }, `resource_${new Date().getTime()}.xlsx`)
}

refreshData()
</script>

<style scoped>
.resource-page {
  min-height: calc(100vh - 84px);
}

.resource-aside {
  border-right: 1px solid #ebeef5;
  min-height: calc(100vh - 110px);
}

.tree-title,
.table-title {
  color: #111827;
  font-size: 16px;
  font-weight: 700;
  line-height: 32px;
}

.tree-title::after,
.table-title::after {
  content: "";
  display: block;
  width: 58px;
  height: 2px;
  background: #303133;
  margin-top: 2px;
}

.resource-tree {
  margin-top: 12px;
}

.tree-node {
  align-items: center;
  display: flex;
  gap: 8px;
  justify-content: space-between;
  width: 100%;
}

.station-query {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 8px;
}

.station-query :deep(.el-form-item) {
  margin-bottom: 8px;
}

.station-query :deep(.el-input) {
  width: 180px;
}

@media (max-width: 768px) {
  .resource-aside {
    border-right: 0;
    min-height: auto;
    margin-bottom: 14px;
  }

  .station-query {
    justify-content: flex-start;
  }
}
</style>
