# MCP 连接器配置参考

本仓库提供中国法律 MCP 连接器的完整安装和配置支持。

## 连接器总览

| 连接器 | 接入方式 | 工具数 | 凭证 | 推荐 |
|--------|---------|--------|------|------|
| **元典智库** | HTTP MCP（官方） | 35+ | API Key（Bearer） | ⭐ 首选 |
| **元典智库** | npm stdio（社区） | 33 | API Key（环境变量） | 备选 |
| **元典智库** | REST API（直调） | 36 | API Key（X-API-Key） | 灵活集成 |
| **飞书** | npm stdio（官方） | 文档/消息/日历 | App ID + Secret | 推荐 |
| **北大法宝** | HTTP MCP（官方） | 10 | Access Token | 推荐 |
| **北大法宝** | npm CLI（官方） | 调试工具 | Access Token | 诊断/验证 |

---

## 一、元典智库（chineselaw / yuandian）

| 项目 | 内容 |
|------|------|
| 官网 | https://open.chineselaw.com |
| 注册 | https://open.chineselaw.com → API 管理 → 创建 API Key |
| 完整文档 | https://open.chineselaw.com/llms-full.txt（Markdown，给 AI 读的） |
| API 目录 | https://apiplatform.legalmind.cn/api/apis?pageNum=1&pageSize=200 |
| 接口广场 | https://open.chineselaw.com/api-square |

### 方式 A：Streamable HTTP MCP（官方推荐）

元典官方提供 **3 个分类 MCP Server** + 1 个兼容入口：

| Server | 分类 | HTTP 端点 | 工具数 |
|--------|------|----------|--------|
| `yuandian-law` | 法律法规 | `https://open.chineselaw.com/mcp/law/stream` | 5 |
| `yuandian-case` | 案例文书 | `https://open.chineselaw.com/mcp/case/stream` | 4 |
| `yuandian-company` | 企业信息 | `https://open.chineselaw.com/mcp/company/stream` | 26 |
| `yuandian-open-platform` | 全能力兼容 | `https://open.chineselaw.com/mcp` | 全部 |

**特点：**
- Streamable HTTP 传输，无需本地安装 npm 包
- 按分类隔离，降低单 Server 复杂度
- 请求头使用 `Authorization: Bearer YOUR_API_KEY`
- 需设置 Accept 头: `application/json, text/event-stream`

#### 配置示例

**Codex Desktop（TOML）：**
```toml
[mcp_servers.yuandian-law]
type = "http"
url = "https://open.chineselaw.com/mcp/law/stream"
http_headers = { Authorization = "Bearer YOUR_API_KEY", Accept = "application/json, text/event-stream" }
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true

[mcp_servers.yuandian-case]
type = "http"
url = "https://open.chineselaw.com/mcp/case/stream"
http_headers = { Authorization = "Bearer YOUR_API_KEY", Accept = "application/json, text/event-stream" }
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true

[mcp_servers.yuandian-company]
type = "http"
url = "https://open.chineselaw.com/mcp/company/stream"
http_headers = { Authorization = "Bearer YOUR_API_KEY", Accept = "application/json, text/event-stream" }
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true
```

**Claude Code / Claude Desktop（JSON）：**
```json
{
  "mcpServers": {
    "yuandian-law": {
      "url": "https://open.chineselaw.com/mcp/law/stream",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY",
        "Accept": "application/json, text/event-stream"
      }
    },
    "yuandian-case": {
      "url": "https://open.chineselaw.com/mcp/case/stream",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY",
        "Accept": "application/json, text/event-stream"
      }
    },
    "yuandian-company": {
      "url": "https://open.chineselaw.com/mcp/company/stream",
      "headers": {
        "Authorization": "Bearer YOUR_API_KEY",
        "Accept": "application/json, text/event-stream"
      }
    }
  }
}
```

### 方式 B：npm stdio（社区包装，备选）

