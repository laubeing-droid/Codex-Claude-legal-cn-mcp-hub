# 常见问题排查

## 安装问题

### 安装后 MCP 连接器不生效

1. **重启客户端了吗？** Codex Desktop / Claude Code 需要重启才能加载新的 MCP 配置
2. **运行验证脚本**：`.\verify.ps1`（Windows）或 `./verify.sh`（macOS/Linux）
3. **检查 enabled 状态**：确保配置文件中 `enabled = true` 存在（TOML 格式）或配置结构完整（JSON 格式）

### chineselaw 没有添加成功

1. **Node.js 是否已安装？** 运行 `node --version`，确认版本 >= 18
2. **是否被检测到？** 安装脚本会在步骤 2 显示 Node.js 版本；如显示 [!!] 表示未检测到
3. **如果 Node.js 已安装**：可能是 PATH 问题，尝试重新打开终端

### 北大法宝服务没有全部安装

1. **服务选择**：安装时可以选择特定服务（输入 `1,3,5`），如需要所有服务请选择 `a`
2. **已有配置跳过**：如果 config.toml 中已存在某个服务配置，安装脚本会跳过（不覆盖）
3. **手动追加**：重新运行 `.\install.ps1`，选择需要的服务

## 配置问题

### Token / API Key 仍为占位符

运行 `.\update.ps1` 会检测并提示占位符，然后：

**chineselaw**：
1. 打开 https://open.chineselaw.com → 注册 → API 管理 → 创建 API Key
2. 编辑 `~/.codex/config.toml`（Codex）或 `~/.claude/settings.json`（Claude Code）
3. 将 `CHINESELAW_API_KEY = "YOUR_API_KEY"` 替换为真实 Key

**北大法宝**：
1. 打开 https://mcp.pkulaw.com → 注册 → 开发者控制台 → 获取 Access Token
2. 编辑对应配置文件，将所有 `Bearer YOUR_ACCESS_TOKEN` 替换为真实 Token

### Token 过期

北大法宝 Access Token 有有效期。检测方法：
1. 安装 `@pkulaw/mcp-cli`：`npm install -g @pkulaw/mcp-cli`
2. 初始化：`pkulaw-mcp init --authorization "Bearer YOUR_TOKEN"`
3. 验证：`pkulaw-mcp update`
4. 运行 `.\update.ps1` 会自动检测并提示

### config.toml 损坏

重新运行 `.\install.ps1` — 脚本只追加不覆盖，不会丢失已有配置。

## 多环境问题

### 同时使用 Codex Desktop 和 Claude Code

安装脚本自动处理。运行一次 `install.ps1`，两个客户端都会配置好。

### Claude Code 配置格式错误

Claude Code 使用 JSON 格式。如果手动编辑 `~/.claude/settings.json` 后格式错误：
1. 运行 `.\verify.ps1` 检查 JSON 格式
2. 或运行 `python -c "import json; json.load(open(r'~/.claude/settings.json'))"` 检查语法

## 网络问题

### git clone 失败

- 检查网络连接
- 尝试使用代理：`git config --global http.proxy http://proxy:port`
- 重新运行 install.ps1（脚本会自动重试 git pull）

### npm registry 连接失败

- 检查 npm registry 是否可以访问：`npm ping`
- 国内用户可配置镜像：`npm config set registry https://registry.npmmirror.com`

## npm 包更新

GitHub Actions 每周一自动检查 `chineselaw-mcp` 和 `@pkulaw/mcp-cli` 的版本更新。
运行 `.\update.ps1` 可手动检查版本。

## 卸载

运行本仓库的卸载脚本：
```powershell
.\uninstall.ps1        # Windows
./uninstall.sh         # macOS/Linux
```

这会从所有 MCP 客户端配置文件中移除连接器配置。
