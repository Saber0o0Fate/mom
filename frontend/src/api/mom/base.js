import request from '@/utils/request'

const crud = (path, key) => ({
  list: (query) => request({ url: `/mom/base/${path}/list`, method: 'get', params: query }),
  get: (id) => request({ url: `/mom/base/${path}/${id}`, method: 'get' }),
  add: (data) => request({ url: `/mom/base/${path}`, method: 'post', data }),
  update: (data) => request({ url: `/mom/base/${path}`, method: 'put', data }),
  remove: (id) => request({ url: `/mom/base/${path}/${id}`, method: 'delete' }),
  exportUrl: `/mom/base/${path}/export`,
  key
})

export const materialApi = {
  ...crud('material', 'materialId'),
  options: () => request({ url: '/mom/base/material/optionselect', method: 'get' }),
  importUrl: '/mom/base/material/importData',
  importTemplateUrl: '/mom/base/material/importTemplate'
}

export const materialCategoryApi = {
  ...crud('materialCategory', 'categoryId'),
  tree: () => request({ url: '/mom/base/materialCategory/tree', method: 'get' })
}

export const productApi = {
  ...crud('product', 'productId'),
  options: () => request({ url: '/mom/base/product/optionselect', method: 'get' })
}

export const resourceApi = {
  ...crud('resource', 'resourceId'),
  options: () => request({ url: '/mom/base/resource/optionselect', method: 'get' })
}

export const calendarApi = crud('calendar', 'calendarId')

export const routingApi = {
  ...crud('routing', 'routingId'),
  detail: (id) => request({ url: `/mom/base/routing/${id}/detail`, method: 'get' }),
  importUrl: '/mom/base/routing/importData',
  importTemplateUrl: '/mom/base/routing/importTemplate'
}

export const operationApi = crud('operation', 'operationId')
export const stepApi = crud('step', 'stepId')
