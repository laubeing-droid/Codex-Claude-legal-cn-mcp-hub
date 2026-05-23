# 架构说明

## 仓库定位

`codex-legal-mcp-connectors` 是一个**独立的 MCP 连接器配置仓库**，
不涉及 skills/ 或法律工作流内容，只负责一件事：

> **向 MCP 客户端的配置文件写入中国法律检索连接器的配置**

## 架构图

```
用户运行 install.ps1 / install.sh
         │
         ▼
检测本机 MCP 客户端环境（detect.ps1 / detect.sh）
         │
         ├── Codex Desktop     →  ~/.codex/config.toml          (TOML)
         ├── Claude Code       →  ~/.claude/settings.json       (JSON)
         └── Claude Desktop    →  %APPDATA%/Claude/...          (JSON)
         │
         ▼
交互式选择连接器 + 输入凭证
         │
         ├── chineselaw（stdio）→ command/args/env
         └── 北大法宝（HTTP）   → url/headers
         │
         ▼
自动适配格式写入所有检测到的客户端
         │
         ▼
验证（verify.ps1） / 更新诊断（update.ps1）
```

## 数据流

```
install.ps1
  1. Node.js 检测（chineselaw 前置依赖）
  2. 交互式输入 API Key / Access Token（可留空）
  3. 选择北大法宝服务（多选）
  4. 写入所有检测到的 MCP 客户端配置
  5. 提示后续步骤

verify.ps1
  1. 检测所有 MCP 客户端环境
  2. 解析每个环境配置文件的 MCP 连接器段
  3. 检查 enabled 状态和占位符
  4. 检查 npm 包版本
  5. 输出验证结果

update.ps1
  1. git pull 自更新
  2. npm 包版本检查（chineselaw-mcp / @pkulaw/mcp-cli）
  3. 全环境 MCP 配置检查
  4. 凭证过期检测（占位符 + pkulaw-mcp-cli 验证）
  5. 汇总
```

## 依赖关系

```
本仓库（配置层）
  ├── 不依赖 codex-legal-cn-skills（可独立使用）
  └── 被 codex-legal-cn-skills 的 install.ps1 和 update.ps1 委托调用

外部依赖：
  ├── chineselaw-mcp（npm）     ← 元典智库 API 的 MCP 封装（MIT）
  ├── @pkulaw/mcp-cli（npm）    ← 北大法宝 MCP 命令行工具（MIT）
  └── Node.js >= 18             ← chineselaw 运行时
```
