<!--
version: 3.0.1
module: docs
status: active
-->

# 故障排除

## 连接器不工作
1. 重启 MCP 客户端（必须）
2. 运行 `.\verify.ps1`
3. 检查配置文件：

```powershell
notepad "$env:USERPROFILE\.codex\config.toml"
notepad "$env:USERPROFILE\.claude\settings.json"
```

## 凭证问题
**元典**：https://open.chineselaw.com → API 管理 → 创建 API Key
**北大法宝**：https://mcp.pkulaw.com → 控制台 → 获取 Token

Token 过期运行 `update.ps1` 检测，或用 `@pkulaw/mcp-cli` 验证。

## 网络问题
```powershell
git config --global http.proxy http://127.0.0.1:7890
npm config set registry https://registry.npmmirror.com
```

## 自建 Server
**端口冲突**：修改 server.py 中的端口号
**依赖**：`pip install -r requirements.txt`
**案例库 Token**：浏览器登录 rmfyalk.court.gov.cn → F12 → 复制 Cookie