<template>
  <div class="station-console">
    <header class="top-blue">
      <div class="brand">
        <div class="logo-box"><el-icon><Tools /></el-icon></div>
        <strong>智能工位操作站系统</strong>
      </div>
      <h1>{{ headerTitle }}</h1>
      <div class="top-right">
        <div class="time">{{ nowDate }}<br />{{ nowClock }}</div>
        <div class="hello">下午好!<br />超级管理员</div>
        <el-button circle size="large" icon="Refresh" @click="refresh" />
        <el-button circle size="large" icon="FullScreen" />
        <el-button circle size="large" icon="SwitchButton" />
        <div class="avatar"></div>
      </div>
    </header>

    <main class="console-body">
      <section v-if="viewMode === 'list'" class="task-list-page" v-loading="loading">
        <button v-for="task in tasks" :key="task.scheduleId" class="doc-task" type="button" @click="openTask(task)">
          <div class="task-green"></div>
          <div class="task-info">
            <strong>{{ task.workOrderCode }}</strong>
            <span>工序名称：{{ task.operationName }} 工位名称：{{ task.resourceName }}</span>
          </div>
          <div class="task-progress">
            <el-progress :percentage="progress(task)" :stroke-width="16" />
            <span>{{ progress(task) }}%</span>
          </div>
          <div class="task-counts">
            <span class="orange">总计任务数量：{{ qty(task.planQty) }}</span>
            <span class="green">已完成任务数量：{{ qty(task.reportedQty) }}</span>
          </div>
          <el-icon class="pause"><VideoPause /></el-icon>
          <el-button type="primary" round icon="Right">启动</el-button>
        </button>
        <el-empty v-if="!loading && tasks.length === 0" description="暂无生产任务" />
      </section>

      <template v-else>
        <section class="summary-bar">
          <div class="order-info">
            <strong>生产工单：{{ activeTask.workOrderCode }}</strong>
            <strong>制成物料：{{ activeTask.productName }}</strong>
            <strong>当前工序：{{ activeTask.operationName }}</strong>
          </div>
          <div class="stat orange"><strong>{{ qty(activeTask.planQty) }}</strong><span>任务数量</span></div>
          <div class="stat green"><strong>{{ qty(activeTask.reportedQty) }}</strong><span>完成数量</span></div>
          <div class="trace-input">
            <span>产品追溯码</span>
            <el-input v-model="reportForm.serialNo" size="large" placeholder="请扫描产品追溯码" />
          </div>
          <el-button v-if="activeTask.status === 'released'" class="big-action" type="primary" icon="VideoPlay" @click="startTask">开始执行</el-button>
          <el-button class="big-action red" type="danger" icon="CircleClose">任务挂起</el-button>
        </section>

        <section v-if="viewMode === 'prepare'" class="prepare-doc">
          <div class="work-card">
            <div class="card-title">生产备料</div>
            <div class="prepare-form">
              <el-select v-model="bindForm.materialId" size="large" filterable placeholder="输入物料名称或编码进行查询">
                <el-option v-for="m in materials" :key="m.materialId" :label="`${m.materialCode} ${m.materialName}`" :value="m.materialId" />
              </el-select>
              <el-select v-model="bindForm.resourceId" size="large" clearable placeholder="工位料盒位">
                <el-option v-for="r in locations" :key="r.resourceId" :label="r.resourceName" :value="r.resourceId" />
              </el-select>
              <el-input v-model="bindForm.boxCode" size="large" placeholder="扫描料盒码 / 形迹托盘码" @keyup.enter="bindMaterial" />
              <el-segmented v-model="bindForm.bindingType" :options="[{label:'料盒',value:'box'},{label:'形迹托盘',value:'tray'}]" />
              <el-button size="large" type="primary" icon="Connection" @click="bindMaterial">绑定库位与料盒信息</el-button>
            </div>
          </div>
          <div class="work-card">
            <div class="card-title">任务物料</div>
            <el-table :data="materials" height="260">
              <el-table-column prop="materialCode" label="物料编码" width="160" />
              <el-table-column prop="materialName" label="物料名称" />
              <el-table-column prop="quantity" label="数量" width="100" />
              <el-table-column prop="unit" label="单位" width="80" />
            </el-table>
          </div>
          <div class="work-card">
            <div class="card-title">工位料盒位</div>
            <el-table :data="bindings" height="260">
              <el-table-column prop="boxCode" label="料盒/托盘码" width="170" />
              <el-table-column prop="materialName" label="物料" />
              <el-table-column prop="resourceName" label="库位" width="150" />
            </el-table>
          </div>
        </section>

        <section v-else-if="viewMode === 'guide'" class="guide-doc">
          <div class="work-card">
            <div class="card-title">工序工步</div>
            <button v-for="(step, index) in steps" :key="step.stepId" class="doc-step" :class="{ active: step.stepId === currentStepId }" type="button" @click="currentStepId = step.stepId">
              <span>{{ index + 1 }}</span>
              <strong>{{ step.stepName }}</strong>
              <em>初始化</em>
            </button>
          </div>
          <div class="work-card guide-panel">
            <div class="card-title">工步作业指导书</div>
            <p>{{ currentStep?.stepDesc || '请按照当前工序作业指导完成操作。' }}</p>
            <div class="guide-image">
              <img v-if="showStepImage(currentStep)" :src="currentStep.imageUrl" alt="ESOP" @error="markImageBroken(currentStep)" />
              <div v-else>作业指导图片</div>
            </div>
          </div>
        </section>

        <section v-else class="execute-doc">
          <div class="step-nav">
            <div><el-icon><DArrowLeft /></el-icon>{{ prevStep?.stepName || '无' }}</div>
            <strong>{{ currentStep?.stepName || '当前执行工步' }}</strong>
            <div>{{ nextStep?.stepName || '无' }}<el-icon><DArrowRight /></el-icon></div>
          </div>
          <div class="left-run">
            <div class="material-now">
              <div class="seq">{{ Math.max(1, currentIndex + 1) }}</div>
              <h2>当前物料：{{ currentMaterial?.materialName || activeTask.productName }}</h2>
              <el-button type="info" size="large">初始化</el-button>
              <div class="pick-stats">
                <div><strong>{{ qty(reportForm.goodQty) }}</strong><span>待拣数量</span></div>
                <div><strong>{{ qty(activeTask.reportedQty) }}</strong><span>已拣数量</span></div>
              </div>
              <p>下个待拣选物料：{{ nextMaterial?.materialName || '-' }}</p>
            </div>
            <div class="tips"><el-icon><InfoFilled /></el-icon><strong>操作说明：</strong>请点击开始执行按钮！</div>
            <div class="device-monitor">
              <aside>
                <button v-for="type in deviceTabs" :key="type.value" :class="{ active: activeDeviceType === type.value }" @click="activeDeviceType = type.value">{{ type.label }}</button>
              </aside>
              <div class="monitor-table">
                <div class="blue-strip"></div>
                <h3>【设备实时监控】</h3>
                <table>
                  <tbody>
                    <tr><th>设备ID</th><td>{{ activeDevice?.deviceCode || '' }}</td><th>拧紧状态</th><td>{{ activeDevice?.status || '' }}</td></tr>
                    <tr><th>模式</th><td>{{ activeDevice?.deviceType || '' }}</td><th>组别</th><td>{{ activeDevice?.categoryName || '' }}</td></tr>
                    <tr><th>扭矩</th><td>{{ torqueText }}</td><th>剩余拧紧数</th><td>{{ currentStep?.screwCheckCount || 0 }}</td></tr>
                    <tr><th>最大扭矩</th><td>1.50 N.m</td><th>最小扭矩</th><td>0.80 N.m</td></tr>
                    <tr><th>旋转速度</th><td>320 rpm</td><th>拧紧角度</th><td>90 deg</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div class="right-guide">
            <div class="card-title">工步作业指导书</div>
            <p>{{ currentStep?.stepDesc || '按照页面指引进行拣选、装配、检测和报工。' }}</p>
            <div class="drawing">
              <img v-if="showStepImage(currentStep)" :src="currentStep.imageUrl" alt="ESOP" @error="markImageBroken(currentStep)" />
              <div v-else>
                <strong>图1</strong>
                <span>{{ currentStep?.stepName || '作业指导图' }}</span>
              </div>
            </div>
          </div>
          <div class="report-actions">
            <el-input-number v-model="reportForm.goodQty" size="large" :min="0" :precision="0" />
            <el-input-number v-model="reportForm.badQty" size="large" :min="0" :precision="0" />
            <el-button type="success" size="large" icon="Check" @click="submitReport">完工报时</el-button>
            <el-button size="large" icon="CircleCheck" @click="finishTask">任务完工</el-button>
          </div>
        </section>
      </template>
    </main>

    <nav class="bottom-tabs">
      <button :class="{ active: viewMode === 'execute' }" :disabled="!activeTask" @click="viewMode = 'execute'"><el-icon><Cpu /></el-icon>生产执行</button>
      <button :class="{ active: viewMode === 'guide' }" :disabled="!activeTask" @click="viewMode = 'guide'"><el-icon><TrendCharts /></el-icon>作业指导书</button>
      <button class="andon"><el-icon><BellFilled /></el-icon>ANDON呼叫</button>
      <button :class="{ active: viewMode === 'prepare' }" :disabled="!activeTask" @click="viewMode = 'prepare'"><el-icon><Ship /></el-icon>生产备料</button>
      <button :class="{ active: viewMode === 'list' }" @click="backToList"><el-icon><Tickets /></el-icon>任务列表</button>
    </nav>
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from 'element-plus'
import { workstationApi } from '@/api/mom/console'
import {
  BellFilled, CircleClose, Connection, Cpu, DArrowLeft, DArrowRight, FullScreen,
  InfoFilled, Refresh, Right, Ship, SwitchButton, Tickets, Tools, TrendCharts,
  VideoPause, VideoPlay
} from '@element-plus/icons-vue'

