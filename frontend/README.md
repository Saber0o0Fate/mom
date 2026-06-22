# MOM Frontend

前端管理端用于维护 MOM 系统中的基础数据、生产资源、工艺路线、PBOM、MBOM、生产管理和数据追溯等业务功能。

## 技术栈

- Vue 3
- Vite
- Element Plus
- Pinia
- Vue Router

## 本地启动

```bash
npm install
npm run dev -- --host 0.0.0.0
```

默认访问地址：

- 本机：http://localhost/
- 局域网：以启动日志中的 `Network` 地址为准

## 接口代理

开发环境接口前缀为 `/dev-api`，由 Vite 代理到后端：

```text
http://localhost:8080
```

配置文件：

- `.env.development`
- `vite.config.js`

## 主要页面

- `src/views/mom/base/material`：物料数据
- `src/views/mom/base/materialCategory`：物料分类
- `src/views/mom/base/resource`：生产资源
- `src/views/mom/base/routing`：工艺路线
- `src/views/mom/mbom`：MBOM 维护
- `src/views/mom/pbom`：PBOM 维护
- `src/views/system/codeRule`：编码规则

构建产物 `dist/` 和依赖目录 `node_modules/` 不纳入版本库。
