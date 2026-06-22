import request from '@/utils/request'

export const mbomApi = {
  list: (query) => request({ url: '/mom/mbom/list', method: 'get', params: query }),
  get: (id) => request({ url: `/mom/mbom/${id}`, method: 'get' }),
  detail: (id) => request({ url: `/mom/mbom/${id}/detail`, method: 'get' }),
  add: (data) => request({ url: '/mom/mbom', method: 'post', data }),
  generate: (data) => request({ url: '/mom/mbom/generate', method: 'post', data }),
  update: (data) => request({ url: '/mom/mbom', method: 'put', data }),
  remove: (id) => request({ url: `/mom/mbom/${id}`, method: 'delete' }),
  exportUrl: '/mom/mbom/export',
  importUrl: '/mom/mbom/importData',
  importTemplateUrl: '/mom/mbom/importTemplate'
}

export const mbomItemApi = {
  list: (query) => request({ url: '/mom/mbom/item/list', method: 'get', params: query }),
  get: (id) => request({ url: `/mom/mbom/item/${id}`, method: 'get' }),
  add: (data) => request({ url: '/mom/mbom/item', method: 'post', data }),
  update: (data) => request({ url: '/mom/mbom/item', method: 'put', data }),
  remove: (id) => request({ url: `/mom/mbom/item/${id}`, method: 'delete' }),
  exportUrl: '/mom/mbom/item/export'
}
