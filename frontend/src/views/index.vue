<template>
  <div class="home-page">
    <section class="overview-panel">
      <div class="overview-head">
        <div>
          <p class="eyebrow">MOM WORKBENCH</p>
          <h1>生产管理工作台</h1>
          <p class="hero-copy">围绕物料、工艺、BOM、工单、排产和报工的日常维护入口。</p>
        </div>
        <div class="hero-actions">
          <el-button type="primary" icon="Plus" @click="go('/mom/production/workorder')">创建工单</el-button>
          <el-button plain icon="Search" @click="go('/mom/base/material')">物料查询</el-button>
        </div>
      </div>
      <div class="metric-grid">
        <div v-for="item in metrics" :key="item.label" class="metric-card">
          <div class="metric-icon" :class="item.tone"><svg-icon :icon-class="item.icon" /></div>
          <div>
            <div class="metric-value">{{ item.value }}</div>
            <div class="metric-label">{{ item.label }}</div>
          </div>
        </div>
      </div>
    </section>

    <section class="workbench-grid">
      <div class="panel main-panel">
        <div class="panel-title">
          <div>
            <h2>常用业务</h2>
            <p>按日常维护频率整理，减少菜单里来回找。</p>
          </div>
        </div>
        <div class="shortcut-grid">
          <button v-for="item in shortcuts" :key="item.path" class="shortcut" @click="go(item.path)">
            <span class="shortcut-icon" :class="item.tone"><svg-icon :icon-class="item.icon" /></span>
            <span>
              <strong>{{ item.title }}</strong>
              <em>{{ item.desc }}</em>
            </span>
          </button>
        </div>
      </div>

      <div class="panel">
        <div class="panel-title">
          <div>
            <h2>今日关注</h2>
            <p>{{ todayText }}</p>
          </div>
        </div>
        <div class="todo-list">
          <div v-for="item in todos" :key="item.title" class="todo-item">
            <span class="todo-dot" :class="item.tone"></span>
            <div>
              <strong>{{ item.title }}</strong>
              <p>{{ item.desc }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="panel process-panel">
      <div class="panel-title">
        <div>
          <h2>业务主线</h2>
          <p>从基础数据到生产执行的维护路径。</p>
        </div>
      </div>
      <div class="process-line">
        <div v-for="(item, index) in process" :key="item.title" class="process-step">
          <span>{{ index + 1 }}</span>
          <strong>{{ item.title }}</strong>
          <em>{{ item.desc }}</em>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
const router = useRouter()

const todayText = new Date().toLocaleDateString('zh-CN', {
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  weekday: 'long'
})

const metrics = [
  { label: '基础数据', value: '物料 / 资源', icon: 'tree-table', tone: 'blue' },
  { label: '工艺数据', value: '路线 / 工序', icon: 'component', tone: 'green' },
  { label: 'BOM管理', value: 'PBOM / MBOM', icon: 'list', tone: 'orange' },
  { label: '生产执行', value: '工单 / 报工', icon: 'form', tone: 'purple' }
]

const shortcuts = [
  { title: '物料数据', desc: '维护物料、分类与导入导出', path: '/mom/base/material', icon: 'tree-table', tone: 'blue' },
  { title: '生产资源', desc: '工厂、车间、产线、工位维护', path: '/mom/base/resource', icon: 'peoples', tone: 'green' },
  { title: '工艺路线', desc: '路线、工序、工步与图片维护', path: '/mom/base/routing', icon: 'nested', tone: 'orange' },
  { title: 'PBOM维护', desc: '设计 BOM 与投料工位维护', path: '/mom/mbom/pbom', icon: 'documentation', tone: 'purple' },
  { title: 'MBOM维护', desc: '按工序、工步维护制造 BOM', path: '/mom/mbom/index', icon: 'form', tone: 'blue' },
  { title: '生产工单', desc: '工单创建、导入、下达与关闭', path: '/mom/production/workorder', icon: 'edit', tone: 'green' },
  { title: '生产排产', desc: '工序计划、资源与状态管理', path: '/mom/production/schedule', icon: 'date', tone: 'orange' },
  { title: '形迹托盘', desc: '托盘与托盘物料维护', path: '/mom/production/tray', icon: 'tree', tone: 'purple' }
]

const todos = [
  { title: '基础数据先行', desc: '新增工单前确认物料、工位、路线、PBOM/MBOM 数据完整。', tone: 'blue' },
  { title: '导入后复核', desc: '批量导入后建议进入对应维护页检查明细数量和关联工位。', tone: 'green' },
  { title: '现场执行闭环', desc: '工单下达后关注排产、报工和追溯数据是否连续。', tone: 'orange' }
]

const process = [
  { title: '物料与资源', desc: '先维护成品、原材料、工厂、产线、工位。' },
  { title: '工艺路线', desc: '定义工序、工步、报工点和作业图片。' },
  { title: 'PBOM / MBOM', desc: '建立设计 BOM 与制造投料关系。' },
  { title: '工单排产', desc: '生成生产工单并安排工序资源。' },
  { title: '报工追溯', desc: '记录现场执行、投料和生产履历。' }
]

function go(path) {
  router.push(path)
}
</script>

<style scoped>
.home-page {
  padding: 18px;
  min-height: calc(100vh - 84px);
  background: #f5f7fb;
  color: #1f2d3d;
}

.overview-panel {
  padding: 18px;
  background: #fff;
  border: 1px solid #e7ebf2;
  border-radius: 8px;
  box-shadow: 0 6px 18px rgba(31, 45, 61, .05);
}

.overview-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding-bottom: 14px;
  border-bottom: 1px solid #edf0f5;
}

