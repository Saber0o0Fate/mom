<template>
  <div class="app-container">
    <el-tabs v-model="tab">
      <el-tab-pane label="设备信息" name="device">
        <el-form :model="query" inline>
          <el-form-item label="设备"><el-input v-model="query.deviceName" clearable @keyup.enter="loadDevices" /></el-form-item>
          <el-form-item label="类型"><el-select v-model="query.deviceType" clearable><el-option v-for="o in deviceTypes" :key="o.value" :label="o.label" :value="o.value" /></el-select></el-form-item>
          <el-form-item><el-button type="primary" icon="Search" @click="loadDevices">搜索</el-button><el-button icon="Plus" @click="openDevice()">新增</el-button></el-form-item>
        </el-form>
        <el-table :data="devices" v-loading="loading">
          <el-table-column prop="deviceCode" label="设备编码" width="150" />
          <el-table-column prop="deviceName" label="设备名称" min-width="180" />
          <el-table-column prop="categoryName" label="类别" width="130" />
          <el-table-column prop="resourceName" label="工位" width="130" />
          <el-table-column prop="ipAddress" label="IP" width="140" />
          <el-table-column prop="status" label="状态" width="110"><template #default="s"><el-tag :type="s.row.status === 'online' ? 'success' : 'info'">{{ s.row.status }}</el-tag></template></el-table-column>
          <el-table-column prop="runtimeData" label="运行数据" min-width="180" />
          <el-table-column label="操作" width="320" fixed="right">
            <template #default="scope">
              <el-button link type="success" @click="operate(scope.row, 'connect')">连接</el-button>
              <el-button link type="warning" @click="operate(scope.row, 'disconnect')">断开</el-button>
              <el-button link type="primary" @click="operate(scope.row, 'capture')">抓拍/指引</el-button>
              <el-button link type="primary" @click="openDevice(scope.row)">编辑</el-button>
              <el-button link type="danger" @click="removeDevice(scope.row.deviceId)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="deviceTotal > 0" :total="deviceTotal" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="loadDevices" />
      </el-tab-pane>
      <el-tab-pane label="设备类别" name="category">
        <el-button type="primary" icon="Plus" class="mb8" @click="openCategory()">新增类别</el-button>
        <el-table :data="categories">
          <el-table-column prop="categoryCode" label="类别编码" width="160" />
          <el-table-column prop="categoryName" label="类别名称" min-width="180" />
          <el-table-column prop="deviceType" label="设备类型" width="140" />
          <el-table-column label="操作" width="160">
            <template #default="scope">
              <el-button link type="primary" @click="openCategory(scope.row)">编辑</el-button>
              <el-button link type="danger" @click="removeCategory(scope.row.categoryId)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <el-dialog v-model="deviceOpen" title="设备维护" width="560px">
      <el-form :model="deviceForm" label-width="96px">
        <el-form-item label="设备编码"><el-input v-model="deviceForm.deviceCode" /></el-form-item>
        <el-form-item label="设备名称"><el-input v-model="deviceForm.deviceName" /></el-form-item>
        <el-form-item label="设备类别"><el-select v-model="deviceForm.categoryId"><el-option v-for="c in categories" :key="c.categoryId" :label="c.categoryName" :value="c.categoryId" /></el-select></el-form-item>
        <el-form-item label="所属工位"><el-select v-model="deviceForm.resourceId" clearable filterable><el-option v-for="r in resources" :key="r.resourceId" :label="r.resourceName" :value="r.resourceId" /></el-select></el-form-item>
        <el-form-item label="IP/端口"><el-row :gutter="8"><el-col :span="16"><el-input v-model="deviceForm.ipAddress" /></el-col><el-col :span="8"><el-input-number v-model="deviceForm.port" :min="0" /></el-col></el-row></el-form-item>
        <el-form-item label="状态"><el-radio-group v-model="deviceForm.status"><el-radio label="online">在线</el-radio><el-radio label="offline">离线</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注"><el-input v-model="deviceForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="deviceOpen=false">取消</el-button><el-button type="primary" @click="submitDevice">确定</el-button></template>
    </el-dialog>

    <el-dialog v-model="categoryOpen" title="设备类别" width="520px">
      <el-form :model="categoryForm" label-width="96px">
        <el-form-item label="类别编码"><el-input v-model="categoryForm.categoryCode" /></el-form-item>
        <el-form-item label="类别名称"><el-input v-model="categoryForm.categoryName" /></el-form-item>
        <el-form-item label="设备类型"><el-select v-model="categoryForm.deviceType"><el-option v-for="o in deviceTypes" :key="o.value" :label="o.label" :value="o.value" /></el-select></el-form-item>
        <el-form-item label="状态"><el-radio-group v-model="categoryForm.status"><el-radio label="0">正常</el-radio><el-radio label="1">停用</el-radio></el-radio-group></el-form-item>
      </el-form>
      <template #footer><el-button @click="categoryOpen=false">取消</el-button><el-button type="primary" @click="submitCategory">确定</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import { deviceApi } from '@/api/mom/console'
import { resourceApi } from '@/api/mom/base'

const tab = ref('device')
const loading = ref(false)
const devices = ref([])
const categories = ref([])
const resources = ref([])
const deviceTotal = ref(0)
const deviceOpen = ref(false)
const categoryOpen = ref(false)
const query = reactive({ pageNum: 1, pageSize: 10, deviceName: '', deviceType: '' })
const deviceForm = reactive({})
const categoryForm = reactive({})
const deviceTypes = [
  { label: '2D相机', value: 'camera2d' }, { label: '电批', value: 'screwdriver' }, { label: 'JBC焊台', value: 'jbc' },
  { label: '3D相机', value: 'camera3d' }, { label: '激光指引', value: 'laser' }
]

function loadDevices() { loading.value = true; deviceApi.list(query).then(res => { devices.value = res.rows || []; deviceTotal.value = res.total || 0 }).finally(() => loading.value = false) }
function loadCategories() { deviceApi.categoryList({ pageNum: 1, pageSize: 999 }).then(res => categories.value = res.rows || []) }
function openDevice(row) { Object.assign(deviceForm, row || { status: 'offline' }); deviceOpen.value = true }
function submitDevice() { (deviceForm.deviceId ? deviceApi.update : deviceApi.add)(deviceForm).then(() => { ElMessage.success('保存成功'); deviceOpen.value = false; loadDevices() }) }
function removeDevice(id) { ElMessageBox.confirm('确认删除设备？').then(() => deviceApi.remove(id).then(() => { ElMessage.success('删除成功'); loadDevices() })) }
function openCategory(row) { Object.assign(categoryForm, row || { status: '0', deviceType: 'camera2d' }); categoryOpen.value = true }
function submitCategory() { (categoryForm.categoryId ? deviceApi.updateCategory : deviceApi.addCategory)(categoryForm).then(() => { ElMessage.success('保存成功'); categoryOpen.value = false; loadCategories() }) }
function removeCategory(id) { ElMessageBox.confirm('确认删除类别？').then(() => deviceApi.removeCategory(id).then(() => { ElMessage.success('删除成功'); loadCategories() })) }
function operate(row, action) { deviceApi.operate(row.deviceId, action).then(res => { ElMessage.success(res.data?.message || '操作成功'); loadDevices() }) }

onMounted(() => {
  loadDevices()
  loadCategories()
  resourceApi.options().then(res => resources.value = (res.data || []).filter(i => i.resourceType === 'station'))
})
</script>
