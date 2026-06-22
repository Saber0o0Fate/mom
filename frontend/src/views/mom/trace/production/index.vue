<template>
  <div class="app-container">
    <el-form :model="query" inline>
      <el-form-item label="序列号"><el-input v-model="query.serialNo" clearable @keyup.enter="load" /></el-form-item>
      <el-form-item label="事件类型">
        <el-select v-model="query.traceType" clearable>
          <el-option label="备料" value="prepare" /><el-option label="报工" value="report" /><el-option label="设备" value="device" />
        </el-select>
      </el-form-item>
      <el-form-item label="操作人"><el-input v-model="query.operatorName" clearable @keyup.enter="load" /></el-form-item>
      <el-form-item><el-button type="primary" icon="Search" @click="load">搜索</el-button><el-button icon="Refresh" @click="reset">重置</el-button></el-form-item>
    </el-form>
    <el-table :data="rows" v-loading="loading">
      <el-table-column prop="serialNo" label="序列号" width="160" />
      <el-table-column prop="workOrderCode" label="工单" width="160" />
      <el-table-column prop="eventName" label="事件" width="140" />
      <el-table-column prop="traceType" label="类型" width="100" />
      <el-table-column prop="operationName" label="工序" width="130" />
      <el-table-column prop="stepName" label="工步" width="150" />
      <el-table-column prop="resourceName" label="工位" width="140" />
      <el-table-column prop="deviceName" label="设备" width="150" />
      <el-table-column prop="operatorName" label="操作人" width="110" />
      <el-table-column prop="result" label="结果" width="90" />
      <el-table-column prop="eventData" label="数据" min-width="220" show-overflow-tooltip />
      <el-table-column prop="createTime" label="时间" width="180" />
    </el-table>
    <pagination v-show="total > 0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="load" />
  </div>
</template>

<script setup>
import { traceApi } from '@/api/mom/console'
const loading = ref(false)
const rows = ref([])
const total = ref(0)
const query = reactive({ pageNum: 1, pageSize: 10, serialNo: '', traceType: '', operatorName: '' })
function load() { loading.value = true; traceApi.productionList(query).then(res => { rows.value = res.rows || []; total.value = res.total || 0 }).finally(() => loading.value = false) }
function reset() { Object.assign(query, { pageNum: 1, serialNo: '', traceType: '', operatorName: '' }); load() }
onMounted(load)
</script>
