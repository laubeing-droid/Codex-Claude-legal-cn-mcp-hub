<#
.SYNOPSIS
  北大法宝连接器 — CLI + API + MCP 一键全开
.DESCRIPTION
  一个 Access Token 同时启用：
    - MCP:   10+ HTTP 服务 (案例检索/法条查询/法条识别/案号识别/引注校验/法宝超链等)
    - API:   https://apim-gateway.pkulaw.com/*
    - CLI:   npm install -g @pkulaw/mcp-cli
#>
function Install-Pkulaw {
    param(
        [Parameter(Mandatory=$true)]
        [array]$ActiveEnvs,

        [string]$Token = ''
    )

    Write-Host "=== 北大法宝 — 法律检索平台（多个服务）===" -ForegroundColor Cyan
    Write-Host "  注册: https://mcp.pkulaw.com → 获取 Access Token" -ForegroundColor DarkGray
    Write-Host ""

    # ── 凭证 ──
    if ([string]::IsNullOrWhiteSpace($Token)) {
        $Token = Read-Host '  Access Token（回车跳过）'
    }
    if ([string]::IsNullOrWhiteSpace($Token)) {
        Write-Host "  [跳过] 北大法宝 — 未提供 Token" -ForegroundColor DarkYellow
        Write-Host "  后续运行 install.ps1 或 .\connectors\pkulaw.ps1 配置" -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    Write-Host "  Token: $($Token.Substring(0, [Math]::Min(8, $Token.Length)))..." -ForegroundColor DarkGray
    Write-Host ""

    # ── 服务列表 ──
    $services = @(
        @{ name='pkulaw-case-semantic';            url='https://apim-gateway.pkulaw.com/mcp-case/mcp';                  display='检索司法案例-语义';      desc='自然语言查找判例' }
        @{ name='pkulaw-case-keyword';             url='https://apim-gateway.pkulaw.com/mcp-case/mcp';                  display='检索司法案例-关键词';    desc='标题/正文关键词检索' }
        @{ name='pkulaw-law-item-keyword';         url='https://apim-gateway.pkulaw.com/mcp-fatiao/mcp';                display='精准查找法条-关键词';    desc='法规名称+条号精确查询' }
        @{ name='pkulaw-law-recognition';          url='https://apim-gateway.pkulaw.com/law_recognition/mcp';           display='法条识别与溯源';          desc='识别法规名称与条款' }
        @{ name='pkulaw-case-number-recognition';  url='https://apim-gateway.pkulaw.com/case_number_recognition/mcp';  display='案号识别与溯源';          desc='案号标准化验证' }
        @{ name='pkulaw-citation-validator';       url='https://apim-gateway.pkulaw.com/pku_citation_validator/mcp';   display='修正生成幻觉-法条';      desc='分析引用返回权威条文' }
        @{ name='pkulaw-doc-link';                 url='https://apim-gateway.pkulaw.com/add-doc-link/mcp';              display='法宝超链';                desc='智能添加法规超链接' }
        @{ name='pkulaw-semantic-nlsql';           url='https://apim-gateway.pkulaw.com/assistant/mcp-pkulaw-search/mcp'; display='法宝语义检索(NL-SQL)';  desc='多库语义检索' }
    )

    Write-Host "  选择要启用的服务:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $services.Count; $i++) {
        Write-Host "    [$($i+1)] $($services[$i].display) — $($services[$i].desc)" -ForegroundColor DarkGray
    }
    Write-Host "    [a] 全部启用（推荐）" -ForegroundColor DarkGray
    Write-Host "    [回车] 全部启用" -ForegroundColor DarkGray
    $selection = Read-Host '  请输入'

    $selectedIndices = @()
    if ($selection -eq 'a' -or $selection -eq 'A' -or [string]::IsNullOrWhiteSpace($selection)) {
        $selectedIndices = 0..($services.Count - 1)
    } else {
        $selection -split ',' | ForEach-Object {
            $num = $_.Trim() -as [int]
            if ($num -ge 1 -and $num -le $services.Count) {
                $selectedIndices += $num - 1
            }
        }
    }

    if ($selectedIndices.Count -eq 0) {
        Write-Host "  [跳过] 未选择任何服务" -ForegroundColor DarkYellow
        Write-Host ""
        return
    }

    # ── MCP — 注册选中的服务 ──
    Write-Host "  [MCP] 注册 $($selectedIndices.Count) 个服务..." -ForegroundColor Yellow
    foreach ($idx in $selectedIndices) {
        $svc = $services[$idx]
        foreach ($e in $ActiveEnvs) {
            if ($e.Format -eq 'toml') {
                $block = @"
[mcp_servers.$($svc.name)]
url = "$($svc.url)"
http_headers = { Authorization = "Bearer $Token" }
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true
"@
                $added = Write-McpToCodex -ConfigPath $e.ConfigPath -Section $svc.name -TomlBlock $block
            } else {
                $cfg = Get-PkulawHttpConfig -Url $svc.url -Token $Token
                $added = Write-McpToClaude -ConfigPath $e.ConfigPath -ServerId $svc.name -ServerConfig $cfg
            }
            $icon = if ($added) { '+' } else { '=' }
            Write-Host "    [$icon] $($e.Display) -> $($svc.name)" -ForegroundColor $(if ($added) { 'Green' } else { 'DarkGray' })
        }
    }

    # ── CLI ──
    Write-Host "  [CLI] npm install -g @pkulaw/mcp-cli..." -ForegroundColor Yellow
    $npmOk = Get-Command node -ErrorAction SilentlyContinue
    if ($npmOk) {
        npm install -g @pkulaw/mcp-cli 2>&1 | Out-Null
        Write-Host "    [+] @pkulaw/mcp-cli 已安装" -ForegroundColor Green
    } else {
        Write-Host "    [!] Node.js 未安装，跳过 CLI。安装后手动: npm install -g @pkulaw/mcp-cli" -ForegroundColor DarkYellow
    }

    # ── API — 保存凭证 ──
    Write-Host "  [API] 保存凭证..." -ForegroundColor Yellow
    $envFile = "$env:USERPROFILE\.codex-mcp\pkulaw.env"
    $null = New-Item -ItemType Directory -Force (Split-Path -Parent $envFile)
    Set-Content -Path $envFile -Value "PKULAW_TOKEN=$Token" -Encoding UTF8
    Write-Host "    [+] 凭证已保存: $envFile" -ForegroundColor Green

    Write-Host ""
    Write-Host "  北大法宝配置完成 — MCP($($selectedIndices.Count)服务) + CLI + API 全开" -ForegroundColor Green
}