const loading = ref(false)
const tasks = ref([])
const activeTask = ref(null)
const detail = ref({})
const steps = ref([])
const materials = ref([])
const bindings = ref([])
const locations = ref([])
const devices = ref([])
const currentStepId = ref()
const viewMode = ref('list')
const activeDeviceType = ref('screwdriver')
const brokenImages = reactive({})
const nowDate = ref('')
const nowClock = ref('')
let timer

const bindForm = reactive({ materialId: undefined, resourceId: undefined, boxCode: '', bindingType: 'box', quantity: 1 })
const reportForm = reactive({ goodQty: 1, badQty: 0, serialNo: '' })

const headerTitle = computed(() => viewMode.value === 'list' ? '任 务 列 表' : '生 产 执 行')
const currentIndex = computed(() => steps.value.findIndex(i => i.stepId === currentStepId.value))
const currentStep = computed(() => steps.value[currentIndex.value])
const prevStep = computed(() => currentIndex.value > 0 ? steps.value[currentIndex.value - 1] : null)
const nextStep = computed(() => currentIndex.value >= 0 ? steps.value[currentIndex.value + 1] : null)
const currentMaterial = computed(() => materials.value[Math.max(0, currentIndex.value) % Math.max(1, materials.value.length)])
const nextMaterial = computed(() => materials.value[(Math.max(0, currentIndex.value) + 1) % Math.max(1, materials.value.length)])
const deviceTabs = computed(() => [
  { label: '速动螺刀', value: 'screwdriver' },
  { label: 'ESTIC螺刀', value: 'estic' },
  { label: '2D相机', value: 'camera2d' },
  { label: '焊台', value: 'jbc' },
  { label: '3D相机', value: 'camera3d' },
  { label: '孔位检测', value: 'laser' }
])
const activeDevice = computed(() => devices.value.find(i => i.deviceType === activeDeviceType.value) || devices.value[0])
const torqueText = computed(() => activeDevice.value?.runtimeData?.includes('扭矩') ? activeDevice.value.runtimeData : '1.25 N.m')

