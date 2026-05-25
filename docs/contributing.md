<!--
version: 3.0.1
module: docs
status: active
-->

# 贡献指南

## 原则
- 修改逻辑时 PowerShell + Bash 双平台同步
- 新增不覆盖（跳过已存在配置段）
- 修改功能后同步更新 docs/

## 目录

| 路径 | 说明 |
|------|------|
| `install.ps1/sh` | 安装入口 |
| `detect.ps1/sh` | 环境检测 |
| `verify.ps1/sh` | 验证 |
| `update.ps1/sh` | 诊断 |
| `uninstall.ps1/sh` | 卸载 |
| `servers/*/` | Python MCP Server |
| `docs/*.md` | 文档 |
| `.github/workflows/` | CI/CD |

## 添加新连接器
1. 在 detect.ps1/sh 中新增检测
2. 在 install.ps1/sh 中新增配置模板
3. 在 verify/update/uninstall 中同步支持
4. 更新 docs/connectors.md 和本文件

## 提交格式
`type: 描述`

| type | 场景 |
|------|------|
| feat | 新功能 |
| fix | 修复 |
| docs | 文档 |
| chore | 工具链/CI |