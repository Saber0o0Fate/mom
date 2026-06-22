<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="日期" prop="calendarDate"><el-date-picker v-model="queryParams.calendarDate" type="date" value-format="YYYY-MM-DD" clearable /></el-form-item>
      <el-form-item label="班次编码" prop="shiftCode"><el-input v-model="queryParams.shiftCode" clearable @keyup.enter="handleQuery" /></el-form-item>
      <el-form-item label="是否工作日" prop="isWorkday"><el-select v-model="queryParams.isWorkday" clearable><el-option v-for="d in mom_yes_no" :key="d.value" :label="d.label" :value="d.value" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button><el-button icon="Refresh" @click="resetQuery">重置</el-button></el-form-item>
    </el-form>
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5"><el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['mom:base:calendar:add']">新增</el-button></el-col>
      <el-col :span="1.5"><el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['mom:base:calendar:edit']">修改</el-button></el-col>
      <el-col :span="1.5"><el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['mom:base:calendar:remove']">删除</el-button></el-col>
      <el-col :span="1.5"><el-button type="warning" plain icon="Download" @click="handleExport" v-hasPermi="['mom:base:calendar:export']">导出</el-button></el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>
    <el-table v-loading="loading" :data="rows" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column label="日期" prop="calendarDate" width="120" />
      <el-table-column label="班次编码" prop="shiftCode" />
      <el-table-column label="班次名称" prop="shiftName" />
      <el-table-column label="开始时间" prop="startTime" width="100" />
      <el-table-column label="结束时间" prop="endTime" width="100" />
      <el-table-column label="工作日" prop="isWorkday" width="90"><template #default="s"><dict-tag :options="mom_yes_no" :value="s.row.isWorkday"/></template></el-table-column>
      <el-table-column label="状态" prop="status" width="90"><template #default="s"><dict-tag :options="sys_normal_disable" :value="s.row.status"/></template></el-table-column>
      <el-table-column label="操作" width="150"><template #default="s"><el-button link type="primary" icon="Edit" @click="handleUpdate(s.row)" v-hasPermi="['mom:base:calendar:edit']">修改</el-button><el-button link type="primary" icon="Delete" @click="handleDelete(s.row)" v-hasPermi="['mom:base:calendar:remove']">删除</el-button></template></el-table-column>
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
    <el-dialog :title="title" v-model="open" width="560px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="95px">
        <el-form-item label="日期" prop="calendarDate"><el-date-picker v-model="form.calendarDate" type="date" value-format="YYYY-MM-DD" /></el-form-item>
        <el-form-item label="班次编码" prop="shiftCode"><el-input v-model="form.shiftCode" /></el-form-item>
        <el-form-item label="班次名称" prop="shiftName"><el-input v-model="form.shiftName" /></el-form-item>
        <el-form-item label="开始时间" prop="startTime"><el-time-picker v-model="form.startTime" value-format="HH:mm" format="HH:mm" /></el-form-item>
        <el-form-item label="结束时间" prop="endTime"><el-time-picker v-model="form.endTime" value-format="HH:mm" format="HH:mm" /></el-form-item>
        <el-form-item label="是否工作日" prop="isWorkday"><el-radio-group v-model="form.isWorkday"><el-radio v-for="d in mom_yes_no" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="状态" prop="status"><el-radio-group v-model="form.status"><el-radio v-for="d in sys_normal_disable" :key="d.value" :label="d.value">{{ d.label }}</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注" prop="remark"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><div class="dialog-footer"><el-button type="primary" @click="submitForm">确定</el-button><el-button @click="cancel">取消</el-button></div></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { calendarApi } from '@/api/mom/base'
const { proxy } = getCurrentInstance()
const { sys_normal_disable, mom_yes_no } = proxy.useDict('sys_normal_disable', 'mom_yes_no')
const rows = ref([]), open = ref(false), loading = ref(true), showSearch = ref(true), ids = ref([]), single = ref(true), multiple = ref(true), total = ref(0), title = ref('')
const data = reactive({ form: {}, queryParams: { pageNum: 1, pageSize: 10, calendarDate: undefined, shiftCode: undefined, isWorkday: undefined }, rules: { calendarDate: [{ required: true, message: '日期不能为空', trigger: 'change' }], shiftCode: [{ required: true, message: '班次编码不能为空', trigger: 'blur' }], shiftName: [{ required: true, message: '班次名称不能为空', trigger: 'blur' }] } })
const { queryParams, form, rules } = toRefs(data)
function getList() { loading.value = true; calendarApi.list(queryParams.value).then(r => { rows.value = r.rows; total.value = r.total; loading.value = false }) }
function reset() { form.value = { calendarId: undefined, calendarDate: undefined, shiftCode: undefined, shiftName: undefined, startTime: undefined, endTime: undefined, isWorkday: 'Y', status: '0', remark: undefined }; proxy.resetForm('formRef') }
function cancel() { open.value = false; reset() }
function handleQuery() { queryParams.value.pageNum = 1; getList() }
function resetQuery() { proxy.resetForm('queryRef'); handleQuery() }
function handleSelectionChange(sel) { ids.value = sel.map(i => i.calendarId); single.value = sel.length !== 1; multiple.value = !sel.length }
function handleAdd() { reset(); open.value = true; title.value = '新增班次日历' }
function handleUpdate(row) { reset(); calendarApi.get(row?.calendarId || ids.value[0]).then(r => { form.value = r.data; open.value = true; title.value = '修改班次日历' }) }
function submitForm() { proxy.$refs.formRef.validate(valid => { if (!valid) return; const save = form.value.calendarId ? calendarApi.update : calendarApi.add; save(form.value).then(() => { proxy.$modal.msgSuccess('保存成功'); open.value = false; getList() }) }) }
function handleDelete(row) { const delIds = row?.calendarId || ids.value; proxy.$modal.confirm('确认删除选中的班次日历数据吗？').then(() => calendarApi.remove(delIds)).then(() => { getList(); proxy.$modal.msgSuccess('删除成功') }) }
function handleExport() { proxy.download(calendarApi.exportUrl, { ...queryParams.value }, `calendar_${new Date().getTime()}.xlsx`) }
getList()
</script>
