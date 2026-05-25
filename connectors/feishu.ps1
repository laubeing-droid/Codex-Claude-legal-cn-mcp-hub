<#
.SYNOPSIS
  飞书连接器 — 工作流协作（文档/消息/日历/文件）
.DESCRIPTION
  App ID + App Secret → Lark MCP 全开
#>
function Install-Feishu {
    param(
        [Parameter(Mandatory=$true)]
        [array]$ActiveEnvs,

        [string]$AppId = '',
        [string]$AppSecret = ''
    )

    Write-Host "=== 飞书 — 工作流协作 ===" -ForegroundColor Cyan
    Write-Host "  开通: https://open.feishu.cn/app → 创建应用 → 获取凭证" -ForegroundColor DarkGray
    Write-Host ""

    # ── 凭证 ──
    if ([string]::IsNullOrWhiteSpace($AppId)) {
        $AppId = Read-Host '  App ID（回车跳过）'
    }
    if ([string]::IsNullOrWhiteSpace($AppId)) {
        Write-Host "  [跳过] 飞书 — 未提供凭证" -ForegroundColor DarkYellow
        Write-Host "  后续运行 install.ps1 或 .\connectors\feishu.ps1 配置" -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    if ([string]::IsNullOrWhiteSpace($AppSecret)) {
        $AppSecret = Read-Host '  App Secret'
    }
    if ([string]::IsNullOrWhiteSpace($AppSecret)) {
        Write-Host "  [跳过] 飞书 — App Secret 不能为空" -ForegroundColor DarkYellow
        Write-Host ""
        return
    }

    # ── 前置: Node.js ──
    $nodeOk = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeOk) {
        Write-Host "  [!!] Node.js 未安装 — 飞书 MCP 需要 Node.js。跳过。" -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "  App ID: $($AppId.Substring(0, [Math]::Min(8, $AppId.Length)))..." -ForegroundColor DarkGray
    Write-Host ""

    # ── MCP — npx @larksuiteoapi/lark-mcp ──
    Write-Host "  [MCP] 注册飞书 MCP..." -ForegroundColor Yellow
    $feishuCfg = Get-FeishuConfig -AppId $AppId -AppSecret $AppSecret
    $feishuTomb = Get-FeishuToml -AppId $AppId -AppSecret $AppSecret

    foreach ($e in $ActiveEnvs) {
        if ($e.Format -eq 'toml') {
            $added = Write-McpToCodex -ConfigPath $e.ConfigPath -Section 'feishu' -TomlBlock $feishuTomb
        } else {
            $added = Write-McpToClaude -ConfigPath $e.ConfigPath -ServerId 'feishu' -ServerConfig $feishuCfg
        }
        $icon = if ($added) { '+' } else { '=' }
        Write-Host "    [$icon] $($e.Display)" -ForegroundColor $(if ($added) { 'Green' } else { 'DarkGray' })
    }

    # ── API — 保存凭证 ──
    Write-Host "  [API] 保存凭证..." -ForegroundColor Yellow
    $envFile = "$env:USERPROFILE\.codex-mcp\feishu.env"
    $null = New-Item -ItemType Directory -Force (Split-Path -Parent $envFile)
    @"
LARK_APP_ID=$AppId
LARK_APP_SECRET=$AppSecret
"@ | Set-Content -Path $envFile -Encoding UTF8
    Write-Host "    [+] 凭证已保存: $envFile" -ForegroundColor Green

    Write-Host ""
    Write-Host "  飞书配置完成 — MCP + API 全开" -ForegroundColor Green
}
