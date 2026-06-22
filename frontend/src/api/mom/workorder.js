import request from '@/utils/request'

export const workOrderApi = {
  list: (query) => request({ url: '/mom/workorder/list', method: 'get', params: query }),
  get: (id) => request({ url: `/mom/workorder/${id}`, method: 'get' }),
  add: (data) => request({ url: '/mom/workorder', method: 'post', data }),
  update: (data) => request({ url: '/mom/workorder', method: 'put', data }),
  remove: (id) => request({ url: `/mom/workorder/${id}`, method: 'delete' }),
  release: (id) => request({ url: `/mom/workorder/${id}/release`, method: 'post' }),
  start: (id) => request({ url: `/mom/workorder/${id}/start`, method: 'post' }),
  finish: (id, completedQty) => request({ url: `/mom/workorder/${id}/finish`, method: 'post', params: { completedQty } }),
  close: (id) => request({ url: `/mom/workorder/${id}/close`, method: 'post' }),
  exportUrl: '/mom/workorder/export',
  importUrl: '/mom/workorder/importData',
  importTemplateUrl: '/mom/workorder/importTemplate'
}