.eyebrow {
  margin: 0 0 6px;
  font-size: 12px;
  letter-spacing: 0;
  color: #8492a6;
}

.overview-head h1 {
  margin: 0;
  font-size: 22px;
  line-height: 30px;
  font-weight: 700;
}

.hero-copy {
  max-width: 720px;
  margin: 6px 0 0;
  line-height: 20px;
  color: #606b7b;
  font-size: 13px;
}

.hero-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.metric-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 12px;
  margin-top: 14px;
}

.panel {
  background: #fff;
  border: 1px solid #e7ebf2;
  border-radius: 8px;
  box-shadow: 0 6px 18px rgba(31, 45, 61, .05);
}

.metric-card {
  min-height: 82px;
  padding: 14px;
  border: 1px solid #edf0f5;
  border-radius: 8px;
  background: #fbfcff;
  display: flex;
  align-items: center;
  gap: 14px;
}

.metric-icon,
.shortcut-icon {
  width: 42px;
  height: 42px;
  border-radius: 8px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
}

.metric-value {
  font-size: 18px;
  font-weight: 700;
}

.metric-label {
  margin-top: 5px;
  color: #8492a6;
  font-size: 13px;
}

.workbench-grid {
  display: grid;
  grid-template-columns: minmax(0, 1.65fr) minmax(320px, .75fr);
  gap: 14px;
  margin-top: 14px;
}

.panel {
  padding: 18px;
}

.panel-title {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 14px;
}

.panel-title h2 {
  margin: 0;
  font-size: 18px;
}

.panel-title p {
  margin: 6px 0 0;
  color: #8492a6;
  font-size: 13px;
}

.shortcut-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
}

.shortcut {
  min-height: 86px;
  border: 1px solid #edf0f5;
  border-radius: 8px;
  background: #fbfcff;
  padding: 14px;
  display: flex;
  align-items: center;
  gap: 12px;
  text-align: left;
  cursor: pointer;
  transition: border-color .18s ease, transform .18s ease, box-shadow .18s ease;
}

.shortcut:hover {
  border-color: #409eff;
  transform: translateY(-1px);
  box-shadow: 0 8px 18px rgba(64, 158, 255, .12);
}

.shortcut strong,
.todo-item strong,
.process-step strong {
  display: block;
  font-style: normal;
  font-weight: 700;
  color: #1f2d3d;
}

.shortcut em,
.process-step em {
  display: block;
  margin-top: 6px;
  font-style: normal;
  color: #8492a6;
  font-size: 12px;
  line-height: 18px;
}

.todo-list {
  display: grid;
  gap: 12px;
}

.todo-item {
  min-height: 72px;
  padding: 13px;
  border: 1px solid #edf0f5;
  border-radius: 8px;
  display: grid;
  grid-template-columns: 10px 1fr;
  gap: 12px;
  align-items: start;
}

.todo-item p {
  margin: 6px 0 0;
  color: #8492a6;
  line-height: 20px;
  font-size: 13px;
}

.todo-dot {
  width: 9px;
  height: 9px;
  margin-top: 5px;
  border-radius: 50%;
}

.process-panel {
  margin-top: 14px;
}

.process-line {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 10px;
}

.process-step {
  min-height: 112px;
  padding: 14px;
  border: 1px solid #edf0f5;
  border-radius: 8px;
  background: #fbfcff;
}

.process-step span {
  width: 26px;
  height: 26px;
  margin-bottom: 12px;
  border-radius: 50%;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: #ecf5ff;
  color: #1683ff;
  font-weight: 700;
}

.blue { color: #1683ff; background: #ecf5ff; }
.green { color: #18a058; background: #eaf8f0; }
.orange { color: #d9822b; background: #fff4e5; }
.purple { color: #6b5dd3; background: #f1efff; }

@media (max-width: 1200px) {
  .overview-head {
    align-items: flex-start;
    flex-direction: column;
  }
  .metric-grid,
  .process-line {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  .workbench-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .metric-grid,
  .shortcut-grid,
  .process-line {
    grid-template-columns: 1fr;
  }
  .hero-actions {
    justify-content: flex-start;
  }
}
</style>