function qty(value) {
  const n = Number(value || 0)
  return Number.isInteger(n) ? String(n) : n.toFixed(2)
}
function progress(task) {
  const plan = Number(task.planQty || 0)
  return plan ? Math.min(100, Math.round((Number(task.reportedQty || 0) / plan) * 100)) : 0
}
function showStepImage(step) {
  return Boolean(step?.imageUrl && !brokenImages[step.stepId])
}
function markImageBroken(step) {
  if (step?.stepId) brokenImages[step.stepId] = true
}
function updateClock() {
  const d = new Date()
  nowDate.value = `${d.getFullYear()}.${String(d.getMonth() + 1).padStart(2, '0')}.${String(d.getDate()).padStart(2, '0')}`
  nowClock.value = `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}:${String(d.getSeconds()).padStart(2, '0')}`
}
function loadTasks() {
  loading.value = true
  workstationApi.tasks({}).then(res => {
    tasks.value = res.data || []
  }).finally(() => {
    loading.value = false
  })
}
function refresh() {
  if (activeTask.value) return openTask(activeTask.value)
  loadTasks()
}
function openTask(task) {
  activeTask.value = task
  viewMode.value = 'guide'
  return Promise.all([workstationApi.task(task.scheduleId), workstationApi.prepare(task.scheduleId)]).then(([detailRes, prepRes]) => {
    detail.value = detailRes.data || {}
    steps.value = detail.value.steps || []
    devices.value = detail.value.devices || []
    materials.value = prepRes.data?.materials || []
    bindings.value = prepRes.data?.bindings || []
    locations.value = prepRes.data?.locations || []
    currentStepId.value = steps.value.find(i => i.operationId === task.operationId)?.stepId || steps.value[0]?.stepId
    bindForm.materialId = materials.value[0]?.materialId
    bindForm.resourceId = locations.value[0]?.resourceId
  })
}
function backToList() {
  viewMode.value = 'list'
  activeTask.value = null
  loadTasks()
}
function bindMaterial() {
  if (!activeTask.value || !bindForm.materialId || !bindForm.boxCode) {
    ElMessage.warning('请选择物料并扫描料盒或托盘码')
    return
  }
  workstationApi.bind({ ...bindForm, scheduleId: activeTask.value.scheduleId }).then(() => {
    ElMessage.success('绑定成功')
    bindForm.boxCode = ''
    return openTask(activeTask.value).then(() => { viewMode.value = 'prepare' })
  })
}
function startTask() {
  workstationApi.start(activeTask.value.scheduleId).then(() => {
    ElMessage.success('任务已开始执行')
    activeTask.value.status = 'running'
    viewMode.value = 'execute'
  })
}
function submitReport() {
  if (!currentStep.value) {
    ElMessage.warning('请选择工步')
    return
  }
  workstationApi.report({
    workOrderId: activeTask.value.workOrderId,
    scheduleId: activeTask.value.scheduleId,
    operationId: currentStep.value.operationId,
    stepId: currentStep.value.stepId,
    resourceId: activeTask.value.resourceId,
    goodQty: reportForm.goodQty,
    badQty: reportForm.badQty,
    serialNo: reportForm.serialNo
  }).then(() => {
    ElMessage.success('自动报工成功')
    if (nextStep.value) currentStepId.value = nextStep.value.stepId
    return openTask(activeTask.value).then(() => { viewMode.value = 'execute' })
  })
}
function finishTask() {
  ElMessageBox.confirm('确认该工位生产任务已全部完成？', '任务完工').then(() => {
    workstationApi.finish(activeTask.value.scheduleId).then(() => {
      ElMessage.success('任务已完工')
      backToList()
    })
  })
}

