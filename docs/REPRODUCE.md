# Windows 本机复现记录（2026-11-24）

本文复现的是 **Node 前端可访问、Java 后端可访问、前端代理可以读取后端 API 文档**，不是生产环境部署，也不是 skill 执行业务成功。教师源码仓库未复制到本公开仓库；需要自己从对应源仓库获取。后端私服配置须由有权限的老师提供，不要把凭据推到 GitHub。

## 前置条件

- Windows 11；Java 8（Temurin 1.8.0_512）；Maven 3.9.11；Node 24.21.0；pnpm 11.28.5；Docker Desktop + MySQL 8.0。
- 将 `rsi-skill-spring-boot`、`rsi-skill-platform`、`rsi-flow-visual` 放在同一个父目录下。这些项目最初来自老师仓库 ZIP，并非本仓库包含它们的 Git 历史。
- 获取有权访问 `com.horsecoder:auth:0.1.15` 等私有 Maven 依赖的个人 `settings.xml`，保存在仓库之外。不要使用源码中可能存在的 test/remote 数据库凭据。
- 以下 PowerShell 命令中将 `$root`、`$maven`、`$node`、`$settings` 换成本机实际路径；在**不同终端**分别运行构建、后端和前端。不要在截图或日志中展示真实口令。

## 1. 本地 MySQL

启动 Docker Desktop，使用本机自设的口令创建一次容器；此端口仅绑定本机回环地址：

```powershell
# 容器已存在时使用 docker start liuanqi-skill-mysql，而不是重复 docker run。
docker run --name liuanqi-skill-mysql `
  -e MYSQL_ROOT_PASSWORD='<自行设置本地口令>' `
  -e MYSQL_DATABASE=skill_local `
  -p 127.0.0.1:3306:3306 -d mysql:8.0
docker exec liuanqi-skill-mysql mysqladmin ping -h 127.0.0.1 -uroot -p
```

MySQL 镜像拉取受网络影响；本机在 Docker Hub 超时后使用 Docker 镜像代理拉取同版镜像。对新的复现者，优先尝试官方 `mysql:8.0`。仅这一步可能需要较长网络时间。

## 2. 构建可视化库

教师 `rsi-flow-visual` ZIP 不含 `dist`。本机为旧 Rollup 构建补充了 `@babel/preset-react@7.28.5`、`@babel/preset-typescript@7.28.5`、`@rollup/pluginutils@5.5.1` 和 `tslib@2.6.3`，并在其 `rollup.config.js` 的 Babel `presets` 列表加入 React/TypeScript presets。**未经相同调整，原 ZIP 的 `yarn build` 不保证成功；这不是无修改的一键复现。**

```powershell
$root = 'C:\path\to\three-sibling-projects'
$node = 'C:\path\to\node-24\node.exe'
$pnpm = 'C:\path\to\pnpm.mjs'
Set-Location "$root\rsi-flow-visual"
& $node $pnpm install --ignore-scripts --config.node-linker=hoisted
& $node $pnpm add -D @babel/preset-react@7.28.5 @babel/preset-typescript@7.28.5 @rollup/pluginutils@5.5.1 tslib@2.6.3 --ignore-scripts --config.node-linker=hoisted
# 同步调整 rollup.config.js 的 Babel presets 后：
& $node .\node_modules\rollup\dist\bin\rollup -c
Test-Path .\dist\index.js
```

本机旧版 Rollup TypeScript 插件在 Node 24 对其嵌套 `tslib` 的 `exports` 可能报 `Package subpath ... is not defined by "exports"`。此时按错误定位兼容性，或使用经老师确认的已打包可视化库；不可盲目声称旧仓库可原样构建。此工程版本组合尚不构成可保证“一小时内全自动复现”的标准安装包。

## 3. 构建并启动 Java 后端

```powershell
$maven = 'C:\path\to\apache-maven-3.9.11\bin\mvn.cmd'
$settings = 'C:\private\settings.xml' # 工作区外，禁止上传
Set-Location "$root\rsi-skill-spring-boot"
& $maven -s $settings -DskipTests package
# 给本机启动时单独设置口令；下面写占位符，不要将真实值提交 Git。
java -jar .\core-starter\target\core-starter-1.0.0-executable.jar `
  --spring.profiles.active=dev `
  '--spring.datasource.url=jdbc:mysql://127.0.0.1:3306/skill_local?useSSL=false&serverTimezone=Asia/Shanghai' `
  --spring.datasource.username=root `
  '--spring.datasource.password=<自行设置本地口令>' `
  --eureka.client.enabled=false `
  --spring.redis.host=127.0.0.1
```

待控制台出现 `Started AppStarter`、Tomcat 监听 33477，再访问 `http://127.0.0.1:33477/v2/api-docs`，应取得包含 `info.title = skillTesting-core` 的 JSON。后端默认开发配置指向远端数据库和 Eureka，本记录使用启动参数覆盖，不向老师服务写数据。

## 4. 启动 Node 前端并测试代理

```powershell
Set-Location "$root\rsi-skill-platform"
& $node $pnpm install --config.node-linker=hoisted
# 若本地 file:../rsi-flow-visual 安装时未带入刚生成的 dist，先确认其依赖副本包含 dist/index.js。
& $node .\node_modules\next\dist\bin\next dev --webpack -p 3000
```

验证：

```powershell
& $node -v
java -version
Invoke-RestMethod http://127.0.0.1:33477/v2/api-docs | Select-Object -ExpandProperty info
Invoke-RestMethod http://127.0.0.1:3000/skillTesting-core/v2/api-docs | Select-Object -ExpandProperty info
```

前端原首页 `http://127.0.0.1:3000/`，研究草图 `http://127.0.0.1:3000/officebench`。把本仓库 `frontend-proof/integration-check.html` 和 `frontend-proof/versions-check.html` 放到教师前端工程 `public/` 下，再访问 `http://127.0.0.1:3000/integration-check.html`：页面里的脚本会在**浏览器中**发同源请求，成功才显示后端服务名、版本和路径；失败会显示错误。这两个自写的检查页只供开发验证，不是教师原项目自带页面。

`next.config.ts` 原配置使用 `output: 'export'` 和开发专用 `rewrites`。`next build --webpack` 可导出静态页面，但**静态导出不会提供该开发代理**；应在 `next dev` 下检查连通。

## 证据口径

- [后端 Swagger 界面](../evidence/backend-swagger.png)证明后端 HTTP 界面可访问。
- [前端实际读取后端数据的页面](../evidence/frontend-officebench.png)是浏览器成功请求后端代理、显示 `skillTesting-core` 和真实接口后才截取的；检查页源码见 [integration-check.html](../frontend-proof/integration-check.html)。
- [版本与两服务状态](../evidence/versions-and-services.png)包含本机 `node -v`、`java -version` 输出的文字记录，并在浏览器即时确认两服务 HTTP 200；版本文字不是终端原始截图，复现者应在自己的终端重跑版本命令。
- [HTTP 状态 JSON](../evidence/http-check.json)仅记录当时的本机测试结果；外人无法访问本机 `127.0.0.1`。

构建时使用 `-DskipTests`；并未证明所有自动化测试或完整业务技能流程通过。不存在保证无私服配置或缺少可视化构建产物仍可复现的承诺。
