# 刘安祺 | 2026-11-24 前后端本机接入验证

> 本仓库只包含本人本机验证记录与截图，不包含教师项目源码、私服账号、数据库配置或可执行构建产物。教师项目上传权限尚未确认，不能将本仓库描述成前后端代码仓库或“已完成注册/运行 skill”。

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
| 前端新编排页 | `http://127.0.0.1:3000/officebench`，HTTP 200；编排画布页面 | [本机截图](evidence/frontend-officebench.png) · [状态记录](evidence/http-check.json) |
| 前后端代理接入 | `http://127.0.0.1:3000/skillTesting-core/v2/api-docs`，HTTP 200 | [状态记录](evidence/http-check.json) |
| 前端生产构建 | `next build --webpack` 成功导出首页及 `/officebench` | [详细记录](docs/LOCAL_VERIFICATION.md) |

**验证边界：** 这些 `127.0.0.1` 地址只在本人电脑有效。HTTP 200 证明本地页面、API 文档与开发代理可访问，**不等于**注册、检索或执行 skill 全链路成功。发送空结构到流程 API 得到业务层 HTTP 700，没有把它算作成功。原工程的生产构建配置跳过 TypeScript 类型错误；未声称全量类型检查通过。静态导出不会自动保留开发代理。

## 本仓库内容

- `evidence/http-check.json`：2026-11-24 的四个端点 HTTP 状态及后端 Swagger 标题，不含 API 响应数据。
- `evidence/backend-swagger.png`：本机后端 Swagger UI 截图。
- `evidence/frontend-officebench.png`：独立的前端 OfficeBench 页面截图；页面只展示人工编排设计，不代表 skill 实际执行。
- `docs/LOCAL_VERIFICATION.md`：完整的运行范围、限制和源码上传注意事项。

## 如何由有权访问源码的人复核

1. 从上述教师仓库获取三个项目，放成同级目录。后端另需老师提供的 Maven 私服配置；**不要把配置或密钥交到公开仓库**。
2. 安装 Java 8、Maven、Node 24、包管理器及本机 MySQL 8。前端依赖本地 `../rsi-flow-visual`，先构建它的 `dist`，再安装前端依赖。
3. 在后端目录执行 `mvn -s <私服配置路径> -DskipTests package`；以开发 profile 启动构建出的可执行 JAR，并通过启动参数指定本人**本地**数据库和禁用 Eureka。
4. 在前端目录运行 `next dev --webpack -p 3000`，逐一请求上表的 4 个地址。具体本机命令与注意事项见 [详细记录](docs/LOCAL_VERIFICATION.md)。

## 截止与待办

今晚提交的是**环境构建及本机接入验证**。11 月 27 日的个人课题“基于人工结构设计的多 skill 融合方法研究 / OfficeBench”尚在进行：已经设计一个独立的 `2-13/0` 人工编排示例，但**尚未注册、执行、通过原生评分，已证明修复的题目数为 0/10**。该研究结果不应混入今晚的环境证明。

系统提交链接建议填写这个仓库的**实际 GitHub 地址**（推送后才有）。若老师要求提交可运行的前后端源码而非验证记录，应先确认教师源码的再发布权限并使用老师指定的提交方式；当前仓库不满足“包含前后端工程源码”的更严格要求。
