# 使用指南

本仓库为 Codex Desktop / Claude Code / Claude Desktop 配置中国法律检索 MCP 连接器。

---

## 一、安装

### 前置条件

- **Git**（用于克隆仓库）
- **Node.js >= 18**（仅 chineselaw 需要，北大法宝不需要）

### 安装步骤

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

### 安装过程

脚本会引导你完成以下选择：

1. **chineselaw（推荐）**：基于 npx 的 33 个 MCP 工具。需要 API Key
2. **北大法宝 MCP 协议**：10 个 HTTP MCP 服务。需要 Access Token
3. **服务选择**：北大法宝的服务可以选择部分安装

所有选择都可以跳过（之后手动配置），安装脚本会使用占位符。

---

## 二、验证

安装后验证配置是否正确：

```powershell
.\verify.ps1
```

输出示例：
```
=== 中国法律 MCP 连接器 验证 ===

[OK] Codex Desktop
[OK] Claude Code

>>> Codex Desktop
  [OK] chineselaw (已启用)
  [OK] pkulaw-law-search (已启用)
         [!] Token 仍为占位符

npm 包版本:
  [OK] chineselaw-mcp v1.0.0 (已最新)
  [!]  @pkulaw/mcp-cli latest=0.2.1 (未安装)
```

---

## 三、配置凭证

### chineselaw（元典智库）

1. 打开 https://open.chineselaw.com → 注册
2. 个人中心 → API 管理 → 创建 API Key
3. 编辑配置文件，替换 `CHINESELAW_API_KEY`：

**Codex Desktop**：编辑 `~/.codex/config.toml`
**Claude Code**：编辑 `~/.claude/settings.json`

### 北大法宝

1. 打开 https://mcp.pkulaw.com → 注册/登录
2. 开发者控制台 → 我的应用 → 创建应用 → 获取 Access Token
3. 编辑配置文件，替换所有 `Bearer YOUR_ACCESS_TOKEN`

---

## 四、更新与诊断

定期运行 `update.ps1` 保持配置最新：

```powershell
.\update.ps1
```

脚本会：
- 从 GitHub 拉取本仓库最新版本
- 检查 npm 包是否有新版本
- 检查所有 MCP 客户端配置状态
- 检测凭证是否仍为占位符或已过期
- 如安装了 `@pkulaw/mcp-cli`，自动验证 Token 有效性

---

## 五、连接器详解

### chineselaw（33 个工具）

| 类别 | 工具数 | 说明 |
|------|--------|------|
| 法律法规 | 5 | search_regulations, search_legal_articles, get_article_detail, get_regulation_detail, semantic_search_law |
| 案例文书 | 4 | search_cases, search_authoritative_cases, get_case_detail, semantic_search_cases |
| 企业信息 | 24 | 企业检索、工商信息、商标专利、涉诉信息、失信被执行人、行政处罚等 |

### 北大法宝（10 个服务）

| # | 中文名 | 用途 |
|---|--------|------|
| 1 | 检索法律法规-语义 | 基于语义理解的法律法规检索 |
| 2 | 检索法律法规-关键词 | 法规标题或正文关键词精确匹配 |
| 3 | 检索司法案例-语义 | 用自然语言描述查找相关判例 |
| 4 | 检索司法案例-关键词 | 案例标题或正文关键词检索 |
| 5 | 精准查找法条-关键词 | 通过法规名称与条号精确查询法条 |
| 6 | 法条识别与溯源 | 从文本中识别法规名称与条款 |
| 7 | 案号识别与溯源 | 识别案号、标准化验证及溯源 |
| 8 | 修正生成幻觉-法条 | 分析引用并返回权威条文 |
| 9 | 法宝超链 | 为文本智能添加法规超链接 |
| 10 | 法宝语义检索（NL-SQL） | 自然语言多库语义检索（需额外购买） |

---

## 六、与 codex-legal-cn-skills 配合使用

本仓库可独立使用（仅配置 MCP 连接器），也可与主技能仓库配合：

```powershell
# 主仓库安装时会自动克隆本仓库并调用 install.ps1
git clone https://github.com/laubeing-droid/codex-legal-cn-skills.git
cd codex-legal-cn-skills
.\install.ps1
```

主仓库的 `update.ps1` 也会自动委托本仓库的 `verify.ps1` 和 `update.ps1`。

---

## 七、调试

### 使用 pkulaw-mcp-cli

```bash
npm install -g @pkulaw/mcp-cli
pkulaw-mcp init --authorization "Bearer YOUR_ACCESS_TOKEN"
pkulaw-mcp update     # 验证 Token + 拉取工具列表
pkulaw-mcp tools      # 查看可用工具
pkulaw-mcp doctor     # 诊断配置
```

### 检查配置文件

```powershell
# Codex Desktop
notepad "$env:USERPROFILE\.codex\config.toml"

# Claude Code
notepad "$env:USERPROFILE\.claude\settings.json"
```


