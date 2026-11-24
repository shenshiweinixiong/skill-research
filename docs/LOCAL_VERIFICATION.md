# 本机前后端运行验证

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

