# 2026-11-24 前后端本机接入验证

> 本仓库目前只包含本人本机验证记录与截图，不包含教师项目源码、私服账号、数据库配置或可执行构建产物。教师项目上传权限尚未确认，不能将本仓库描述成前后端代码仓库或“已完成注册/运行 skill”。

## 项目来源与环境

| 角色 | 教师原始仓库 | 本机验证 |
| --- | --- | --- |
| 前端：skill 编排平台 | [ymxiong/rsi-skill-platform](https://github.com/ymxiong/rsi-skill-platform) | Node 24.21.0，Next.js 16.2.6，监听 3000 |
| 后端：skill 项目 | [ymxiong/rsi-skill-spring-boot](https://github.com/ymxiong/rsi-skill-spring-boot) | Java 8，Maven 3.9.11，Spring Boot，监听 33477 |
| 前端依赖：可视化基座 | [ymxiong/rsi-flow-visual](https://github.com/ymxiong/rsi-flow-visual) | 本机先编译缺失的 `dist` |
| 注册中心（本轮未接入） | [ymxiong/spring-center](https://github.com/ymxiong/spring-center) | 未声称已完成注册中心业务链路 |

源码从教师仓库 ZIP 解压，并非保留历史的 `git clone`。本机启动隔离 MySQL 8，绑定 `127.0.0.1:3306`；后端开发配置改由启动参数指向本地数据库，并关闭 Eureka。构建后端时使用了**本机工作区外**的私服 `settings.xml`，该文件未纳入本仓库。

## 实际验证结果

| 验证项 | 结果 | 对应证据 |
| --- | --- | --- |
| 后端 Maven 构建 | `-DskipTests package` 成功，生成 `core-starter-1.0.0-executable.jar`；未跑测试 | [详细记录](docs/LOCAL_VERIFICATION.md) |
| 后端 API | `http://127.0.0.1:33477/v2/api-docs`，HTTP 200；Swagger 标题 `skillTesting-core` | [本机截图](evidence/backend-swagger.png) · [状态记录](evidence/http-check.json) |
| 前端首页 | `http://127.0.0.1:3000/`，HTTP 200 | [状态记录](evidence/http-check.json) |
| 前端新编排页 | `http://127.0.0.1:3000/officebench`，HTTP 200；编排画布页面 | [状态记录](evidence/http-check.json) |
| 浏览器真实请求后端 | 前端服务提供的检查页经开发代理读取后端 JSON 并显示 `skillTesting-core`、`1.0.0` 与后端接口 | [连通截图](evidence/frontend-officebench.png) · [检查页源码](frontend-proof/integration-check.html) |
| Node/Java 版本 | 本机 Node 24.21.0、Temurin Java 8；下方两服务状态由浏览器即时检查 | [版本与服务截图](evidence/versions-and-services.png) · [依赖表](docs/DEPENDENCIES.md) |
| 前后端代理接入 | `http://127.0.0.1:3000/skillTesting-core/v2/api-docs`，HTTP 200 | [状态记录](evidence/http-check.json) |
| 前端生产构建 | `next build --webpack` 成功导出首页及 `/officebench` | [详细记录](docs/LOCAL_VERIFICATION.md) |

**验证边界：** 这些 `127.0.0.1` 地址只在本人电脑有效。浏览器检查页成功读取后端 JSON 证明前后端开发代理接入，**不等于**注册、检索或执行 skill 全链路成功。发送空结构到流程 API 得到业务层 HTTP 700，没有把它算作成功。原工程的生产构建配置跳过 TypeScript 类型错误；未声称全量类型检查通过。静态导出不会自动保留开发代理。此公开仓库不包含教师前后端工程源码，挑战档复现依赖项目源码、私服授权和可视化库兼容性调整，不能保证仅凭本仓库一小时内无阻碍复现。

## 本仓库内容

- `evidence/http-check.json`：2026-11-24 的四个端点 HTTP 状态及后端 Swagger 标题，不含 API 响应数据。
- `evidence/backend-swagger.png`：本机后端 Swagger UI 截图。
- `evidence/frontend-officebench.png`：前端实际请求 `/skillTesting-core/v2/api-docs` 后展示后端服务名、版本和接口的截图；对应自写检查页源码在 `frontend-proof/integration-check.html`，不是原项目前端自带的功能。
- `evidence/versions-and-services.png`：版本输出文字记录与浏览器即时验证的两服务 HTTP 200；版本部分不是终端原始截图，复核时请重跑 `node -v` 和 `java -version`。
- `docs/REPRODUCE.md`：按顺序整理的本机启动、验证命令及已知安装阻碍。
- `docs/DEPENDENCIES.md`：本机依赖版本清单。
- `docs/LOCAL_VERIFICATION.md`：本机验证结果。

