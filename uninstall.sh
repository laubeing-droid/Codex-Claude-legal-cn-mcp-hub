#!/usr/bin/env bash
# uninstall.sh — 卸载中国法律 MCP 连接器配置 (macOS/Linux)
set -euo pipefail

MY_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${MY_DIR}/detect.sh"

echo "=== 卸载中国法律 MCP 连接器 ==="
echo ""

ENVS=$(detect_environments)

read -r -p "将从所有检测到的 MCP 客户端配置中移除法律连接器，确认？(y/N): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "取消卸载。"
    exit 0
fi

echo "$ENVS" | python3 -c "
import json, sys, os, re

envs = json.load(sys.stdin)
to_remove = [
    'chineselaw',
    'pkulaw-law-search', 'pkulaw-law-keyword',
    'pkulaw-case-semantic-search', 'pkulaw-case-keyword',
    'pkulaw-law-item-keyword', 'pkulaw-law-recognition',
    'pkulaw-case-number-recognition', 'pkulaw-citation-validator',
    'pkulaw-doc-link', 'pkulaw-semantic-nlsql'
]
for e in envs:
    cp = e['config']
    if not os.path.exists(cp):
        print(f\"  [!!] {e['display']}: 配置文件不存在\")
        continue
    with open(cp, 'r', encoding='utf-8') as f:
        content = f.read()
    original = content
    removed = []

    if e['format'] == 'toml':
        for section in to_remove:
            pattern = re.compile(
                rf'\\n?\\[mcp_servers\\.{re.escape(section)}\\]'
                rf'.*?(?=\\n\\[mcp_servers\\.|\\Z)',
                re.DOTALL
            )
            if pattern.search(content):
                content = pattern.sub('', content)
                removed.append(section)
    else:
        try:
            cfg = json.loads(content)
            servers = cfg.get('mcpServers', {{}})
            for name in to_remove:
                if name in servers:
                    del servers[name]
                    removed.append(name)
            cfg['mcpServers'] = servers
            content = json.dumps(cfg, ensure_ascii=False, indent=2)
        except:
            print(f\"  [!!] {e['display']}: 配置文件格式错误\")
            continue

    if content != original:
        content = re.sub(r'\\n{3,}', '\\n\\n', content).strip()
        with open(cp, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f\"  [OK] {e['display']}: 移除了 {len(removed)} 个连接器\")
        for r in removed:
            print(f\"       - {r}\")
    else:
        print(f\"  [!]  {e['display']}: 未找到法律连接器配置\")
"

echo ""
echo "卸载完成。重启对应客户端使生效。"
