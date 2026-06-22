<template>
  <div class="app-container">
    <el-row :gutter="16">
      <el-col :span="10">
        <el-card shadow="never">
          <template #header><div class="head"><span>形迹托盘</span><el-button type="primary" icon="Plus" @click="openTray()">新增</el-button></div></template>
          <el-table :data="trays" v-loading="loading" highlight-current-row @row-click="selectTray">
            <el-table-column prop="trayCode" label="托盘编码" min-width="140" />
            <el-table-column prop="trayName" label="托盘名称" min-width="150" />
            <el-table-column prop="resourceName" label="工位" min-width="120" />
            <el-table-column label="操作" width="140">
              <template #default="scope">
                <el-button link type="primary" @click.stop="openTray(scope.row)">编辑</el-button>
                <el-button link type="danger" @click.stop="removeTray(scope.row.trayId)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination v-show="total > 0" :total="total" v-model:page="query.pageNum" v-model:limit="query.pageSize" @pagination="loadTrays" />
        </el-card>
      </el-col>
      <el-col :span="14">
        <el-card shadow="never">
          <template #header><div class="head"><span>{{ current?.trayCode || '请选择托盘' }} 托盘物料</span><el-button type="primary" icon="Plus" :disabled="!current" @click="openItem()">新增物料</el-button></div></template>
          <el-table :data="items">
            <el-table-column prop="locationCode" label="托盘位" width="110" />
            <el-table-column prop="materialCode" label="物料编码" width="150" />
            <el-table-column prop="materialName" label="物料名称" min-width="180" />
            <el-table-column prop="quantity" label="数量" width="100" />
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button link type="primary" @click="openItem(scope.row)">编辑</el-button>
                <el-button link type="danger" @click="removeItem(scope.row.itemId)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <el-dialog v-model="trayOpen" title="托盘维护" width="520px">
      <el-form :model="trayForm" label-width="96px">
        <el-form-item label="托盘编码"><el-input v-model="trayForm.trayCode" /></el-form-item>
        <el-form-item label="托盘名称"><el-input v-model="trayForm.trayName" /></el-form-item>
        <el-form-item label="所属工位"><el-select v-model="trayForm.resourceId" filterable clearable><el-option v-for="r in resources" :key="r.resourceId" :label="r.resourceName" :value="r.resourceId" /></el-select></el-form-item>
        <el-form-item label="状态"><el-radio-group v-model="trayForm.status"><el-radio label="0">正常</el-radio><el-radio label="1">停用</el-radio></el-radio-group></el-form-item>
        <el-form-item label="备注"><el-input v-model="trayForm.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="trayOpen=false">取消</el-button><el-button type="primary" @click="submitTray">确定</el-button></template>
    </el-dialog>

    <el-dialog v-model="itemOpen" title="托盘物料" width="520px">
      <el-form :model="itemForm" label-width="96px">
        <el-form-item label="物料"><el-select v-model="itemForm.materialId" filterable><el-option v-for="m in materials" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" /></el-select></el-form-item>
        <el-form-item label="托盘位"><el-input v-model="itemForm.locationCode" /></el-form-item>
        <el-form-item label="数量"><el-input-number v-model="itemForm.quantity" :min="0" :precision="3" /></el-form-item>
        <el-form-item label="备注"><el-input v-model="itemForm.remark" /></el-form-item>
      </el-form>
      <template #footer><el-button @click="itemOpen=false">取消</el-button><el-button type="primary" @click="submitItem">确定</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import { trayApi } from '@/api/mom/console'
import { resourceApi, materialApi } from '@/api/mom/base'

const loading = ref(false)
const trays = ref([])
const items = ref([])
const total = ref(0)
const current = ref(null)
const resources = ref([])
const materials = ref([])
const trayOpen = ref(false)
const itemOpen = ref(false)
const query = reactive({ pageNum: 1, pageSize: 10 })
const trayForm = reactive({})
const itemForm = reactive({})

function loadTrays() { loading.value = true; trayApi.list(query).then(res => { trays.value = res.rows || []; total.value = res.total || 0 }).finally(() => loading.value = false) }
function selectTray(row) { current.value = row; trayApi.items(row.trayId).then(res => items.value = res.data || []) }
function openTray(row) { Object.assign(trayForm, row || { status: '0', trayType: 'shape' }); trayOpen.value = true }
function submitTray() { (trayForm.trayId ? trayApi.update : trayApi.add)(trayForm).then(() => { ElMessage.success('保存成功'); trayOpen.value = false; loadTrays() }) }
function removeTray(id) { ElMessageBox.confirm('确认删除托盘？').then(() => trayApi.remove(id).then(() => { ElMessage.success('删除成功'); loadTrays(); current.value = null; items.value = [] })) }
function openItem(row) { Object.assign(itemForm, row || { trayId: current.value.trayId, quantity: 1, status: '0' }); itemOpen.value = true }
function submitItem() { (itemForm.itemId ? trayApi.updateItem : trayApi.addItem)(itemForm).then(() => { ElMessage.success('保存成功'); itemOpen.value = false; selectTray(current.value) }) }
function removeItem(id) { ElMessageBox.confirm('确认删除托盘物料？').then(() => trayApi.removeItem(id).then(() => { ElMessage.success('删除成功'); selectTray(current.value) })) }

onMounted(() => {
  loadTrays()
  resourceApi.options().then(res => resources.value = (res.data || []).filter(i => i.resourceType === 'station'))
  materialApi.options().then(res => materials.value = res.data || [])
})
</script>

<style scoped>
.head { display: flex; align-items: center; justify-content: space-between; }
</style>
