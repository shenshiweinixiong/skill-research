# 本机依赖与构建版本

采集日期：2026-11-24（Windows 11）。这是本机已使用的版本清单，公开仓库不包含教师项目源码、私服凭据或依赖二进制。

| 组件 | 验证版本 | 作用与边界 |
| --- | --- | --- |
| Java | Temurin OpenJDK 1.8.0_512 | 构建/运行 Spring Boot 后端；`java -version` |
| Apache Maven | 3.9.11 | 后端多模块构建，需本人私有 `settings.xml` |
| Node.js | 24.21.0 | 前端构建和运行；显式使用 Node 24，本机 PATH 上的 Node 26 未用于本次验证 |
| pnpm | 11.28.5 | 本机前端和可视化库的依赖安装 |
| Next.js | 16.2.6 | 前端仓库 `package.json` 的版本；开发环境用 `--webpack` |
| React | 19.2.4 | 前端仓库 `package.json` 的版本 |
| Spring Boot | 2.1.9.RELEASE | 后端 Maven 父 POM 的版本 |
| MySQL | 8.0 容器镜像 | 仅回环地址的本地空 `skill_local` 库；未持久化到仓库 |
| Docker Engine | 29.9.3 | 本机运行 MySQL 容器时的服务端版本 |
| rsi-flow-visual | 0.3.12（仓库 `package.json`） | 前端 `file:../rsi-flow-visual` 依赖；教师 ZIP 不含 `dist` |
| @horsecoder/flow | 1.0.3（教师前端包含的本地包） | 流程包，不从公网仓库直接推断可安装 |

旧版可视化库在本机额外使用 `@babel/preset-react@7.28.5`、`@babel/preset-typescript@7.28.5`、`@rollup/pluginutils@5.5.1` 和 `tslib@2.6.3`，并调整 Babel presets。官方原始仓库版本与本机修复不同，具体复现风险及操作见 [REPRODUCE.md](REPRODUCE.md)。

后端还依赖 Maven 私服包 `com.horsecoder:auth:0.1.15`；缺失私服授权会在构建阶段失败。**不上传** `settings.xml`、`.env`、测试环境数据库凭据、`node_modules`、`.m2`、`target`、`.next` 和构建产物。
