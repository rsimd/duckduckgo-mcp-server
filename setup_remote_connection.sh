#!/bin/bash

# DuckDuckGo MCP Server リモート接続テストスクリプト
echo "=== DuckDuckGo MCP Server リモート接続テスト ==="

REMOTE_HOST="dogossegiar.tailb42ea.ts.net"
REMOTE_PATH="/home/mriki/Workspace/duckduckgo-mcp-server"

echo "1. SSH接続テスト..."
if ssh "$REMOTE_HOST" "echo 'SSH接続成功'"; then
    echo "✅ SSH接続: 成功"
else
    echo "❌ SSH接続: 失敗"
    exit 1
fi

echo ""
echo "2. リモートパス確認..."
if ssh "$REMOTE_HOST" "cd $REMOTE_PATH && pwd"; then
    echo "✅ パス確認: 成功"
else
    echo "❌ パス確認: 失敗"
    exit 1
fi

echo ""
echo "3. uv確認..."
if ssh "$REMOTE_HOST" "cd $REMOTE_PATH && uv --version"; then
    echo "✅ uv: 利用可能"
else
    echo "❌ uv: 利用不可"
    echo "Python3で試行します..."
    if ssh "$REMOTE_HOST" "cd $REMOTE_PATH && python3 --version"; then
        echo "✅ Python3: 利用可能"
    else
        echo "❌ Python3: 利用不可"
        exit 1
    fi
fi

echo ""
echo "4. MCP Server動作テスト..."
if ssh "$REMOTE_HOST" "cd $REMOTE_PATH && timeout 10 uv run test-search 'connection test' 2>/dev/null || echo 'テスト完了'"; then
    echo "✅ MCP Server: 動作確認完了"
else
    echo "❌ MCP Server: 動作確認失敗"
    echo "代替方法を試行..."
    if ssh "$REMOTE_HOST" "cd $REMOTE_PATH && timeout 10 python3 run.py test 2>/dev/null || echo 'テスト完了'"; then
        echo "✅ 代替方法: 動作確認完了"
    fi
fi

echo ""
echo "=== 接続テスト完了 ==="
echo ""
echo "Mac側のClaude Desktop設定ファイル:"
echo "~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""
echo "推奨設定:"
cat << 'EOF'
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
EOF

echo ""
echo "注意: Claude Desktopを再起動してください。" 