onMounted(() => {
  updateClock()
  timer = setInterval(updateClock, 1000)
  loadTasks()
})
onBeforeUnmount(() => clearInterval(timer))
</script>

<style scoped>
.station-console {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: #f4f5f7;
  color: #2f3136;
  display: grid;
  grid-template-rows: 72px 1fr 80px;
  font-family: Arial, "Microsoft YaHei", sans-serif;
}
.top-blue {
  display: grid;
  grid-template-columns: 420px 1fr 520px;
  align-items: center;
  padding: 0 16px;
  background: #3d9df6;
  color: #fff;
  box-shadow: 0 3px 10px rgba(0, 0, 0, .22);
}
.brand { display: flex; align-items: center; gap: 16px; font-size: 20px; }
.logo-box {
  width: 56px;
  height: 56px;
  display: grid;
  place-items: center;
  border-radius: 12px;
  background: rgba(0, 92, 190, .24);
  font-size: 34px;
}
.top-blue h1 {
  margin: 0;
  text-align: center;
  font-size: 30px;
  font-weight: 800;
  letter-spacing: 10px;
}
.top-right { display: flex; align-items: center; justify-content: flex-end; gap: 14px; font-weight: 700; }
.time { width: 126px; font-size: 18px; line-height: 1.25; }
.hello { width: 86px; font-size: 14px; line-height: 1.35; }
.top-right :deep(.el-button) { border: 0; background: transparent; color: #fff; font-size: 26px; }
.avatar { width: 44px; height: 44px; border-radius: 10px; background: linear-gradient(135deg, #5fa6ff, #0b4ea2); }
.console-body { min-height: 0; padding: 10px 14px; overflow: hidden; }
.task-list-page {
  height: 100%;
  background: #fff;
  border: 1px solid #dfe4ea;
  border-radius: 4px;
  padding: 8px;
}
.doc-task {
  width: 100%;
  min-height: 78px;
  display: grid;
  grid-template-columns: 8px 420px 1fr 360px 54px 112px;
  align-items: center;
  gap: 18px;
  border: 1px solid #d7dce3;
  border-radius: 6px;
  background: #fff;
  cursor: pointer;
  text-align: left;
  margin-bottom: 10px;
  padding: 8px 18px 8px 0;
}
.task-green { height: 100%; background: #22c55e; border-radius: 5px 0 0 5px; }
.task-info strong { display: block; font-size: 18px; color: #8b98a8; margin-bottom: 10px; }
.task-info span { font-size: 16px; font-weight: 700; color: #7a8797; }
.task-progress { display: grid; grid-template-columns: 1fr 42px; gap: 8px; align-items: center; }
.task-counts { display: flex; justify-content: space-between; font-size: 16px; font-weight: 800; }
.orange { color: #f59e0b; }
.green { color: #22c55e; }
.pause { color: #f59e0b; font-size: 20px; justify-self: center; }
.summary-bar {
  height: 96px;
  display: grid;
  grid-template-columns: 310px 126px 126px 1fr 150px 150px;
  gap: 16px;
  align-items: center;
  padding: 10px 14px;
  border-radius: 4px;
  background: #fff;
  box-shadow: 0 1px 7px rgba(0, 0, 0, .16);
}
.order-info { display: grid; gap: 8px; font-size: 17px; }
.stat { text-align: center; }
.stat strong {
  display: grid;
  place-items: center;
  height: 58px;
  border-radius: 4px;
  color: #fff;
  font-size: 34px;
}
.stat.orange strong { background: #f6b40a; }
.stat.green strong { background: #18c967; }
.stat span { display: block; margin-top: 5px; font-size: 15px; font-weight: 800; }
.trace-input { display: grid; grid-template-columns: 126px 1fr; align-items: center; }
.trace-input span {
  height: 48px;
  display: grid;
  place-items: center;
  background: #f1f5f9;
  border: 1px solid #d7dce3;
  font-size: 17px;
  font-weight: 800;
  color: #9aa3ad;
}
.big-action { height: 58px; font-size: 20px; font-weight: 800; }
.big-action.red { background: #ff4d4f; border-color: #ff4d4f; }
.prepare-doc,
.guide-doc {
  height: calc(100% - 108px);
  margin-top: 10px;
  display: grid;
  grid-template-columns: 420px 1fr 1fr;
  gap: 12px;
}
.guide-doc { grid-template-columns: 520px 1fr; }
.work-card,
.right-guide,
.left-run {
  background: #fff;
  border: 1px solid #dfe4ea;
  border-radius: 4px;
  box-shadow: 0 1px 7px rgba(0, 0, 0, .12);
}
.work-card { padding: 12px; overflow: hidden; }
.card-title {
  height: 38px;
  line-height: 36px;
  border-bottom: 2px solid #d8d8d8;
  color: #329bff;
  font-size: 21px;
  font-weight: 800;
}
.prepare-form { margin-top: 18px; display: grid; gap: 14px; }
.doc-step {
  width: 100%;
  min-height: 54px;
  display: grid;
  grid-template-columns: 42px 1fr 72px;
  gap: 12px;
  align-items: center;
  margin-top: 12px;
  padding: 0 12px;
  border: 0;
  border-radius: 4px;
  background: #e7e7e7;
  text-align: left;
  cursor: pointer;
}
.doc-step.active { background: #b6b6b6; }
.doc-step span {
  width: 28px;
  height: 28px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: #3d9df6;
  color: #fff;
  font-weight: 800;
}
.doc-step strong { font-size: 18px; }
.doc-step em {
  height: 30px;
  line-height: 30px;
  text-align: center;
  border-radius: 3px;
  background: #666;
  color: #fff;
  font-style: normal;
  font-weight: 800;
}
.guide-panel p,
.right-guide p {
  margin: 12px 16px;
  font-size: 20px;
  line-height: 1.65;
  text-indent: 2em;
}
.guide-image {
  height: calc(100% - 120px);
  display: grid;
  place-items: center;
  margin-top: 12px;
  overflow: auto;
}
.guide-image img { max-width: 100%; max-height: 100%; object-fit: contain; }
.execute-doc {
  height: calc(100% - 108px);
  margin-top: 10px;
  display: grid;
  grid-template-columns: 45% 1fr;
  grid-template-rows: 70px 1fr 64px;
  gap: 10px 14px;
}
.step-nav {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 1fr 1.2fr 1fr;
  align-items: center;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 1px 7px rgba(0, 0, 0, .15);
  font-size: 24px;
  font-weight: 800;
}
.step-nav div { display: flex; align-items: center; gap: 8px; padding: 0 22px; color: #707070; }
.step-nav div:last-child { justify-content: flex-end; }
.step-nav strong { text-align: center; font-size: 25px; }
.left-run { min-height: 0; overflow: hidden; display: grid; grid-template-rows: 210px 58px 1fr; gap: 10px; background: transparent; border: 0; box-shadow: none; }
.material-now,
.tips,
.device-monitor {
  background: #fff;
  border: 1px solid #dfe4ea;
  border-radius: 4px;
  box-shadow: 0 1px 7px rgba(0, 0, 0, .12);
}
.material-now { position: relative; padding: 20px 20px 16px 72px; }
.seq {
  position: absolute;
  left: 22px;
  top: 22px;
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: #3d9df6;
  color: #fff;
  font-size: 24px;
  font-weight: 800;
}
.material-now h2 { margin: 0; font-size: 30px; }
.material-now .el-button { position: absolute; right: 18px; top: 18px; font-size: 24px; font-weight: 800; }
.pick-stats { display: grid; grid-template-columns: 1fr 1fr; gap: 100px; margin: 28px 90px 18px 26px; }
.pick-stats div { text-align: center; }
.pick-stats strong {
  height: 58px;
  display: grid;
  place-items: center;
  border-radius: 4px;
  background: #4a4a4a;
  color: #fff;
  font-size: 42px;
}
.pick-stats div:nth-child(2) strong { background: #3d9df6; }
.pick-stats span { display: block; margin-top: 12px; color: #3d3d3d; font-size: 26px; font-weight: 800; }
.material-now p { margin: 0; color: #89919b; font-size: 20px; font-weight: 800; }
.tips { display: flex; align-items: center; gap: 14px; padding: 0 20px; font-size: 20px; }
.tips .el-icon { font-size: 26px; }
.device-monitor { display: grid; grid-template-columns: 160px 1fr; min-height: 0; overflow: hidden; }
.device-monitor aside { background: #f2f4f7; border-right: 1px solid #dfe4ea; }
.device-monitor aside button {
  width: 100%;
  height: 54px;
  border: 0;
  border-bottom: 1px solid #d9e1ea;
  background: transparent;
  color: #8a8f98;
  font-size: 20px;
  font-weight: 800;
  cursor: pointer;
}
.device-monitor aside button.active { color: #168bff; background: #fff; }
.monitor-table { padding: 14px 28px 20px; overflow: auto; }
.blue-strip { height: 36px; background: #2092f5; margin-bottom: 16px; }
.monitor-table h3 { margin: 0 0 10px; text-align: center; }
.monitor-table table { width: 100%; border-collapse: collapse; font-size: 18px; }
.monitor-table th,
.monitor-table td { height: 52px; border: 1px solid #dde5ee; text-align: center; }
.monitor-table th { width: 22%; background: #f6f6f6; }
.right-guide { min-height: 0; overflow: auto; padding: 0 0 16px; }
.drawing {
  min-height: 520px;
  margin: 18px 34px 0;
  display: grid;
  place-items: center;
  border: 4px solid #9b9b9b;
  background: #fff;
}
.drawing img { max-width: 100%; max-height: 640px; object-fit: contain; }
.drawing div { display: grid; gap: 20px; text-align: center; color: #333; }
.drawing strong { font-size: 54px; }
.drawing span { font-size: 30px; }
.report-actions {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding: 8px 14px;
  background: #fff;
  border: 1px solid #dfe4ea;
  border-radius: 4px;
}
.bottom-tabs {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  align-items: center;
  gap: 8px;
  padding: 10px 18px 14px;
  background: #f4f5f7;
}
.bottom-tabs button {
  height: 58px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  border: 1px solid #dfe4ea;
  border-radius: 8px;
  background: #fff;
  color: #2f3136;
  font-size: 23px;
  font-weight: 800;
  cursor: pointer;
}
.bottom-tabs button:disabled { color: #b5bdc8; cursor: not-allowed; }
.bottom-tabs button.active { color: #2294ff; }
.bottom-tabs .el-icon { font-size: 28px; }
.bottom-tabs .andon .el-icon { color: #ff5b64; }
</style>
