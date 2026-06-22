import request from '@/utils/request'

const crud = (path, key) => ({
  list: (query) => request({ url: `/mom/${path}/list`, method: 'get', params: query }),
  add: (data) => request({ url: `/mom/${path}`, method: 'post', data }),
  update: (data) => request({ url: `/mom/${path}`, method: 'put', data }),
  remove: (id) => request({ url: `/mom/${path}/${id}`, method: 'delete' }),
  key
})

export const pbomApi = {
  ...crud('pbom', 'pbomId'),
  get: (id) => request({ url: `/mom/pbom/${id}`, method: 'get' }),
  items: (id) => request({ url: `/mom/pbom/${id}/items`, method: 'get' }),
  addItem: (data) => request({ url: '/mom/pbom/item', method: 'post', data }),
  updateItem: (data) => request({ url: '/mom/pbom/item', method: 'put', data }),
  removeItem: (id) => request({ url: `/mom/pbom/item/${id}`, method: 'delete' }),
  exportUrl: '/mom/pbom/export',
  importUrl: '/mom/pbom/importData',
  importTemplateUrl: '/mom/pbom/importTemplate'
}

export const trayApi = {
  ...crud('tray', 'trayId'),
  items: (id) => request({ url: `/mom/tray/${id}/items`, method: 'get' }),
  addItem: (data) => request({ url: '/mom/tray/item', method: 'post', data }),
  updateItem: (data) => request({ url: '/mom/tray/item', method: 'put', data }),
  removeItem: (id) => request({ url: `/mom/tray/item/${id}`, method: 'delete' })
}

export const deviceApi = {
  categoryList: (query) => request({ url: '/mom/device/category/list', method: 'get', params: query }),
  addCategory: (data) => request({ url: '/mom/device/category', method: 'post', data }),
  updateCategory: (data) => request({ url: '/mom/device/category', method: 'put', data }),
  removeCategory: (id) => request({ url: `/mom/device/category/${id}`, method: 'delete' }),
  list: (query) => request({ url: '/mom/device/list', method: 'get', params: query }),
  options: (query) => request({ url: '/mom/device/options', method: 'get', params: query }),
  add: (data) => request({ url: '/mom/device', method: 'post', data }),
  update: (data) => request({ url: '/mom/device', method: 'put', data }),
  remove: (id) => request({ url: `/mom/device/${id}`, method: 'delete' }),
  operate: (id, action, data = {}) => request({ url: `/mom/device/${id}/${action}`, method: 'post', data })
}

export const workstationApi = {
  rfid: (data) => request({ url: '/mom/workstation/rfid', method: 'post', data }),
  tasks: (query) => request({ url: '/mom/workstation/tasks', method: 'get', params: query }),
  task: (id) => request({ url: `/mom/workstation/task/${id}`, method: 'get' }),
  prepare: (id) => request({ url: `/mom/workstation/task/${id}/prepare`, method: 'get' }),
  bind: (data) => request({ url: '/mom/workstation/binding', method: 'post', data }),
  removeBinding: (id) => request({ url: `/mom/workstation/binding/${id}`, method: 'delete' }),
  start: (id) => request({ url: `/mom/workstation/task/${id}/start`, method: 'post' }),
  finish: (id) => request({ url: `/mom/workstation/task/${id}/finish`, method: 'post' }),
  report: (data) => request({ url: '/mom/workstation/report', method: 'post', data }),
  dutyOn: (data) => request({ url: '/mom/workstation/duty/on', method: 'post', data }),
  dutyOff: (data) => request({ url: '/mom/workstation/duty/off', method: 'post', data })
}

export const traceApi = {
  dutyList: (query) => request({ url: '/mom/trace/duty/list', method: 'get', params: query }),
  productionList: (query) => request({ url: '/mom/trace/production/list', method: 'get', params: query }),
  serial: (serialNo) => request({ url: `/mom/trace/serial/${serialNo}`, method: 'get' })
}
