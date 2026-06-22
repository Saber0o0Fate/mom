# MOM Management System

MOM 是一个面向制造现场的数据维护与生产管理系统，当前仓库包含前端、后端和数据库初始化脚本。

## 项目结构

- `backend/`：后端服务，包含系统基础能力、MOM 业务接口、数据库脚本和本地 H2 初始化脚本。
- `frontend/`：前端管理端，包含基础数据、生产资源、工艺路线、PBOM、MBOM 等业务界面。

## 主要模块

- 基础数据：物料数据、物料分类、生产资源、班次日历、工艺路线、工序/工步维护。
- 编码规则：支持业务编码规则维护，并在部分业务编码为空时自动生成。
- PBOM 管理：支持 PBOM 主数据、明细物料、投料工位维护和导入导出。
- MBOM 管理：支持按 MBOM、工序、工步、工步投料层级维护制造 BOM。
- 生产管理：包含生产计划、工单、报工、托盘等现场业务入口。
- 数据追溯：包含生产追溯、责任追溯等查询入口。

## 本地运行

后端开发环境默认使用 `backend/ruoyi-admin/src/main/resources/application-h2.yml` 中的 H2 配置，数据库结构和示例数据位于：

- `backend/sql/ry_20260320.sql`
- `backend/sql/quartz.sql`
- `backend/ruoyi-admin/src/main/resources/db/init-h2.sql`

前端开发环境默认通过 `/dev-api` 代理到后端 `http://localhost:8080`。

启动参考：

```bash
# 后端依赖的本地 Redis 兼容服务
cd backend
python3 dev-mini-redis.py

# 后端服务
java -jar ruoyi-admin/target/ruoyi-admin.jar --spring.profiles.active=h2

# 前端服务
cd ../frontend
npm install
npm run dev -- --host 0.0.0.0
```

默认访问地址：

- 前端：http://localhost/
- 后端：http://localhost:8080/

## 提交说明

运行时日志、构建产物、`node_modules`、`target` 和本地 H2 数据文件不纳入版本库。
