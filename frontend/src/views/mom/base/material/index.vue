<template>
  <div class="app-container">
    <el-row :gutter="16">
      <el-col :span="5" :xs="24">
        <div class="category-panel">
          <div class="category-head">
            <span>物料分类</span>
            <el-button link type="primary" icon="Refresh" @click="loadCategoryTree" />
          </div>
          <el-input v-model="categoryFilter" placeholder="输入分类名称过滤" clearable prefix-icon="Search" class="mb12" />
          <el-tree ref="categoryTreeRef" :data="categoryTree" :props="{ children: 'children', label: 'label' }" node-key="id" default-expand-all highlight-current :filter-node-method="filterCategoryNode" @node-click="handleCategoryClick" />
        </div>
      </el-col>
      <el-col :span="19" :xs="24">
        <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
          <el-form-item label="物料编码" prop="materialCode"><el-input v-model="queryParams.materialCode" clearable @keyup.enter="handleQuery" /></el-form-item>
          <el-form-item label="物料名称" prop="materialName"><el-input v-model="queryParams.materialName" clearable @keyup.enter="handleQuery" /></el-form-item>
          <el-form-item label="物料类型" prop="materialType"><el-select v-model="queryParams.materialType" clearable><el-option v-for="d in mom_material_type" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
          <el-form-item label="状态" prop="status"><el-select v-model="queryParams.status" clearable><el-option v-for="d in sys_normal_disable" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
          <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
        </el-form>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:base:material:add']">新增</el-button></el-col>
          <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:base:material:edit']">修改</el-button></el-col>
          <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:base:material:remove']">删除</el-button></el-col>
          <el-col :span="1.5"><el-button type="info" plain icon="Upload" @click="handleImport" v-hasPermi="['mom:base:material:import']">导入</el-button></el-col>
          <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:base:material:export']">导出</el-button></el-col>
          <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
        </el-row>
        <el-table v-loading="loading" :data="rows" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="55" />
          <el-table-column label="物料编码" prop="materialCode" min-width="130" />
          <el-table-column label="物料名称" prop="materialName" min-width="150" />
          <el-table-column label="物料分类" prop="categoryName" min-width="120" />
          <el-table-column label="规格型号" prop="specModel" min-width="120" />
          <el-table-column label="单位" prop="unit" width="90" />
          <el-table-column label="物料类型" prop="materialType" width="110"><template #default="s"><dict-tag :options="mom_material_type" :value="s.row.materialType"/></template></el-table-column>
          <el-table-column label="状态" prop="status" width="90"><template #default="s"><dict-tag :options="sys_normal_disable" :value="s.row.status"/></template></el-table-column>
          <el-table-column label="操作" width="150" fixed="right"><template #default="s"><el-button link type="primary" icon="Edit" @click="handleUpdate(s.row)" v-hasPermi="['mom:base:material:edit']">修改</el-button><el-button link type="primary" icon="Delete" @click="handleDelete(s.row)" v-hasPermi="['mom:base:material:remove']">删除</el-button></template></el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
      </el-col>
    </el-row>

    <el-dialog :title="title" v-model="open" width="560px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="物料编码" prop="materialCode"><el-input v-model="form.materialCode" /></el-form-item>
        <el-form-item label="物料名称" prop="materialName"><el-input v-model="form.materialName" /></el-form-item>
        <el-form-item label="物料分类" prop="categoryId"><el-tree-select v-model="form.categoryId" :data="categoryTree" :props="{ value: 'id', label: 'label', children: 'children' }" value-key="id" check-strictly placeholder="请选择物料分类" /></el-form-item>
        <el-form-item label="规格型号" prop="specModel"><el-input v-model="form.specModel" /></el-form-item>
        <el-form-item label="单位" prop="unit"><el-input v-model="form.unit" /></el-form-item>
        <el-form-item label="物料类型" prop="materialType"><el-select v-model="form.materialType"><el-option v-for="d in mom_material_type" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
        <el-form-item label="状态" prop="status"><el-radio-group v-model="form.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>

    <excel-import-dialog ref="importMaterialRef" title="物料导入" :action="materialApi.importUrl" :template-action="materialApi.importTemplateUrl" template-file-name="material_template" update-support-label="是否更新已经存在的物料数据" @success="getList" />
  </div>
</template>

<script setup>
import ExcelImportDialog from '@/components/ExcelImportDialog'
import { materialApi, materialCategoryApi } from '@/api/mom/base'

const { proxy } = getCurrentInstance()
const { sys_normal_disable, mom_material_type } = proxy.useDict('sys_normal_disable', 'mom_material_type')
const rows = ref([]), categoryTree = ref([]), categoryFilter = ref(''), open = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), total = ref(0), title = ref('')
const data = reactive({
  form: {},
  queryParams: { pageNum: 1, pageSize: 10, materialCode: undefined, materialName: undefined, categoryId: undefined, materialType: undefined, status: undefined },
  rules: {
    materialCode: [{ required: true, message: '物料编码不能为空', trigger: 'blur' }],
    materialName: [{ required: true, message: '物料名称不能为空', trigger: 'blur' }],
    categoryId: [{ required: true, message: '物料分类不能为空', trigger: 'change' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

watch(categoryFilter, val => proxy.$refs.categoryTreeRef?.filter(val))

function loadCategoryTree() {
  materialCategoryApi.tree().then(r => {
    categoryTree.value = [{ id: undefined, label: '全部分类', children: r.data || [] }]
  })
}
function filterCategoryNode(value, data) {
  if (!value) return true
  return data.label.includes(value)
}
function handleCategoryClick(data) {
  queryParams.value.categoryId = data.id
  handleQuery()
}
function getList() {
  loading.value = true
  materialApi.list(queryParams.value).then(r => {
    rows.value = r.rows
    total.value = r.total
    loading.value = false
  })
}
function reset() {
  form.value = { materialId: undefined, materialCode: undefined, materialName: undefined, categoryId: queryParams.value.categoryId, specModel: undefined, unit: undefined, materialType: undefined, status: '0', remark: undefined }
  proxy.resetForm('formRef')
}
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); queryParams.value.categoryId = undefined; handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.materialId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleAdd() { reset(); open.value = true; title.value = '新增物料' }
function handleUpdate(row) { reset(); materialApi.get(row?.materialId || ids.value[0]).then(r => { form.value = r.data; open.value = true; title.value = '修改物料' }) }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; const save = form.value.materialId ? materialApi.update : materialApi.add; save(form.value).then(() => { proxy.$modal.msgSuccess('保存成功'); open.value = false; getList() }) }) }
function handleDelete(row) { const delIds = row?.materialId || ids.value; proxy.$modal.confirm('确认删除选中的物料数据吗？').then(() => materialApi.remove(delIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleImport() { proxy.$refs.importMaterialRef.open() }
function handleExport() { proxy.download(materialApi.exportUrl, { ...queryParams.value }, `material_${new Date().getTime()}.xlsx`) }

loadCategoryTree()
getList()
</script>

<style scoped>
.category-panel {
  min-height: 520px;
  padding: 12px;
  border: 1px solid #e5e6eb;
  border-radius: 6px;
}
.category-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 32px;
  margin-bottom: 10px;
  font-weight: 600;
}
.mb12 {
  margin-bottom: 12px;
}
</style>
