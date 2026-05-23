# 贡献指南

## 仓库结构

```
Codex-Claude-legal-CN-mcp-connectors/
  README.md                 独立说明 + 快速配置
  QUICKSTART.md             60秒快速入门
  CHANGELOG.md              版本历史
  LICENSE                   许可证
  .gitattributes            Git 属性

  install.ps1 / install.sh  通用安装脚本
  verify.ps1 / verify.sh    通用验证脚本
  update.ps1 / update.sh    通用更新诊断脚本
  uninstall.ps1 / uninstall.sh  卸载脚本（移除 MCP 配置）
  detect.ps1 / detect.sh    环境检测模块

  docs/
    architecture.md          架构说明
    connectors.md            连接器配置指南（完整）
    usage-guide.md           使用指南
    troubleshooting.md       常见问题排查
    contributing.md          本文件

  .github/workflows/
    npm-monitor.yml          每周检查 chineselaw-mcp / @pkulaw/mcp-cli 版本
```

## 修改脚本注意事项

### 格式适配

当新增连接器或修改配置格式时，需要同时更新：
- **TOML 格式**（Codex）：`install.ps1` 中的 `Write-McpToCodex` 调用
- **JSON 格式**（Claude）：`install.ps1` 中的 `Write-McpToClaude` 调用
- **bash 版本**：`install.sh` 中的对应逻辑

### 凭证安全

- Token 和 API Key 通过 `Read-Host` 交互式输入，不写入终端历史
- 永远不要将真实 Token 提交到 Git
- config.toml 和 settings.json 中的占位符（YOUR_API_KEY / YOUR_ACCESS_TOKEN）需要在文档和脚本中明确提示替换

### 测试变更

1. 运行 `.\install.ps1` 测试交互式安装
2. 运行 `.\verify.ps1` 测试验证逻辑
3. 运行 `.\update.ps1` 测试诊断逻辑
4. PowerShell 语法检查：`[System.Management.Automation.Language.Parser]::ParseInput(...)`

### 编码规范

- PowerShell 脚本使用 UTF8 编码
- Bash 脚本使用 UTF8 编码
- Markdown 文档使用 UTF8 编码
- 行尾：PowerShell 使用 CRLF，Bash 使用 LF（由 .gitattributes 控制）

## 版本号规则

- v1.x：初始版本（Codex 仅 TOML）
- v1.1.x：新增脚本（update.ps1, install.sh 等）
- v1.2.x：多环境支持（detect 模块 + Claude JSON 格式）
- 重大变更升级主版本号


