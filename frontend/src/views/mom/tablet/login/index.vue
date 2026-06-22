<template>
  <div class="tablet-login">
    <section class="brand-panel">
      <div class="brand-mark">MOM</div>
      <div>
        <p class="eyebrow">移动报工终端</p>
        <h1>车间平板报工登录</h1>
        <p class="subtitle">登录后进入生产任务列表，选择排产任务并完成工步报工。</p>
      </div>
      <div class="status-strip">
        <div><strong>1920×1080</strong><span>横屏平板</span></div>
        <div><strong>任务列表</strong><span>排产驱动</span></div>
        <div><strong>工步报工</strong><span>实时累计</span></div>
      </div>
    </section>

    <section class="login-panel">
      <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
        <div class="form-title">
          <p class="eyebrow">Operator Sign In</p>
          <h2>报工登录</h2>
        </div>

        <div class="rfid-box">
          <el-input v-model="rfidCard" size="large" placeholder="RFID刷卡号，如 RFID-ADMIN-001" clearable @keyup.enter="handleRfid">
            <template #prefix><el-icon><CreditCard /></el-icon></template>
          </el-input>
          <el-button size="large" type="success" :loading="rfidLoading" @click="handleRfid">刷卡识别</el-button>
        </div>
        <div v-if="rfidUser" class="rfid-user">
          已识别：{{ rfidUser.nickName || rfidUser.userName }}，请确认密码后进入报工终端
        </div>

        <el-form-item prop="username">
          <el-input v-model="loginForm.username" size="large" placeholder="账号" autocomplete="off">
            <template #prefix><el-icon><User /></el-icon></template>
          </el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input v-model="loginForm.password" size="large" type="password" placeholder="密码" autocomplete="off" show-password @keyup.enter="handleLogin">
            <template #prefix><el-icon><Lock /></el-icon></template>
          </el-input>
        </el-form-item>

        <el-form-item prop="code" v-if="captchaEnabled">
          <div class="captcha-row">
            <el-input v-model="loginForm.code" size="large" placeholder="验证码" autocomplete="off" @keyup.enter="handleLogin">
              <template #prefix><el-icon><Key /></el-icon></template>
            </el-input>
            <button class="captcha-img" type="button" @click="getCode">
              <img :src="codeUrl" alt="验证码" />
            </button>
          </div>
        </el-form-item>

        <div class="form-options">
          <el-checkbox v-model="loginForm.rememberMe">记住账号</el-checkbox>
          <router-link to="/login">后台登录</router-link>
        </div>

        <el-button class="login-button" :loading="loading" type="primary" size="large" @click.prevent="handleLogin">
          {{ loading ? '登录中...' : '进入报工终端' }}
        </el-button>
      </el-form>
    </section>
  </div>
</template>

<script setup>
import { User, Lock, Key, CreditCard } from '@element-plus/icons-vue'
import { getCodeImg } from '@/api/login'
import { workstationApi } from '@/api/mom/console'
import { ElMessage } from 'element-plus'
import Cookies from 'js-cookie'
import { encrypt, decrypt } from '@/utils/jsencrypt'
import useUserStore from '@/store/modules/user'

const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const { proxy } = getCurrentInstance()

const loginForm = ref({
  username: 'admin',
  password: 'admin123',
  rememberMe: false,
  code: '',
  uuid: ''
})

const loginRules = {
  username: [{ required: true, trigger: 'blur', message: '请输入账号' }],
  password: [{ required: true, trigger: 'blur', message: '请输入密码' }],
  code: [{ required: true, trigger: 'change', message: '请输入验证码' }]
}

const codeUrl = ref('')
const loading = ref(false)
const rfidLoading = ref(false)
const rfidCard = ref('')
const rfidUser = ref(null)
const captchaEnabled = ref(false)
const redirect = ref('/tablet/report')

watch(route, (newRoute) => {
  redirect.value = newRoute.query?.redirect || '/tablet/report'
}, { immediate: true })

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (!valid) return
    loading.value = true
    if (loginForm.value.rememberMe) {
      Cookies.set('tabletUsername', loginForm.value.username, { expires: 30 })
      Cookies.set('tabletPassword', encrypt(loginForm.value.password), { expires: 30 })
      Cookies.set('tabletRememberMe', loginForm.value.rememberMe, { expires: 30 })
    } else {
      Cookies.remove('tabletUsername')
      Cookies.remove('tabletPassword')
      Cookies.remove('tabletRememberMe')
    }
    userStore.login(loginForm.value).then(() => {
      router.push({ path: redirect.value || '/tablet/report' })
    }).catch(() => {
      loading.value = false
      if (captchaEnabled.value) getCode()
    })
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = 'data:image/gif;base64,' + res.img
      loginForm.value.uuid = res.uuid
    }
  })
}

