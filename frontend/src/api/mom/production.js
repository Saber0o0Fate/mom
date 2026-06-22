import request from '@/utils/request'

export const scheduleApi = {
  list: (query) => request({ url: '/mom/production/schedule/list', method: 'get', params: query }),
  get: (id) => request({ url: `/mom/production/schedule/${id}`, method: 'get' }),
  add: (data) => request({ url: '/mom/production/schedule', method: 'post', data }),
  update: (data) => request({ url: '/mom/production/schedule', method: 'put', data }),
  remove: (id) => request({ url: `/mom/production/schedule/${id}`, method: 'delete' }),
  release: (id) => request({ url: `/mom/production/schedule/${id}/release`, method: 'post' }),
  start: (id) => request({ url: `/mom/production/schedule/${id}/start`, method: 'post' }),
  finish: (id) => request({ url: `/mom/production/schedule/${id}/finish`, method: 'post' }),
  cancel: (id) => request({ url: `/mom/production/schedule/${id}/cancel`, method: 'post' }),
  exportUrl: '/mom/production/schedule/export'
}

export const reportApi = {
  list: (query) => request({ url: '/mom/production/report/list', method: 'get', params: query }),
  get: (id) => request({ url: `/mom/production/report/${id}`, method: 'get' }),
  add: (data) => request({ url: '/mom/production/report', method: 'post', data }),
  remove: (id) => request({ url: `/mom/production/report/${id}`, method: 'delete' }),
  operations: (workOrderId) => request({ url: `/mom/production/workorder/${workOrderId}/operations`, method: 'get' }),
  steps: (workOrderId) => request({ url: `/mom/production/workorder/${workOrderId}/steps`, method: 'get' }),
  exportUrl: '/mom/production/report/export'
}
