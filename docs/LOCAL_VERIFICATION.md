# 本机前后端运行验证

验证时间：2026-11-24（UTC+8）。

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
| 前后端连接 | `http://127.0.0.1:3000/skillTesting-core/v2/api-docs` | 通过 Next 开发代理 HTTP 200；浏览器从前端检查页实际读到后端返回的 `skillTesting-core`、版本和 3 个 API 路径 |
| 版本 | `node -v` / `java -version` | Node 24.21.0 / Temurin Java 1.8.0_512；文字记录在版本截图，复核者应在自己的终端重跑 |
| 前端打包 | `next build --webpack` | 首页和 `/officebench` 两个静态页面构建成功 |
| 个人编排页面 | `http://127.0.0.1:3000/officebench` | HTTP 200，可视化画布页面；未证明实际运行技能 |

[前端连通性截图](../evidence/frontend-officebench.png)在浏览器执行 [检查页脚本](../frontend-proof/integration-check.html)，仅在实际请求同源开发代理并收到 `skillTesting-core` 的 API 文档后截取。[后端 Swagger 截图](../evidence/backend-swagger.png)单独证明 Java 服务可访问。[版本与服务截图](../evidence/versions-and-services.png)的版本文字来自本机命令输出，但不是终端原始截图；现场复核可运行 [验证脚本](../scripts/verify-local.ps1) 或按 [复现步骤](REPRODUCE.md) 重跑。
