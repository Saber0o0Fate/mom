<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="分类编码" prop="categoryCode"><el-input v-model="queryParams.categoryCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="分类名称" prop="categoryName"><el-input v-model="queryParams.categoryName" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="状态" prop="status"><el-select v-model="queryParams.status" clearable><el-option v-for="d in sys_normal_disable" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:base:materialCategory:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:base:materialCategory:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:base:materialCategory:remove']">删除</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>
    <el-table v-loading="loading" :data="rows" row-key="categoryId" default-expand-all @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="分类名称" prop="categoryName" min-width="180" />
      <el-table-column label="分类编码" prop="categoryCode" />
      <el-table-column label="显示顺序" prop="orderNum" width="100" />
      <el-table-column label="状态" prop="status" width="90"><template #default="s"><dict-tag :options="sys_normal_disable" :value="s.row.status"/></template></el-table-column>
      <el-table-column label="操作" width="150"><template #default="s"><el-button link type="primary" icon="Edit" @click="handleUpdate(s.row)" v-hasPermi="['mom:base:materialCategory:edit']">修改</el-button><el-button link type="primary" icon="Delete" @click="handleDelete(s.row)" v-hasPermi="['mom:base:materialCategory:remove']">删除</el-button></template></el-table-column>
    </el-table>
    <el-dialog :title="title" v-model="open" width="560px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="上级分类" prop="parentId"><el-tree-select v-model="form.parentId" :data="categoryOptions" :props="{ value: 'id', label: 'label', children: 'children' }" value-key="id" check-strictly placeholder="请选择上级分类" /></el-form-item>
        <el-form-item label="分类编码" prop="categoryCode"><el-input v-model="form.categoryCode" /></el-form-item>
        <el-form-item label="分类名称" prop="categoryName"><el-input v-model="form.categoryName" /></el-form-item>
        <el-form-item label="显示顺序" prop="orderNum"><el-input-number v-model="form.orderNum" :min="0" controls-position="right" /></el-form-item>
        <el-form-item label="状态" prop="status"><el-radio-group v-model="form.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { materialCategoryApi } from '@/api/mom/base'

const { proxy } = getCurrentInstance()
const { sys_normal_disable } = proxy.useDict('sys_normal_disable')
const rows = ref([]), categoryOptions = ref([]), open = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), title = ref('')
const data = reactive({
  form: {},
  queryParams: { categoryCode: undefined, categoryName: undefined, status: undefined },
  rules: {
    parentId: [{ required: true, message: '上级分类不能为空', trigger: 'change' }],
    categoryCode: [{ required: true, message: '分类编码不能为空', trigger: 'blur' }],
    categoryName: [{ required: true, message: '分类名称不能为空', trigger: 'blur' }],
    orderNum: [{ required: true, message: '显示顺序不能为空', trigger: 'blur' }]
  }
})
const { queryParams, form, rules } = toRefs(data)

function listToTree(list, parentId = 0) {
  return list.filter(item => Number(item.parentId || 0) === Number(parentId)).map(item => ({ ...item, children: listToTree(list, item.categoryId) }))
}
function getList() {
  loading.value = true
  materialCategoryApi.list(queryParams.value).then(r => {
    rows.value = listToTree(r.data || [])
    loading.value = false
  })
}
function loadTree() {
  materialCategoryApi.tree().then(r => {
    categoryOptions.value = [{ id: 0, label: '顶级分类', children: r.data || [] }]
  })
}
function reset() {
  form.value = { categoryId: undefined, parentId: 0, categoryCode: undefined, categoryName: undefined, orderNum: 0, status: '0', remark: undefined }
  proxy.resetForm('formRef')
}
function cancel() { open.value = false; reset() }
function handleQuery() { getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.categoryId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleAdd() { reset(); loadTree(); open.value = true; title.value = '新增物料分类' }
function handleUpdate(row) {
  reset()
  loadTree()
  materialCategoryApi.get(row?.categoryId || ids.value[0]).then(r => {
    form.value = r.data
    open.value = true
    title.value = '修改物料分类'
  })
}
function submitForm() {
  proxy.$refs.formRef.validate(valid => {
    if (!valid) return
    const save = form.value.categoryId ? materialCategoryApi.update : materialCategoryApi.add
    save(form.value).then(() => {
      proxy.$modal.msgSuccess('保存成功')
      open.value = false
      getList()
    })
  })
}
function handleDelete(row) {
  const delIds = row?.categoryId || ids.value
  proxy.$modal.confirm('确认删除选中的物料分类吗？').then(() => materialCategoryApi.remove(delIds)).then(() => {
    getList()
    proxy.$modal.msgSuccess('删除成功')
  })
}

getList()
</script>
