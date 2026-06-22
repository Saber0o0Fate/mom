<template>
  <div class="app-container">
    <el-form :model="query" inline>
      <el-form-item label="用户"><el-input v-model="query.userName" clearable @keyup.enter="load" /></el-form-item>
      <el-form-item label="状态"><el-select v-model="query.status" clearable><el-option label="上岗" value="on" /><el-option label="离岗" value="off" /></el-select></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="load">搜索</el-button><el-button icon="Refresh" @click="reset">重置</el-button></el-form-item>
    </el-form>
    <el-table :data="rows" v-loading="loading">
      <el-table-column prop="userName" label="用户" width="140" />
      <el-table-column prop="rfidCard" label="RFID" width="160" />
      <el-table-column prop="resourceName" label="工位" min-width="160" />
      <el-table-column prop="dutyType" label="类型" width="120" />
      <el-table-column prop="status" label="状态" width="100"><template #default="s"><el-tag :type="s.row.status === 'on' ? 'success' : 'info'">{{ s.row.status === 'on' ? '上岗' : '离岗' }}</el-tag></template></el-table-column>
      <el-table-column prop="createTime" label="时间" width="180" />
      <el-table-column prop="remark" label="备注" min-width="180" />
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="load" />
  </div>
</template>

<script setup>
import { traceApi } from '@/api/mom/console'
const loading = ref(false)
const rows = ref([])
const total = ref(0)
const query = reactive({ pageNum: 1, pageSize: 10, userName: '', status: '' })
function load() { loading.value = true; traceApi.dutyList(query).then(res => { rows.value = res.rows || []; total.value = res.total || 0 }).finally(() => loading.value = false) }
function reset() { Object.assign(query, { pageNum: 1, userName: '', status: '' }); load() }
onMounted(load)
</script>
