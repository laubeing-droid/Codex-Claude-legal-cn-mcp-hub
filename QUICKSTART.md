# 快速入门

60 秒完成安装。

## 安装

```powershell
git clone https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git
cd Codex-Claude-legal-CN-mcp-connectors
.\install.ps1
```

macOS/Linux：
```bash
git clone https://github.com/laubeing-droid/Codex-Claude-legal-CN-mcp-connectors.git
cd Codex-Claude-legal-CN-mcp-connectors
chmod +x install.sh && ./install.sh
```

安装时按提示操作：
- **chineselaw**：推荐，输入 API Key（https://open.chineselaw.com 注册获取）
- **北大法宝**：可选，输入 Access Token（https://mcp.pkulaw.com 注册获取）
- **服务选择**：如选择北大法宝，可用 `1,3,5` 格式多选

## 验证

```powershell
.\verify.ps1
```

## 更新

```powershell
.\update.ps1
```

## 遇到的问题？

- 重启 Codex Desktop / Claude Code
- 运行 `.\update.ps1` 查看诊断
- 查看 `docs/troubleshooting.md`