function getCookie() {
  const username = Cookies.get('tabletUsername')
  const password = Cookies.get('tabletPassword')
  const rememberMe = Cookies.get('tabletRememberMe')
  loginForm.value.username = username === undefined ? loginForm.value.username : username
  loginForm.value.password = password === undefined ? loginForm.value.password : decrypt(password)
  loginForm.value.rememberMe = rememberMe === undefined ? false : Boolean(rememberMe)
}

function handleRfid() {
  if (!rfidCard.value) {
    ElMessage.warning('请刷卡或输入RFID卡号')
    return
  }
  rfidLoading.value = true
  workstationApi.rfid({ rfidCard: rfidCard.value }).then(res => {
    rfidUser.value = res.data
    loginForm.value.username = res.data.userName
    ElMessage.success('RFID识别成功')
  }).finally(() => {
    rfidLoading.value = false
  })
}

getCookie()
</script>

<style scoped>
.tablet-login {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  display: grid;
  grid-template-columns: 1.1fr 0.9fr;
  background: #edf3f8;
  color: #172033;
}

.brand-panel {
  padding: 72px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  background:
    linear-gradient(rgba(9, 34, 56, 0.78), rgba(9, 34, 56, 0.72)),
    url("../../../../assets/images/login-background.jpg");
  background-size: cover;
  background-position: center;
  color: #ffffff;
}

.brand-mark {
  width: 118px;
  height: 118px;
  display: grid;
  place-items: center;
  border: 2px solid rgba(255, 255, 255, 0.72);
  border-radius: 8px;
  font-size: 34px;
  font-weight: 800;
}

.eyebrow {
  margin: 0 0 12px;
  font-size: 22px;
  color: #8bb7df;
}

h1,
h2 {
  margin: 0;
  letter-spacing: 0;
}

h1 {
  max-width: 720px;
  font-size: 64px;
  line-height: 1.08;
}

.subtitle {
  max-width: 720px;
  margin: 28px 0 0;
  font-size: 28px;
  line-height: 1.5;
  color: rgba(255, 255, 255, 0.84);
}

.status-strip {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
}

.status-strip div {
  min-height: 122px;
  padding: 24px;
  border: 1px solid rgba(255, 255, 255, 0.24);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.12);
}

.status-strip strong,
.status-strip span {
  display: block;
}

.status-strip strong {
  font-size: 30px;
}

.status-strip span {
  margin-top: 12px;
  font-size: 20px;
  color: rgba(255, 255, 255, 0.72);
}

.login-panel {
  display: grid;
  place-items: center;
  padding: 72px;
}

.login-form {
  width: min(560px, 100%);
  padding: 48px;
  border: 1px solid #d9e2ef;
  border-radius: 8px;
  background: #ffffff;
  box-shadow: 0 24px 60px rgba(23, 32, 51, 0.12);
}

.form-title {
  margin-bottom: 36px;
}

.form-title h2 {
  font-size: 42px;
}

.rfid-box {
  display: grid;
  grid-template-columns: 1fr 132px;
  gap: 12px;
  margin-bottom: 12px;
}

.rfid-user {
  margin: 0 0 18px;
  padding: 12px 14px;
  border-radius: 8px;
  background: #e8f7ee;
  color: #146c43;
  font-size: 16px;
}

.captcha-row {
  width: 100%;
  display: grid;
  grid-template-columns: 1fr 168px;
  gap: 14px;
}

.captcha-img {
  height: 56px;
  padding: 0;
  border: 1px solid #d9e2ef;
  border-radius: 8px;
  background: #f7fafc;
  cursor: pointer;
}

.captcha-img img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.form-options {
  margin: 8px 0 28px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 18px;
}

.form-options a {
  color: #2563eb;
  text-decoration: none;
}

.login-button {
  width: 100%;
  height: 68px;
  font-size: 24px;
  font-weight: 700;
}

:deep(.el-input__wrapper) {
  min-height: 58px;
  border-radius: 8px;
}

:deep(.el-input__inner) {
  font-size: 22px;
}

:deep(.el-form-item) {
  margin-bottom: 24px;
}

:deep(.el-checkbox__label) {
  font-size: 18px;
}
</style>
