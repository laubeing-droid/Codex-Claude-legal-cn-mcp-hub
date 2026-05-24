# 快速入门

60 秒完成中国法律 MCP 连接器安装。

## 安装

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

按提示操作：
- **chineselaw**：输入 API Key（[注册获取](https://open.chineselaw.com)）
- **北大法宝**：输入 Access Token（[注册获取](https://mcp.pkulaw.com)）
- **服务选择**：输入 `1,3,5` 多选，或 `a` 全选，留空跳过

## 验证

```powershell
.\verify.ps1
```

## 更新

```powershell
.\update.ps1
```

## 卸载

```powershell
.\uninstall.ps1
```

## 遇到问题？

- 重启 Codex Desktop / Claude Code / Claude Desktop
- 运行 `.\update.ps1` 查看诊断
- 查阅 `docs/troubleshooting.md`
