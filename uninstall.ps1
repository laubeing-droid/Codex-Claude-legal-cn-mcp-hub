<#
.SYNOPSIS
  卸载中国法律 MCP 连接器配置
.DESCRIPTION
  从所有检测到的 MCP 客户端配置文件中移除本仓库安装的 MCP 连接器。
  支持 Codex Desktop (TOML) 和 Claude Code / Claude Desktop (JSON)。
#>

$ErrorActionPreference = 'Stop'
$MyDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 加载检测模块
. "$MyDir\detect.ps1"

Write-Host '=== 卸载中国法律 MCP 连接器 ===' -ForegroundColor Yellow
Write-Host ''

$envs = Get-EnvironmentInfo
$activeEnvs = $envs | Where-Object { $_.Installed }

if ($activeEnvs.Count -eq 0) {
    Write-Host '未检测到已安装的 MCP 客户端环境。' -ForegroundColor DarkGray
    $codexFallback = @{
        Name = 'codex'; Display = 'Codex Desktop'
        ConfigPath = "$env:USERPROFILE\.codex\config.toml"
        Format = 'toml'; Installed = $true; McpSection = 'mcp_servers'
    }
    $activeEnvs = @($codexFallback)
}

$confirm = Read-Host '将从所有检测到的 MCP 客户端配置中移除法律连接器，确认？(y/N)'
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host '取消卸载。' -ForegroundColor Green
    exit 0
}

foreach ($e in $activeEnvs) {
    if (-not (Test-Path $e.ConfigPath)) {
        Write-Host "  [!]  $($e.Display): 配置文件不存在" -ForegroundColor DarkGray
        continue
    }

    $content = Get-Content $e.ConfigPath -Encoding UTF8 -Raw
    $original = $content
    $removed = @()

    if ($e.Format -eq 'toml') {
        # 移除 chineselaw
        if ($content -match '(?ms)^\[mcp_servers\.chineselaw\].*?(?=\[mcp_servers\.|\z)') {
            $content = $content -replace '(?ms)^\[mcp_servers\.chineselaw\].*?(?=\[mcp_servers\.|\z)', ''
            $removed += 'chineselaw'
        }
        # 移除所有 pkulaw-* 服务
        foreach ($section in @('pkulaw-law-search','pkulaw-law-keyword','pkulaw-case-semantic-search','pkulaw-case-keyword',
            'pkulaw-law-item-keyword','pkulaw-law-recognition','pkulaw-case-number-recognition',
            'pkulaw-citation-validator','pkulaw-doc-link','pkulaw-semantic-nlsql')) {
            $re = "(?ms)^\[mcp_servers\.\Q$section\E\].*?(?=\[mcp_servers\.|\z)"
            if ($content -match $re) {
                $content = $content -replace $re, ''
                $removed += $section
            }
        }
    } else {
        # JSON 格式（Claude）
        try {
            $json = $content | ConvertFrom-Json
            $config = @{}
            $json.PSObject.Properties | ForEach-Object { $config[$_.Name] = $_.Value }

            $servers = @{}
            if ($config.ContainsKey('mcpServers')) {
                $config['mcpServers'].PSObject.Properties | ForEach-Object { $servers[$_.Name] = $_.Value }
            }
            $toRemove = @('chineselaw') + @('pkulaw-law-search','pkulaw-law-keyword','pkulaw-case-semantic-search','pkulaw-case-keyword',
                'pkulaw-law-item-keyword','pkulaw-law-recognition','pkulaw-case-number-recognition',
                'pkulaw-citation-validator','pkulaw-doc-link','pkulaw-semantic-nlsql')
            foreach ($name in $toRemove) {
                if ($servers.ContainsKey($name)) {
                    $servers.Remove($name)
                    $removed += $name
                }
            }
            $config['mcpServers'] = $servers
            $content = $config | ConvertTo-Json -Depth 10
        } catch {
            Write-Host "  [!!] $($e.Display): 配置文件格式错误，跳过" -ForegroundColor Red
            continue
        }
    }

    if ($content -ne $original) {
        # 清理多余的空行
        $content = $content -replace '`n{3,}', "`n`n"
        $content = $content.Trim()
        Set-Content -Path $e.ConfigPath -Value $content -Encoding UTF8
        Write-Host "  [OK] $($e.Display): 移除了 $($removed.Count) 个连接器" -ForegroundColor Green
        foreach ($r in $removed) {
            Write-Host "       - $r" -ForegroundColor DarkGray
        }
    } else {
        Write-Host "  [!]  $($e.Display): 未找到法律连接器配置" -ForegroundColor DarkGray
    }
}

Write-Host ''
Write-Host '卸载完成。重启对应客户端使生效。' -ForegroundColor Green
Write-Host '注：本操作仅移除 MCP 连接器配置，不会删除技能文件或其他数据。' -ForegroundColor Cyan
