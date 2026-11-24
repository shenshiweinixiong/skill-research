# 刘安祺：本机前后端运行验证

验证时间：2026-11-24（UTC+8）。此文件是本机操作记录，不是老师系统的提交回执。

## 工程

- 前端：PPT 指定的 `ymxiong/rsi-skill-platform`，本机目录 `rsi-skill-platform/`；额外依赖 `rsi-flow-visual/`。
- 后端：PPT 指定的 `ymxiong/rsi-skill-spring-boot`，本机目录 `rsi-skill-spring-boot/`。
- Java 8（Temurin 1.8.0_512）；Maven 3.9.11；使用 Node 24.21.0；本机系统 PATH 上另有 Node 26，不作为本项目的验证 Node。
- MySQL 8 位于仅绑定 `127.0.0.1:3306` 的本地隔离容器。后端以本地数据库覆盖开发配置，关闭 Eureka；不连生产数据库。

## 实际检验

| 项目 | 命令或地址 | 结果 |
| --- | --- | --- |
| 后端构建 | `mvn -s <本机私服 settings.xml> -DskipTests package` | 成功生成 `core-starter-1.0.0-executable.jar`；未执行测试 |
| 后端启动 | `java -jar ... --spring.profiles.active=dev`，本地 MySQL，关闭 Eureka | Spring Boot 启动，端口 33477 |
| 后端 API 文档 | `http://127.0.0.1:33477/v2/api-docs` | HTTP 200，标题 `skillTesting-core` |
| 前端开发服务 | Node 24 + `next dev --webpack -p 3000` | 首页 `http://127.0.0.1:3000/` HTTP 200 |
| 前后端连接 | `http://127.0.0.1:3000/skillTesting-core/v2/api-docs` | 通过 Next 开发代理 HTTP 200 |
| 前端打包 | `next build --webpack` | 首页和 `/officebench` 两个静态页面构建成功 |
| 个人编排页面 | `http://127.0.0.1:3000/officebench` | HTTP 200，可视化画布与导出按钮可渲染；未证明实际运行技能 |

注意：空流程调用返回应用层 HTTP 700，因此不能作为流程执行成功的证据。静态导出模式不应用开发代理，不能凭构建成功断言导出网页可直接调用后端；原工程全量 TypeScript 检查存在已有报错，生产构建设置为跳过类型错误。`127.0.0.1` 只在我的电脑上可访问，GitHub 仓库链接也不能替代本机运行截图/录屏（如系统要求）。

## GitHub 公开验证仓库提交注意

1. 本仓库为**公开、无教师源码**的运行验证材料；教师源码再发布权限尚未确认，勿将教师 ZIP 解压目录复制到此仓库。
2. 不要上传私服 `settings.xml`、`application-test.yaml` 中的真实数据库口令、任何 `.env`、`node_modules/`、`target/`、`.next/`、`out/`、Docker 数据卷、原始 trace/usage。教师源码 ZIP 自带配置可能含凭据，上传前必须逐文件检查。若已经上传泄露内容，删除提交历史并联系负责人轮换密钥。
3. 系统表单如要求仓库链接，填写实际 `https://github.com/<你的账号>/<仓库名>`，不要填本机的 localhost 地址；如系统明确要求前后端源码，本仓库不包含源码，需要先问老师授权与提交方式。
4. 本工作区原有 Git 远端是另一项 `officebench-harness-experiment`，并非这两个教师项目的原始仓库；不要把当前整个混合工作区直接推送到新仓库。
5. 周五的研究成果目前只是 OfficeBench `2-13/0` 的人工编排设计，尚未注册/执行，未达成“修复至少十个具体问题”；提交时按此状态如实说明。
