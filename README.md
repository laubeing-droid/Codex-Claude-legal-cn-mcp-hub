<!--
version: 3.1.0
-->

# Codex-Claude-legal-cn-mcp-hub

> 中国法律 MCP 连接器中心 — 自托管 + 在线服务 · Codex / Claude Code / Claude Desktop 三端通用

## 连接器一览

| 连接器 | 接入方式 | 工具 | 凭证 |
|--------|---------|------|------|
| **国家法规库** | Python 自托管（干净室） | 法规检索 | 免费无鉴权 |
| **案例库** | Python 自托管（干净室） | 案例检索 | 免费无鉴权 |
| **元典智库** | Streamable HTTP MCP | 多项工具 | API Key |
| **北大法宝** | HTTP MCP | 多项服务 | Access Token |
| **飞书** | npm stdio | 文档/消息/日历 | App ID + Secret |

## 快速开始

### 完整安装（含交互配置）
```powershell
git clone https://github.com/laubeing-droid/codex-claude-legal-cn-mcp-hub.git
cd codex-claude-legal-cn-mcp-hub
.\install.ps1
```
自动检测 MCP 客户端 → 部署自托管服务 → 交互配置元典/北大法宝/飞书。

### Quick 模式（供其他仓库作为依赖调用）
```powershell
.\install.ps1 -Quick
```
仅部署自托管服务（国家法规库 + 案例库），零交互。

## 仓库结构

```
├── install.ps1 / install.sh         # 安装入口
├── detect.ps1                       # 环境检测 + 共享函数
├── connectors/                      # 连接器模块
│   ├── self-hosted.ps1              # 国家法规库 + 案例库
│   ├── yuandian.ps1                 # 元典智库 (MCP + API + CLI)
│   ├── pkulaw.ps1                   # 北大法宝 (MCP + CLI + API)
│   └── feishu.ps1                   # 飞书工作流
├── servers/
│   ├── flk-npc/                     # 国家法规库 Python MCP Server
│   └── rmfyalk/                     # 案例库 Python MCP Server
└── docs/
```

## 支持的环境

| 客户端 | 配置路径 | 格式 |
|--------|---------|------|
| **Codex Desktop** | `~/.codex/config.toml` | TOML |
| **Claude Code** | `~/.claude/settings.json` | JSON |
| **Claude Desktop** | `%APPDATA%/Claude/claude_desktop_config.json` | JSON |

## 配套项目

| 仓库 | 说明 |
|------|------|
| [core-codices](https://github.com/laubeing-droid/codex-claude-legal-cn-core-codices) | 法律数据库 — 162 部法律全文 JSON |
| [codex-claude-legal-cn-main](https://github.com/laubeing-droid/codex-claude-legal-cn-main) | 法律技能集 — 150+ 子技能 |
| [judgment-predictor](https://github.com/laubeing-droid/codex-claude-legal-cn-judgment-predictor) | 裁判预测框架 |
| [alignment-framework](https://github.com/laubeing-droid/PRC-US-Legal-Semantic-Alignment-Framework) | 中美法律语义对齐框架 |

## 许可证

MIT
