param(
  [string]$Frontend = 'http://127.0.0.1:3000',
  [string]$Backend = 'http://127.0.0.1:33477'
)

$ErrorActionPreference = 'Stop'
Write-Host 'Node:'
node -v
Write-Host 'Java:'
java -version

$front = Invoke-WebRequest -UseBasicParsing -Uri "$Frontend/officebench"
$back = Invoke-RestMethod -Uri "$Backend/v2/api-docs"
$proxied = Invoke-RestMethod -Uri "$Frontend/skillTesting-core/v2/api-docs"

if ($front.StatusCode -ne 200) { throw "Frontend failed: HTTP $($front.StatusCode)" }
if ($back.info.title -ne 'skillTesting-core') { throw 'Unexpected direct backend response' }
if ($proxied.info.title -ne $back.info.title) { throw 'Proxy/backend identity mismatch' }
if (-not $proxied.paths.'/api/engine/flow') { throw 'Flow API missing in proxied backend response' }

Write-Host "Frontend: HTTP $($front.StatusCode) ($Frontend/officebench)"
Write-Host "Backend:  $($back.info.title) $($back.info.version) ($Backend/v2/api-docs)"
Write-Host "Proxy:    $($proxied.info.title) $($proxied.info.version) ($Frontend/skillTesting-core/v2/api-docs)"
Write-Host 'Local frontend/backend API-document integration verified.'
