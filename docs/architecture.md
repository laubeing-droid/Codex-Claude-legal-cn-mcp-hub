<!--
version: 3.0.2
module: docs
status: active
-->

# 架构说明

## 定位

本仓库是**中国法律 MCP 连接器中心**。核心职责：

> 管理 MCP 连接器配置 + 托管自建 MCP Server。

## 数据流

```
用户运行 install.ps1
         │
         ▼
  detect.ps1 —— 检测本机 MCP 客户端
         │
         ├── Codex Desktop   → ~/.codex/config.toml
         ├── Claude Code     → ~/.claude/settings.json
         └── Claude Desktop  → %APPDATA%/Claude/... 或 ~/Library/...
         │
         ▼
  交互式选择连接器 + 输入凭证
         │
         ├── 元典  → HTTP MCP（Bearer Token）
         ├── 北大法宝 → HTTP MCP（Access Token）
         └── 飞书  → npm stdio（App ID + Secret）
         │
         ▼
  写入所有检测到的客户端（TOML / JSON 自动适配）
         │
         ▼
  verify.ps1 / update.ps1 / uninstall.ps1
```

## 脚本分层

| 层 | 脚本 | 职责 |
|----|------|------|
| 入口 | `install.ps1/sh` | 检测→输入→选择→写入 |
| 检测 | `detect.ps1/sh` | 返回客户端列表及路径 |
| 验证 | `verify.ps1/sh` | 检查配置状态 |
| 诊断 | `update.ps1/sh` | git pull + 版本检查 + 配置巡检 |
| 卸载 | `uninstall.ps1/sh` | 移除配置段 |

## 自建 MCP Server

两个 Server 均为基于公开 API 文档的干净室实现，单文件全功能：

```
servers/
├── flk-npc/              # 国家法规库（干净室实现）
│   └── scripts/server.py  # 含 client / models / formatters
│
└── rmfyalk/              # 案例库（干净室实现）
    └── scripts/server.py  # 含 client / models / formatters
```

## 依赖

| 连接器 | 依赖 | 版本要求 |
|--------|------|---------|
| 元典 HTTP | 无 | — |
| 北大法宝 | 无 | — |
| 飞书 | Node.js | >= 18 |
| flk-npc | Python + mcp/httpx/pydantic | >= 3.8 |
| rmfyalk | Python + mcp/httpx/pydantic | >= 3.8 |