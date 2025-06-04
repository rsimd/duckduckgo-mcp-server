# Claude Desktop リモート設定パターン

## 基本構成

- **Ubuntu Server**: dogossegiar.tailb42ea.ts.net
- **MCP Server Path**: /home/mriki/Workspace/duckduckgo-mcp-server
- **Mac Client**: Claude Desktop

## 設定パターン一覧

### 1. 標準設定（推奨）

```json
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
```

### 2. SSH設定ファイル使用

**~/.ssh/config**:
```
Host ubuntu-mcp
    HostName dogossegiar.tailb42ea.ts.net
    User mriki
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
```

**Claude Desktop設定**:
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "ubuntu-mcp",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

### 3. ユーザー名明示

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "mriki@dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

### 4. Python直接実行

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && python3 server.py"
      ],
      "env": {}
    }
  }
}
```

### 5. run.pyスクリプト使用

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && python3 run.py"
      ],
      "env": {}
    }
  }
}
```

### 6. 仮想環境直接指定

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && .venv/bin/python server.py"
      ],
      "env": {}
    }
  }
}
```

### 7. デバッグ有効

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && PYTHONUNBUFFERED=1 LOG_LEVEL=DEBUG uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

### 8. タイムアウト設定

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "timeout",
      "args": [
        "300",
        "ssh",
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

## SSH最適化設定

### ~/.ssh/config 完全版

```
Host dogossegiar.tailb42ea.ts.net
    User mriki
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
    Compression yes
    
Host ubuntu-mcp
    HostName dogossegiar.tailb42ea.ts.net
    User mriki
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
    Compression yes
```

### SSH接続の準備

```bash
# 接続用ディレクトリ作成
mkdir -p ~/.ssh/sockets

# 公開鍵の設定（必要に応じて）
ssh-copy-id dogossegiar.tailb42ea.ts.net
```

## トラブルシューティング用設定

### 1. 詳細ログ出力

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "-v",
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server 2>&1 | tee /tmp/mcp-debug.log"
      ],
      "env": {}
    }
  }
}
```

### 2. 接続強制

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "-o", "ConnectTimeout=10",
        "-o", "ServerAliveInterval=60",
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

## 性能最適化

### 1. 接続キープアライブ

SSH設定に以下を追加:
```
Host dogossegiar.tailb42ea.ts.net
    ServerAliveInterval 30
    ServerAliveCountMax 6
    TCPKeepAlive yes
```

### 2. 圧縮有効化

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "-C",
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

## 接続テスト用コマンド

### 基本接続テスト
```bash
ssh dogossegiar.tailb42ea.ts.net "echo 'SSH接続成功'"
```

### MCP Server テスト
```bash
ssh dogossegiar.tailb42ea.ts.net "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run test-search 'test'"
```

### パフォーマンステスト
```bash
time ssh dogossegiar.tailb42ea.ts.net "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run test-search 'performance test'"
```

これらの設定パターンから、君の環境に最適なものを選択して使用できる。 