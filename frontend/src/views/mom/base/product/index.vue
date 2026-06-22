<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="产品编码" prop="productCode"><el-input v-model="queryParams.productCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="产品名称" prop="productName"><el-input v-model="queryParams.productName" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="状态" prop="status"><el-select v-model="queryParams.status" clearable><el-option v-for="d in sys_normal_disable" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:base:product:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:base:product:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:base:product:remove']">删除</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:base:product:export']">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>
    <el-table v-loading="loading" :data="rows" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="产品编码" prop="productCode" />
      <el-table-column label="产品名称" prop="productName" />
      <el-table-column label="关联物料" prop="materialCode" />
      <el-table-column label="规格型号" prop="specModel" />
      <el-table-column label="单位" prop="unit" width="90" />
      <el-table-column label="状态" prop="status" width="90"><template #default="s"><dict-tag :options="sys_normal_disable" :value="s.row.status"/></template></el-table-column>
      <el-table-column label="操作" width="150"><template #default="s"><el-button link type="primary" icon="Edit" @click="handleUpdate(s.row)" v-hasPermi="['mom:base:product:edit']">修改</el-button><el-button link type="primary" icon="Delete" @click="handleDelete(s.row)" v-hasPermi="['mom:base:product:remove']">删除</el-button></template></el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
    <el-dialog :title="title" v-model="open" width="560px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="产品编码" prop="productCode"><el-input v-model="form.productCode" /></el-form-item>
        <el-form-item label="产品名称" prop="productName"><el-input v-model="form.productName" /></el-form-item>
        <el-form-item label="关联物料" prop="materialId"><el-select v-model="form.materialId" clearable filterable><el-option v-for="m in materialOptions" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" /></el-select></el-form-item>
        <el-form-item label="规格型号" prop="specModel"><el-input v-model="form.specModel" /></el-form-item>
        <el-form-item label="单位" prop="unit"><el-input v-model="form.unit" /></el-form-item>
        <el-form-item label="状态" prop="status"><el-radio-group v-model="form.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { materialApi, productApi } from '@/api/mom/base'
const { proxy } = getCurrentInstance()
const { sys_normal_disable } = proxy.useDict('sys_normal_disable')
const rows = ref([]), materialOptions = ref([]), open = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), total = ref(0), title = ref('')
const data = reactive({ form: {}, queryParams: { pageNum: 1, pageSize: 10, productCode: undefined, productName: undefined, status: undefined }, rules: { productCode: [{ required: true, message: '产品编码不能为空', trigger: 'blur' }], productName: [{ required: true, message: '产品名称不能为空', trigger: 'blur' }] } })
const { queryParams, form, rules } = toRefs(data)
function getList() { loading.value = true; productApi.list(queryParams.value).then(r => { rows.value = r.rows; total.value = r.total; loading.value = false }) }
function loadOptions() { materialApi.options().then(r => { materialOptions.value = r.data }) }
function reset() { form.value = { productId: undefined, productCode: undefined, productName: undefined, materialId: undefined, specModel: undefined, unit: undefined, status: '0', remark: undefined }; proxy.resetForm('formRef') }
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.productId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleAdd() { reset(); open.value = true; title.value = '新增产品' }
function handleUpdate(row) { reset(); productApi.get(row?.productId || ids.value[0]).then(r => { form.value = r.data; open.value = true; title.value = '修改产品' }) }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; const save = form.value.productId ? productApi.update : productApi.add; save(form.value).then(() => { proxy.$modal.msgSuccess('保存成功'); open.value = false; getList() }) }) }
function handleDelete(row) { const delIds = row?.productId || ids.value; proxy.$modal.confirm('确认删除选中的产品数据吗？').then(() => productApi.remove(delIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleExport() { proxy.download(productApi.exportUrl, { ...queryParams.value }, `product_${new Date().getTime()}.xlsx`) }
loadOptions(); getList()
</script>
