# MOM Backend

后端服务提供系统基础能力和 MOM 业务接口，包含权限认证、菜单权限、字典参数、编码规则、基础数据、PBOM、MBOM、生产管理和数据追溯等模块。

## 目录说明

- `ruoyi-admin/`：后端启动模块和 Web Controller。
- `ruoyi-system/`：系统与 MOM 业务领域模型、Mapper、Service。
- `ruoyi-common/`：通用工具、注解、异常、Excel 导入导出等基础能力。
- `ruoyi-framework/`：安全、数据源、Redis、过滤器等基础配置。
- `ruoyi-quartz/`：定时任务模块。
- `sql/`：数据库脚本。
- `ruoyi-admin/src/main/resources/db/init-h2.sql`：本地 H2 初始化脚本。
- `dev-mini-redis.py`：本地开发用的轻量 Redis 兼容服务。

## 本地启动

```bash
# 启动本地 Redis 兼容服务
python3 dev-mini-redis.py

# 启动后端，使用 H2 本地数据库配置
java -jar ruoyi-admin/target/ruoyi-admin.jar --spring.profiles.active=h2
```

默认端口：`8080`

## 数据库

数据库脚本位置：

- `sql/ry_20260320.sql`
- `sql/quartz.sql`
- `ruoyi-admin/src/main/resources/db/init-h2.sql`

本地 H2 数据文件属于运行时文件，不建议提交到仓库。
