# Codex & Claude 中国法律 MCP 连接器

Codex Desktop / Claude Code / Claude Desktop 三环境通用的中国法律检索 MCP 连接器配置工具。自动检测本机客户端环境，写入对应格式配置（TOML / JSON），一次安装多环境生效。

| 连接器 | 方式 | 工具数 | 推荐 |
|--------|------|--------|------|
| **chineselaw（元典智库）** | stdio（npx） | 33 | ⭐ 首选 |
| **北大法宝 MCP 协议** | HTTP（10 服务） | 10+ | 推荐 |
| **@pkulaw/mcp-cli** | CLI 调试工具 | — | 诊断/验证 |

可与 [Claude-for-Legal-CN-to-Codex](https://github.com/laubeing-droid/Claude-for-Legal-CN-to-Codex) 配合使用获得完整法律技能工作流，也可单独安装让任意 MCP 客户端具备中国法律检索能力。

---

## 快速安装

```powershell
git clone https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git
cd Codex-Claude-legal-CN-mcp-connectors
.\install.ps1
```

macOS / Linux：
```bash
git clone https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git
cd Codex-Claude-legal-CN-mcp-connectors
chmod +x install.sh && ./install.sh
```

安装脚本自动完成：
1. 检测本机 MCP 客户端（Codex Desktop / Claude Code / Claude Desktop）
2. 检测 Node.js（chineselaw 前置依赖）
3. 交互式输入 API Key / Access Token（可留空后续配置）
4. 选择北大法宝服务（支持多选，如 `1,3,5`）
5. 写入所有检测到的客户端配置（自动适配 TOML / JSON 格式）

重启 MCP 客户端，运行 `.\verify.ps1` 验证。

---

## 文件清单

| 文件 | 说明 | Windows | macOS/Linux |
|------|------|---------|-------------|
| `install.ps1` / `install.sh` | 安装 MCP 连接器（全环境写入） | ✅ | ✅ |
| `verify.ps1` / `verify.sh` | 验证所有环境的 MCP 配置 | ✅ | ✅ |
| `update.ps1` / `update.sh` | 自更新 + 版本检查 + Token 过期检测 | ✅ | ✅ |
| `uninstall.ps1` / `uninstall.sh` | 卸载 MCP 连接器配置 | ✅ | ✅ |
| `detect.ps1` / `detect.sh` | 环境检测模块（被以上脚本共用） | ✅ | ✅ |

| 文档 | 说明 |
|------|------|
| `QUICKSTART.md` | 60 秒快速入门 |
| `docs/connectors.md` | 连接器完整配置参考（含服务清单、配置段、凭证说明） |
| `docs/usage-guide.md` | 使用指南（安装、验证、更新、配合主仓库） |
| `docs/architecture.md` | 架构说明 + 数据流 |
| `docs/troubleshooting.md` | 常见问题排查 |
| `docs/contributing.md` | 贡献指南 + 编码规范 |

| 其他 | 说明 |
|------|------|
| `.github/workflows/npm-monitor.yml` | npm 包版本监控（每周一 08:00 UTC） |
| `CHANGELOG.md` | 版本历史 |
| `交接文档.md` | 维护者交接文档 |

---

## 支持的环境

| 客户端 | 配置路径 | 格式 |
|--------|---------|------|
| **Codex Desktop** | `~/.codex/config.toml` | TOML |
| **Claude Code**（终端） | `~/.claude/settings.json` | JSON |
| **Claude Desktop**（桌面） Win | `%LOCALAPPDATA%\Claude\claude_desktop_config.json` | JSON |
| **Claude Desktop**（桌面） Mac | `~/Library/Application Support/Claude/claude_desktop_config.json` | JSON |

---

## 已知问题

- **Token 占位符**：install 时如未输入凭证，写入 `YOUR_API_KEY` / `YOUR_ACCESS_TOKEN`，运行 `update.ps1` 可检测
- **Token 过期**：`update.ps1` 可借助 `@pkulaw/mcp-cli` 验证 Token 有效性
- **跨平台**：Windows PowerShell + macOS/Linux Bash 双版本同步
- **Node.js 依赖**：仅 chineselaw 需要，安装脚本自动检测

---

## 许可证

MIT。上游依赖：
- [chineselaw-mcp](https://www.npmjs.com/package/chineselaw-mcp)（MIT，作者 zooges）
- [@pkulaw/mcp-cli](https://www.npmjs.com/package/@pkulaw/mcp-cli)（MIT，北大法宝官方）

