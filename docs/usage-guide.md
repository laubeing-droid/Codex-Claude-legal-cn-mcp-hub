# 使用指南

本仓库为 Codex Desktop / Claude Code / Claude Desktop 配置中国法律检索 MCP 连接器。

---

## 一、安装

### 前置条件

- **Git**（克隆仓库）
- **Node.js >= 18**（仅 chineselaw 需要，北大法宝不需要）

### 安装

```powershell
git clone https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub.git
cd Codex-Claude-legal-cn-mcp-hub
.\install.ps1
```

macOS/Linux：
```bash
git clone https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub.git
cd Codex-Claude-legal-cn-mcp-hub
chmod +x install.sh && ./install.sh
```

安装过程：
1. **环境检测**：自动发现本机已安装的 MCP 客户端
2. **前置检查**：检测 Node.js 版本
3. **chineselaw API Key**：可选输入，留空则写入占位符
4. **北大法宝 Access Token**：可选输入，留空则写入占位符
5. **服务选择**：选择要安装的北大法宝服务（`a` 全选，`1,3,5` 多选，留空跳过）
6. **写入配置**：遍历所有检测到的客户端，自动适配 TOML/JSON 格式

> 配置段详情见 [connectors.md](connectors.md)。

---

## 二、验证

```powershell
.\verify.ps1
```

输出示例：
```
=== 中国法律 MCP 连接器 验证 ===

[OK] Codex Desktop    → ~/.codex/config.toml
[OK] Claude Code      → ~/.claude/settings.json

>>> Codex Desktop
  [OK] chineselaw (已启用)
  [OK] pkulaw-law-search (已启用)
  [!]  Token 仍为占位符

npm 包版本:
  [OK] chineselaw-mcp v1.0.0
  [!]  @pkulaw/mcp-cli (未安装)
```

---

## 三、更新与诊断

```powershell
.\update.ps1
```

脚本自动完成：
1. git pull 拉取本仓库最新版本
2. 检查 chineselaw-mcp / @pkulaw/mcp-cli 是否有新版
3. 检查所有 MCP 客户端配置状态
4. 检测 Token / API Key 是否仍为占位符
5. 如安装了 `@pkulaw/mcp-cli`，自动验证 Token 有效性

建议定期运行，保持配置和凭证最新。

---

## 四、卸载

```powershell
.\uninstall.ps1
```

从所有 MCP 客户端配置文件中移除中国法律连接器段。如需重新安装，重新运行 `install.ps1` 即可。

---

## 五、与上游仓库配合

本仓库可独立使用，也可与 [Claude-for-Legal-CN-to-Codex](https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex) 配合：

```powershell
# 上游仓库安装时会自动克隆本仓库并调用 install.ps1
git clone https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex.git
cd Claude-for-Legal-CN-to-Codex
.\install.ps1
```

上游的 `update.ps1` 会自动委托本仓库的 `verify.ps1` 和 `update.ps1`。

---

## 六、调试

```bash
# 安装北大法宝 CLI 工具
npm install -g @pkulaw/mcp-cli

# 初始化 Token
pkulaw-mcp init --authorization "Bearer YOUR_ACCESS_TOKEN"

# 验证凭证 + 拉取工具列表
pkulaw-mcp update

# 查看可用工具
pkulaw-mcp tools

# 诊断配置
pkulaw-mcp doctor
```

编辑配置文件：

```powershell
# Codex Desktop
notepad "$env:USERPROFILE\.codex\config.toml"

# Claude Code
notepad "$env:USERPROFILE\.claude\settings.json"
```
