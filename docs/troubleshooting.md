# 常见问题排查

## 安装问题

### 安装后连接器不生效
1. **重启客户端**：Codex Desktop / Claude Code / Claude Desktop 需要重启才能加载新配置
2. **运行验证**：`.\verify.ps1` 查看配置状态
3. **检查 enabled 状态**：TOML 格式需 `enabled = true`，JSON 格式需配置结构完整

### chineselaw 添加失败
1. 运行 `node --version`，确认 >= 18
2. 如 Node.js 已安装但仍被跳过，检查 PATH 或重新打开终端
3. 安装脚本的步骤 2 会显示 Node.js 检测结果，[!!] 表示未找到

### 北大法宝服务未全部安装
1. 安装时输入 `a` 可选择全部服务
2. 已存在的配置段不会被覆盖（脚本采用追加策略）
3. 重新运行 `.\install.ps1` 选择需要的服务

### PowerShell 执行策略限制
```powershell
Set-ExecutionPolicy -Scope CurrentUser -RemoteSigned -Force
```

---

## 配置问题

### Token / API Key 仍为占位符

运行 `.\update.ps1` 检测到后，按以下步骤替换：

**chineselaw**：
1. 打开 https://open.chineselaw.com → 注册 → API 管理 → 创建 API Key
2. 编辑配置文件，替换 `CHINESELAW_API_KEY = "YOUR_API_KEY"`

**北大法宝**：
1. 打开 https://mcp.pkulaw.com → 注册 → 开发者控制台 → 获取 Access Token
2. 编辑配置文件，替换所有 `Bearer YOUR_ACCESS_TOKEN`

### Token 过期
北大法宝 Access Token 有有效期。检测方法：
1. 安装 `@pkulaw/mcp-cli`：`npm install -g @pkulaw/mcp-cli`
2. 初始化：`pkulaw-mcp init --authorization "Bearer YOUR_TOKEN"`
3. 验证：`pkulaw-mcp update`
4. 运行 `.\update.ps1` 可自动检测

### 配置文件损坏
重新运行 `.\install.ps1` — 脚本只追加不覆盖，不会丢失已有配置。

---

## 多环境问题

### 同时使用 Codex + Claude Code + Claude Desktop
安装脚本自动处理。运行一次 `install.ps1`，所有已检测到的客户端都会配置好。
`update.ps1` 和 `verify.ps1` 同样支持全环境。

### Claude Code 配置格式错误
如果手动编辑 `~/.claude/settings.json` 后格式错误：
```powershell
.\verify.ps1          # 检查格式
python -c "import json; json.load(open(r'~/.claude/settings.json'))"
```

---

## 网络问题

### git clone 失败
```powershell
# 使用代理
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
```

### npm registry 连接失败
```powershell
# 国内用户配置镜像
npm config set registry https://registry.npmmirror.com
```

---

## 更新问题

### git pull 冲突
```powershell
git stash && git pull && git stash pop
```
或重新克隆：`git clone https://github.com/laubeing-droid/Codex-Claude-legal-cn-mcp-hub.git`

---

## 卸载
```powershell
.\uninstall.ps1        # Windows
./uninstall.sh         # macOS/Linux
```
从所有 MCP 客户端配置文件中移除连接器段。
