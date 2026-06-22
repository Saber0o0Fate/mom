import request from '@/utils/request'

export function listCodeRule(query) {
  return request({
    url: '/system/codeRule/list',
    method: 'get',
    params: query
  })
}

export function getCodeRule(ruleId) {
  return request({
    url: '/system/codeRule/' + ruleId,
    method: 'get'
  })
}

export function addCodeRule(data) {
  return request({
    url: '/system/codeRule',
    method: 'post',
    data
  })
}

export function updateCodeRule(data) {
  return request({
    url: '/system/codeRule',
    method: 'put',
    data
  })
}

export function delCodeRule(ruleIds) {
  return request({
    url: '/system/codeRule/' + ruleIds,
    method: 'delete'
  })
}

export function resetCodeRule(ruleId) {
  return request({
    url: '/system/codeRule/reset/' + ruleId,
    method: 'put'
  })
}

export function previewCode(ruleId) {
  return request({
    url: '/system/codeRule/preview/' + ruleId,
    method: 'get'
  })
}

export function nextCode(ruleCode) {
  return request({
    url: '/system/codeRule/next/' + ruleCode,
    method: 'get'
  })
}
