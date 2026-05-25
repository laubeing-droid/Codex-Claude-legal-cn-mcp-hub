<#
.SYNOPSIS
  元典智库连接器 — CLI + API + MCP 一键全开
.DESCRIPTION
  一个 API Key 同时启用：
    - MCP:   3 个 Streamable HTTP Server (法律法规/案例文书/企业信息)
    - API:   REST 端点 (https://open.chineselaw.com/open/{routeKey})
    - CLI:   API Key 写入本地凭证文件供 curl 等工具使用
#>
function Install-Yuandian {
    param(
        [Parameter(Mandatory=$true)]
        [array]$ActiveEnvs,

        [string]$ApiKey = ''
    )

    Write-Host "=== 元典智库 — 中国法律检索（35+ 工具）===" -ForegroundColor Cyan
    Write-Host "  注册: https://open.chineselaw.com → API 管理" -ForegroundColor DarkGray
    Write-Host ""

    # ── 凭证 ──
    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        $ApiKey = Read-Host '  API Key（回车跳过）'
    }
    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        Write-Host "  [跳过] 元典智库 — 未提供 API Key" -ForegroundColor DarkYellow
        Write-Host "  后续运行 install.ps1 或 .\connectors\yuandian.ps1 配置" -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    Write-Host "  API Key: $($ApiKey.Substring(0, [Math]::Min(8, $ApiKey.Length)))..." -ForegroundColor DarkGray
    Write-Host ""

    # ── MCP — 3 个 Streamable HTTP Server ──
    Write-Host "  [MCP] 注册 3 个 HTTP Server..." -ForegroundColor Yellow
    $servers = Get-YuandianHttpConfig -ApiKey $ApiKey
    foreach ($svc in $servers) {
        foreach ($e in $ActiveEnvs) {
            if ($e.Format -eq 'toml') {
                $block = Get-YuandianHttpToml -Name $svc.name -Url $svc.url -ApiKey $ApiKey
                $added = Write-McpToCodex -ConfigPath $e.ConfigPath -Section $svc.name -TomlBlock $block
            } else {
                $cfg = Get-YuandianHttpJson -Name $svc.name -Url $svc.url -ApiKey $ApiKey
                $added = Write-McpToClaude -ConfigPath $e.ConfigPath -ServerId $svc.name -ServerConfig $cfg
            }
            $icon = if ($added) { '+' } else { '=' }
            Write-Host "    [$icon] $($e.Display) -> $($svc.name) ($($svc.display))" -ForegroundColor $(if ($added) { 'Green' } else { 'DarkGray' })
        }
    }

    # ── API + CLI — 保存凭证到本地文件 ──
    Write-Host "  [API/CLI] 保存凭证..." -ForegroundColor Yellow
    $envFile = "$env:USERPROFILE\.codex-mcp\yuandian.env"
    $null = New-Item -ItemType Directory -Force (Split-Path -Parent $envFile)
    Set-Content -Path $envFile -Value "YUANDIAN_API_KEY=$ApiKey" -Encoding UTF8
    Write-Host "    [+] 凭证已保存: $envFile" -ForegroundColor Green
    Write-Host "    REST API: https://open.chineselaw.com/open/{routeKey}" -ForegroundColor DarkGray
    Write-Host "    Header:   X-API-Key: $($ApiKey.Substring(0, [Math]::Min(8, $ApiKey.Length)))..." -ForegroundColor DarkGray

    Write-Host ""
    Write-Host "  元典智库配置完成 — MCP(35+工具) + API + CLI 全开" -ForegroundColor Green
}
