<template>
  <div class="three-page">
    <div class="toolbar">
      <div>
        <h2>三维工位页面</h2>
        <p>实时查看当前任务、工位料盒和投料数据。首期集成手册中的外部三维页面地址。</p>
      </div>
      <div class="actions">
        <el-input v-model="url" size="large" />
        <el-button size="large" type="primary" icon="Refresh" @click="frameUrl = url">刷新</el-button>
        <el-button size="large" icon="Link" @click="openExternal">新窗口打开</el-button>
      </div>
    </div>
    <iframe :src="frameUrl" />
  </div>
</template>

<script setup>
const url = ref('http://192.168.0.100:4080/')
const frameUrl = ref(url.value)
function openExternal() {
  window.open(frameUrl.value, '_blank')
}
</script>

<style scoped>
.three-page { height: calc(100vh - 84px); display: grid; grid-template-rows: auto 1fr; background: #eef3f7; }
.toolbar { display: flex; justify-content: space-between; gap: 24px; padding: 18px 24px; background: #fff; border-bottom: 1px solid #d7e2ee; }
h2 { margin: 0; font-size: 26px; }
p { margin: 8px 0 0; color: #60758a; }
.actions { display: grid; grid-template-columns: 360px 110px 140px; gap: 10px; align-items: center; }
iframe { width: 100%; height: 100%; border: 0; background: #fff; }
</style>
