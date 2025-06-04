# DuckDuckGo MCP Server - リモート環境設定手順

## 構成概要

- **Ubuntu Server**: MCP Serverが動作（dogossegiar.tailb42ea.ts.net）
- **Mac Client**: Claude Desktopが動作
- **接続**: Tailscale経由でSSH接続

## 前提条件

1. **Ubuntu側**:
   - MCP Serverが正常に動作している
   - SSH接続が可能である
   - uvがインストール済みである

2. **Mac側**:
   - Claude Desktopがインストール済みである
   - Tailscaleで接続済みである
   - SSH鍵認証が設定済みである

## 設定手順

### 1. SSH接続の確認

Mac側で接続テストを実行：

```bash
ssh dogossegiar.tailb42ea.ts.net "cd /home/mriki/Workspace/duckduckgo-mcp-server && pwd && uv --version"
```

### 2. MCP Server動作確認

Ubuntu側でMCP Serverが動作することを確認：

```bash
ssh dogossegiar.tailb42ea.ts.net "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run test-search 'test query'"
```

### 3. Claude Desktop設定（Mac側）

Claude Desktop設定ファイルの場所：
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

### 4. 設定ファイルの内容

以下の内容で設定ファイルを作成：

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

## 代替設定オプション

### オプション1: SSH設定ファイル使用

`~/.ssh/config`でホスト設定がある場合：

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "ubuntu-server",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

SSH設定例（`~/.ssh/config`）：
```
Host ubuntu-server
    HostName dogossegiar.tailb42ea.ts.net
    User mriki
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
```

### オプション2: ユーザー名明示指定

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

### オプション3: Python直接実行

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

### オプション4: 実行スクリプト使用

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

## SSH設定の最適化

### 1. SSH鍵認証の設定

パスワード認証ではなく鍵認証を使用することを推奨：

```bash
# Mac側で鍵ペア生成（まだない場合）
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# 公開鍵をUbuntuサーバーに送信
ssh-copy-id dogossegiar.tailb42ea.ts.net
```

### 2. SSH接続の安定化

`~/.ssh/config`に以下を追加：

```
Host dogossegiar.tailb42ea.ts.net
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
```

接続用ディレクトリを作成：
```bash
mkdir -p ~/.ssh/sockets
```

## トラブルシューティング

### 1. SSH接続エラー

```bash
# 接続テスト
ssh -v dogossegiar.tailb42ea.ts.net

# Tailscale接続確認
tailscale ping dogossegiar.tailb42ea.ts.net
```

### 2. MCP Server起動エラー

```bash
# リモートでの手動テスト
ssh dogossegiar.tailb42ea.ts.net
cd /home/mriki/Workspace/duckduckgo-mcp-server
uv run duckduckgo-mcp-server
```

### 3. 権限エラー

```bash
# ファイル権限確認
ssh dogossegiar.tailb42ea.ts.net "ls -la /home/mriki/Workspace/duckduckgo-mcp-server"
```

### 4. デバッグ設定

詳細なログが必要な場合：

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

## セキュリティ考慮事項

1. **SSH鍵の管理**: 秘密鍵を適切に保護する
2. **Tailscale ACL**: 必要に応じてアクセス制御を設定
3. **ファイアウォール**: 不要なポートを閉じる
4. **定期的な更新**: システムとパッケージの更新

## 動作確認

### 1. 接続テスト

```bash
ssh dogossegiar.tailb42ea.ts.net "echo 'SSH接続成功'"
```

### 2. MCP Server テスト

```bash
ssh dogossegiar.tailb42ea.ts.net "cd /home/mriki/Workspace/duckduckgo-mcp-server && uv run test-search 'Python'"
```

### 3. Claude Desktop確認

Claude Desktopで以下をテスト：

```
DuckDuckGoで「リモート検索テスト」を検索して
```

## 設定完了後の利用

設定が完了すると、Claude Desktop（Mac）からUbuntu上のMCP Serverを透過的に利用できる。

- **レスポンス時間**: ネットワーク遅延が発生する可能性
- **安定性**: Tailscale接続の安定性に依存
- **セキュリティ**: SSH経由のため安全

これでリモート環境でのMCP Server利用が可能になる。 