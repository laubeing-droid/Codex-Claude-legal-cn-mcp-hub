<#
.SYNOPSIS
  自托管 MCP 服务 — 国家法规库 + 案例库
.DESCRIPTION
  零凭证、零交互，自动部署 Python MCP Server 到所有检测到的客户端环境。
#>
function Install-SelfHosted {
    param(
        [Parameter(Mandatory=$true)]
        [array]$ActiveEnvs
    )

    Write-Host "=== 自托管服务（国家法规库 + 案例库）===" -ForegroundColor Cyan
    Write-Host "  零凭证 · Python MCP Server · 自动部署" -ForegroundColor DarkGray
    Write-Host ""

    # ── 国家法规库 (flk-npc) ──
    Write-Host "  [flk-npc] 国家法规库..." -ForegroundColor Yellow
    $flkTomb = Get-SelfHostedFlkNpcToml
    $flkJson = Get-SelfHostedFlkNpcConfig

    foreach ($e in $ActiveEnvs) {
        if ($e.Format -eq 'toml') {
            $added = Write-McpToCodex -ConfigPath $e.ConfigPath -Section 'flk-npc' -TomlBlock $flkTomb
        } else {
            $added = Write-McpToClaude -ConfigPath $e.ConfigPath -ServerId 'flk-npc' -ServerConfig $flkJson
        }
        $icon = if ($added) { '+' } else { '=' }
        Write-Host "    [$icon] $($e.Display)" -ForegroundColor $(if ($added) { 'Green' } else { 'DarkGray' })
    }

    # ── 案例库 (rmfyalk) ──
    Write-Host "  [rmfyalk] 案例库..." -ForegroundColor Yellow
    $rmfyTomb = Get-SelfHostedRmfyalkToml -Token "anonymous"
    $rmfyJson = Get-SelfHostedRmfyalkConfig -Token "anonymous"

    foreach ($e in $ActiveEnvs) {
        if ($e.Format -eq 'toml') {
            $added = Write-McpToCodex -ConfigPath $e.ConfigPath -Section 'rmfyalk' -TomlBlock $rmfyTomb
        } else {
            $added = Write-McpToClaude -ConfigPath $e.ConfigPath -ServerId 'rmfyalk' -ServerConfig $rmfyJson
        }
        $icon = if ($added) { '+' } else { '=' }
        Write-Host "    [$icon] $($e.Display)" -ForegroundColor $(if ($added) { 'Green' } else { 'DarkGray' })
    }

    Write-Host ""
    Write-Host "  自托管服务部署完成" -ForegroundColor Green
}
