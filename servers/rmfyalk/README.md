<!--
version: 3.0.2
module: mcp-hub
status: active
-->

# 案例库 MCP Server

基于人民法院案例库（rmfyalk.court.gov.cn）的 MCP 封装，干净室实现。

- 启动：`pip install -r requirements.txt && python scripts/server.py`
- 端口：localhost:18061
- 鉴权：Cookie Token（F12 → 网络请求 → 复制 Cookie）
- 配置项参考 `.env.example`