| 项目 | 内容 |
|------|------|
| npm 包 | [chineselaw-mcp](https://www.npmjs.com/package/chineselaw-mcp)（作者 zooges，MIT） |
| 启动方式 | `npx -y chineselaw-mcp` |
| 前置依赖 | Node.js >= 18 |

**特点：**
- 单一 Server 暴露全部工具
- stdio 传输，与所有 MCP 客户端兼容
- 环境变量传 Key：`CHINESELAW_API_KEY`

#### 配置示例

**Codex Desktop（TOML）：**
```toml
[mcp_servers.chineselaw]
command = "npx"
args = ["-y", "chineselaw-mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true

[mcp_servers.chineselaw.env]
CHINESELAW_API_KEY = "YOUR_API_KEY"
```

**Claude Code / Claude Desktop（JSON）：**
```json
{
  "mcpServers": {
    "chineselaw": {
      "command": "npx",
      "args": ["-y", "chineselaw-mcp"],
      "env": { "CHINESELAW_API_KEY": "YOUR_API_KEY" }
    }
  }
}
```

### 方式 C：REST API 直调（灵活集成）

无需 MCP 客户端，直接 HTTP 调用：

| 项目 | 内容 |
|------|------|
| Base URL | `https://open.chineselaw.com/open/{routeKey}` |
| 鉴权 | `X-API-Key: YOUR_API_KEY` |
| 格式 | JSON |

#### API 分类清单（36 个）

**法律法规（5）：**
| routeKey | 方法 | 功能 |
|----------|------|------|
| rh_fg_search | POST | 法规关键词检索 |
| rh_fg_detail | POST | 法规详情 |
| rh_ft_search | POST | 法条关键词检索 |
| rh_ft_detail | POST | 法条详情 |
| rh_semantic_search | POST | 法规语义检索 |

**案例文书（4）：**
| routeKey | 方法 | 功能 |
|----------|------|------|
| rh_ptal_search | POST | 普通案例关键词检索 |
| rh_qwal_search | POST | 权威案例关键词检索 |
| rh_case_details | GET | 案例详情 |
| case_vector_search | POST | 案例语义检索 |

**企业信息（26）：**
| routeKey | 方法 | 功能 |
|----------|------|------|
| rh_enterpriseSearch | GET | 企业检索（名称关键词） |
| rh_enterpriseBaseInfo | GET | 企业基本信息 |
| rh_company_info | GET | 按名称/股票简称查企业 |
| rh_company_detail | GET | 按 ID/信用代码查企业详情 |
| rh_enterpriseAggregationSummary | GET | 企业聚合总览 |
| rh_enterpriseAnnualReport | POST | 企业年报详情 |
| rh_enterpriseChangeRecord | GET | 企业变更记录 |
| rh_enterpriseBranch | GET | 企业分支机构列表 |
| rh_enterpriseMainMember | GET | 企业主要人员 |
| rh_enterpriseInvest | GET | 企业股东信息 |
| rh_enterpriseOutInvest | GET | 企业对外投资列表 |
| rh_enterpriseTrademark | GET | 企业商标列表 |
| rh_enterprisePatent | GET | 企业专利列表 |
| rh_enterpriseCopyright | GET | 企业著作权列表 |
| rh_enterpriseWritList | GET | 企业涉诉文书列表 |
| rh_enterpriseCourtSessionNotice | GET | 企业开庭公告列表 |
| rh_enterpriseCourtNotice | GET | 企业法院公告列表 |
| rh_enterpriseLitigationStats | GET | 企业涉诉统计 |
| rh_enterpriseExecutions | GET | 企业失信被执行人列表 |
| rh_enterpriseExecutedPerson | GET | 企业被执行人列表 |
| rh_enterpriseFrozenEquity | GET | 企业股权冻结列表 |
| rh_enterprisePunishment | GET | 企业行政处罚列表 |
| rh_enterprisePledge | GET | 企业股权出质列表 |
| rh_enterpriseGuaranty | GET | 企业对外担保列表 |
| rh_enterpriseAbnormalOperation | GET | 企业经营异常列表 |
| rh_enterpriseCorporateTax | GET | 企业欠税公告列表 |

**幻觉检测（1）：**
| routeKey | 方法 | 功能 |
|----------|------|------|
| hall_detect | POST | 法律幻觉校验 |

---

## 二、飞书（LarkSuite MCP）

| 项目 | 内容 |
|------|------|
| npm 包 | [@larksuiteoapi/lark-mcp](https://www.npmjs.com/package/@larksuiteoapi/lark-mcp)（飞书官方） |
| 最新版本 | 0.5.1 |
| 前提 | 在 https://open.feishu.cn/app 创建企业自建应用 |
| 权限 | 需开通文档、消息、日历、通讯录等对应 API 权限 |
| 启动方式 | `npx -y @larksuiteoapi/lark-mcp` |

**特点：**
- 飞书官方 MCP Server
- 支持飞书文档、消息、日历、通讯录等
- 需创建企业自建应用获取 App ID / Secret

### 配置示例

**Codex Desktop（TOML）：**
```toml
[mcp_servers.feishu]
command = "npx"
args = ["-y", "@larksuiteoapi/lark-mcp"]
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true

[mcp_servers.feishu.env]
LARK_APP_ID = "YOUR_APP_ID"
LARK_APP_SECRET = "YOUR_APP_SECRET"
```

**Claude Code / Claude Desktop（JSON）：**
```json
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": ["-y", "@larksuiteoapi/lark-mcp"],
      "env": {
        "LARK_APP_ID": "YOUR_APP_ID",
        "LARK_APP_SECRET": "YOUR_APP_SECRET"
      }
    }
  }
}
```

---

## 三、北大法宝（pkulaw）

| 项目 | 内容 |
|------|------|
| MCP 平台 | https://mcp.pkulaw.com |
| 注册 | https://mcp.pkulaw.com → 开发者控制台 → 创建应用 → 获取 Access Token |
| 类型 | HTTP 服务，无前置依赖 |
| 网关基地址 | `https://apim-gateway.pkulaw.com` |
| CLI 工具 | `@pkulaw/mcp-cli`（北大法宝官方 CLI，MIT） |

### HTTP MCP 服务（10 个）

| # | 服务 ID (官方) | 官方中文名 | MCP 端点路径 | 用途 |
|---|--------------|-----------|-------------|------|
| 1 | law-semantic | 检索法律法规-语义 | /mcp-law-search-service/mcp | 语义理解的法规检索 |
| 2 | law-keyword | 检索法律法规-关键词 | /mcp-law/mcp | 标题/正文关键词检索 |
| 3 | case-semantic | 检索司法案例-语义 | /mcp-case-search-service/mcp | 自然语言查找判例 |
| 4 | case-keyword | 检索司法案例-关键词 | /mcp-case/mcp | 案例标题/正文关键词检索 |
| 5 | fatiao | 精准查找法条-关键词 | /mcp-fatiao/mcp | 法规名称+条号精确查询 |
| 6 | law-recognition | 法条识别与溯源 | /law_recognition/mcp | 文本中识别法规名称与条款 |
| 7 | case-number | 案号识别与溯源 | /case_number_recognition/mcp | 识别案号并溯源 |
| 8 | citation-validator | 修正生成幻觉-法条 | /pku_citation_validator/mcp | 分析引用并返回权威条文 |
| 9 | doc-link | 法宝超链 | /add-doc-link/mcp | 文本智能添加法规超链接 |
| 10 | semantic-nlsql | 法宝语义检索（NL-SQL） | /assistant/mcp-pkulaw-search/mcp | 自然语言多库语义检索（需额外购买配置） |

### CLI 调试工具（@pkulaw/mcp-cli）

| 项目 | 内容 |
|------|------|
| npm 包 | [@pkulaw/mcp-cli](https://www.npmjs.com/package/@pkulaw/mcp-cli)（北大法宝官方，MIT） |
| 最新版本 | 0.2.1 |
| 源码 | Gitee: pkulaw/pkulaw-mcp-cli |
| 命令 | `pkulaw-mcp` |
| 功能 | 终端直连网关，调用 MCP 工具（tools/list + tools/call），不经 LLM，宜脚本与 CI 编排 |

#### 安装与配置

```bash
npm install -g @pkulaw/mcp-cli
pkulaw-mcp init --authorization "Bearer YOUR_ACCESS_TOKEN"
pkulaw-mcp update    # 同步工具清单到本地缓存
pkulaw-mcp tools     # 查看所有可用工具及参数
pkulaw-mcp doctor    # 诊断连接状态
```

#### 命令速查

| 命令 | 别名 | 功能 |
|------|------|------|
| `init` | — | 初始化配置（写入 ~/.pkulaw/mcp/config.json） |
| `update` | `refresh` | 刷新工具列表缓存（TTL 8 小时） |
| `tools` | `list-tools`, `ls` | 列出所有工具 |
| `call` | — | 调用工具（后面跟工具名和参数） |
| `check` | `doctor` | 诊断配置和连接 |
| `config` | — | 查看/修改配置 |
| `docs` | — | 查看服务文档链接 |

#### 环境变量

- `PKULAW_MCP_AUTHORIZATION` — 完整 Authorization 头，优先于 config.json
- `PKULAW_MCP_DEBUG=1` — 打印调试信息到 stderr
- `PKULAW_MCP_GATEWAY_BASE_URL` — 自定义网关地址

#### 调用示例

```bash
# 语义检索法律法规
pkulaw-mcp call law-search --query "劳动合同解除 经济补偿"

# 精确查找法条
pkulaw-mcp call law-item-keyword --title "中华人民共和国民法典" --article-number "第五百七十七条"

# 幻觉检测：校验法条引用
pkulaw-mcp call citation-validator --param @citation-validator-adjust-provisions.param.json

# 输出 Markdown 格式
pkulaw-mcp call law-keyword --keyword "数据安全法" --markdown
```

> **注意**：CLI 的 MCP 端点路径与 HTTP MCP 配置一致（均使用 `/mcp` 后缀路径）。
> HTTP MCP 客户端配置时，每个服务对应一个独立的 `mcpServers` 条目。

---

## 四、自建 Python MCP 服务器

本仓库包含两个自建 Python MCP 服务器，作为公共 MCP 服务的免费备选。

### 4.1 国家法律法规数据库 MCP

| 项目 | 内容 |
|------|------|
| 数据源 | https://flk.npc.gov.cn（全国人大常委会办公厅官方平台） |
| 端口 | localhost:18062 |
| 协议 | Streamable HTTP（FastMCP） |
| 认证 | **无需认证**，完全免费 |
| 技术栈 | Python 3.x, FastMCP, httpx, Pydantic |

#### 工具清单（11 个）

| 工具 | 功能 |
|------|------|
| flk_search | 搜索法律法规（标题/全文，支持分类、状态、年份过滤） |
| flk_get_detail | 获取法规详情（元数据 + 目录树 + 历史版本） |
| flk_hit_display | 命中法条展示（关键词高亮的法条片段） |
| flk_get_enum | 分类枚举（法律分类 / 制定机关） |
| flk_search_suggest | 搜索建议（自动补全） |
| flk_get_related | 相关法规推荐 |
| flk_download | 获取下载链接（docx/pdf） |
| flk_export_law | 导出法规到本地 |
| flk_high_search | 高级检索（多条件组合，AND/OR/NOT） |
| flk_high_hit_display | 高级检索命中展示 |
| flk_high_xgzl | 高级检索相关资料 |

#### 安装

`ash
pip install -r servers/flk-npc/requirements.txt
`

#### 启动

`ash
python servers/flk-npc/scripts/server.py
`

#### MCP 客户端配置

**Codex Desktop（TOML）：**
`	oml
[mcp_servers.flk-npc]
command = "python"
args = ["path/to/servers/flk-npc/scripts/server.py"]
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true
`

---

### 4.2 人民法院案例库 MCP

| 项目 | 内容 |
|------|------|
| 数据源 | https://rmfyalk.court.gov.cn（最高人民法院官方平台） |
| 端口 | localhost:18061 |
| 协议 | Streamable HTTP（FastMCP） |
| 认证 | 需要 Cookie Token（faxin-cpws-al-token），约 4 小时过期 |
| 技术栈 | Python 3.x, FastMCP, httpx, Pydantic |

#### 工具清单（7 个）

| 工具 | 功能 | 必填参数 |
|------|------|---------|
| rmfyalk_search | 搜索案例 | keyword 或任意高级检索字段 |
| rmfyalk_get_case | 获取案例详情 | case_id |
| rmfyalk_get_statistics | 聚类统计 | 无 |
| rmfyalk_get_enum | 分类枚举代码 | field |
| rmfyalk_export_case | 导出案例到本地 | case_id 或 keyword/sort_id |
| rmfyalk_set_token | 设置认证 Token | token |
| rmfyalk_check_token | 检查 Token 有效性 | 无 |

#### Token 获取

1. 访问 https://rmfyalk.court.gov.cn 并登录
2. F12 → Application → Cookies
3. 找到 faxin-cpws-al-token，复制其值（约 4 小时过期）

#### 安装

`ash
pip install -r servers/rmfyalk/requirements.txt
`

#### 启动

`ash
python servers/rmfyalk/scripts/server.py
`

#### MCP 客户端配置

**Codex Desktop（TOML）：**
`	oml
[mcp_servers.rmfyalk]
command = "python"
args = ["path/to/servers/rmfyalk/scripts/server.py"]
startup_timeout_sec = 30
tool_timeout_sec = 600
enabled = true

[mcp_servers.rmfyalk.env]
RMFYALK_TOKEN = "YOUR_TOKEN_HERE"
`

---

### 使用建议

| 场景 | 推荐数据源 |
|------|-----------|
| 免费法规检索 | 国家法律法规数据库 MCP（无需认证） |
| 权威案例检索 | 人民法院案例库 MCP（需 Token） |
| 全面检索 | 元典 MCP（推荐）+ 以上两个作为补充 |
| 学术研究 | 国家法律法规数据库 + 北大法宝 |

## 四、凭证速查

| 服务 | 注册地址 | 配置项 | 鉴权位置 |
|------|---------|--------|---------|
| 元典 HTTP MCP | https://open.chineselaw.com | API Key | Bearer Token（Authorization 头） |
| 元典 REST API | https://open.chineselaw.com | API Key | X-API-Key 头 |
| 元典 npm stdio | https://open.chineselaw.com | API Key | CHINESELAW_API_KEY 环境变量 |
| 飞书 MCP | https://open.feishu.cn/app | App ID + Secret | LARK_APP_ID / LARK_APP_SECRET |
| 北大法宝 | https://mcp.pkulaw.com | Access Token | Bearer Token（Authorization 头） |

---

## 五、推荐组合

| 场景 | 推荐配置 |
|------|---------|
| 法律检索（入门） | 元典 HTTP MCP（yuandian-law + yuandian-case） |
| 法律检索（全面） | 元典 HTTP MCP（全部 3 Server）+ 北大法宝 |
| 企业尽职调查 | 元典 HTTP MCP（yuandian-company） |
| 法律文书协作 | 元典 HTTP MCP + 飞书 MCP |
| 学术研究 | 元典 HTTP MCP（全部）+ 北大法宝（全部） |
| 最小化配置 | 元典 HTTP MCP（yuandian-law 一个就够了） |

---

## 六、配套文档

| 文档 | 内容 |
|------|------|
| [usage-guide.md](usage-guide.md) | 使用指南（安装/验证/更新） |
| [architecture.md](architecture.md) | 架构说明与数据流 |
| [troubleshooting.md](troubleshooting.md) | 常见问题排查 |
| [contributing.md](contributing.md) | 贡献指南 |



