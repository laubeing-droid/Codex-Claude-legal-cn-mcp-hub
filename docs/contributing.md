# 贡献指南

## 开发环境

```
Codex-Claude-legal-cn-mcp-hub/
├── README.md                 仓库主页
├── QUICKSTART.md             快速入门
├── CHANGELOG.md              版本历史
├── LICENSE                   MIT 许可证
├── .gitattributes            Git 行尾配置
├── .gitignore                忽略模式
│
├── install.ps1 / install.sh  安装脚本（全环境写入）
├── verify.ps1 / verify.sh    验证脚本
├── update.ps1 / update.sh    更新诊断脚本
├── uninstall.ps1 / uninstall.sh  卸载脚本
├── detect.ps1 / detect.sh    环境检测模块
│
├── docs/
│   ├── connectors.md         连接器配置参考
│   ├── usage-guide.md        使用指南
│   ├── architecture.md       架构说明
│   ├── troubleshooting.md    常见问题排查
│   └── contributing.md       本文件
│
└── .github/workflows/
    └── npm-monitor.yml       npm 包版本监控
```

## 修改脚本注意事项

### 新增连接器
需要同步修改以下位置：
1. **PS1 版本**：`install.ps1` 中的 `Write-McpToCodex`（TOML）和 `Write-McpToClaude`（JSON）调用
2. **Bash 版本**：`install.sh` 中的对应逻辑
3. **检测模块**：`detect.ps1` / `detect.sh` 如需支持新客户端
4. **docs**：connectors.md 新增服务清单，usage-guide.md 补充说明

### 跨平台同步
- 修改 `.ps1` 后必须同步修改 `.sh`
- 两种脚本逻辑保持对等，差异仅限语法层面（PowerShell vs Bash）
- 行尾由 `.gitattributes` 控制：PS1/MD→LF，无需手动处理

### 凭证安全
- Token / API Key 通过 `Read-Host` 交互式输入，不写入终端历史
- 永远不要将真实 Token 提交到 Git
- 占位符（`YOUR_API_KEY` / `YOUR_ACCESS_TOKEN`）需在脚本和文档中明确提示

### 测试变更
```powershell
.\install.ps1     # 测试交互式安装
.\verify.ps1      # 测试验证逻辑
.\update.ps1      # 测试诊断逻辑
.\uninstall.ps1   # 测试卸载逻辑
```
建议在 Windows + macOS/Linux 双平台测试。

### 编码规范
- 所有文件使用 UTF-8 编码
- PowerShell 使用 CRLF，Bash 使用 LF
- 文档使用 Markdown 格式

## 版本号规则

遵循语义化版本 `vMAJOR.MINOR.PATCH`：
- **MAJOR**：破坏性变更（脚本参数不兼容、配置文件格式变更）
- **MINOR**：新增功能（新服务、新环境支持、新脚本）
- **PATCH**：Bug 修复、文档更新、配置调整

发版步骤：
1. 更新 `CHANGELOG.md`
2. `git tag vX.Y.Z && git push origin vX.Y.Z`

## PR 流程

1. Fork 本仓库
2. 创建功能分支
3. 修改并测试
4. 提交 PR 到 main 分支
