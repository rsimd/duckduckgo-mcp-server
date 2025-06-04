# DuckDuckGo MCP Server トラブルシューティングガイド

## 問題: "Server disconnected" エラー

### 症状
Claude Desktopで「MCP duckduckgo-search: Server disconnected.」と表示される

### 診断手順

#### 1. Ubuntu側での基本確認

```bash
# プロジェクトディレクトリに移動
cd /home/mriki/Workspace/duckduckgo-mcp-server

# MCP Serverの直接起動テスト
timeout 5 uv run duckduckgo-mcp-server
```

**期待される結果**: `INFO:server:DuckDuckGo MCP Server を起動中...` が表示され、5秒後にタイムアウトで終了

#### 2. 検索機能のテスト

```bash
uv run test-search "connection test"
```

**期待される結果**: 検索結果（またはフォールバック結果）が表示される

#### 3. Mac側からのSSH接続テスト

```bash
# 基本接続
ssh dogossegiar.tailb42ea.ts.net "echo 'SSH接続成功'"

# パス確認
ssh dogossegiar.tailb42ea.ts.net "cd /home/mriki/Workspace/duckduckgo-mcp-server && pwd"

# MCP Server起動テスト
ssh dogossegiar.tailb42ea.ts.net "cd /home/mriki/Workspace/duckduckgo-mcp-server && timeout 3 uv run duckduckgo-mcp-server"
```

### 一般的な問題と解決方法

#### 1. エントリーポイントエラー

**症状**: `<coroutine object main at 0x...>` エラー

**解決方法**: 
- `server.py`にcli_main()関数が定義されていることを確認
- `pyproject.toml`のエントリーポイントが`server:cli_main`になっていることを確認

#### 2. InitializationOptions エラー

**症状**: `capabilities Field required` エラー

**解決方法**:
```python
InitializationOptions(
    server_name="duckduckgo-search",
    server_version="1.0.0",
    capabilities={}
)
```

#### 3. SSH接続問題

**症状**: SSH接続が失敗する

**解決方法**:
```bash
# Tailscale接続確認
tailscale ping dogossegiar.tailb42ea.ts.net

# SSH設定確認
ssh -v dogossegiar.tailb42ea.ts.net

# 公開鍵認証設定
ssh-copy-id dogossegiar.tailb42ea.ts.net
```

#### 4. パス問題

**症状**: `No such file or directory` エラー

**解決方法**:
- パスが正確であることを確認: `/home/mriki/Workspace/duckduckgo-mcp-server`
- 権限を確認: `ls -la /home/mriki/Workspace/duckduckgo-mcp-server`

#### 5. uvコマンド問題

**症状**: `uv: command not found`

**解決方法**:
```bash
# uvのインストール確認
which uv

# 代替手段（Python直接実行）
python3 server.py
```

### Claude Desktop設定の確認

#### Mac側設定ファイル
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

#### 正しい設定内容
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

### 利用可能なツール

MCP Serverが正常に動作する場合、以下のツールが利用可能:

- **ツール名**: `search_duckduckgo`
- **パラメータ**: 
  - `query` (必須): 検索クエリ
  - `max_results` (任意): 最大結果数（デフォルト: 10）

### 使用例

Claude Desktopでの使用例:
```
DuckDuckGoで「Python プログラミング」を検索して
```

### デバッグ用設定

詳細なログが必要な場合:

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "ssh",
      "args": [
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && PYTHONUNBUFFERED=1 uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

### 最終確認チェックリスト

- [ ] Ubuntu側でMCP Serverが起動する
- [ ] SSH接続が機能する
- [ ] Claude Desktop設定ファイルが正しい
- [ ] Claude Desktopを再起動した
- [ ] Tailscale接続が安定している

### 連絡先・サポート

問題が解決しない場合は、以下の情報を含めてサポートに連絡:

1. エラーメッセージの詳細
2. 実行したコマンドと結果
3. 環境情報（OS、Pythonバージョン、uvバージョン）
4. Claude Desktop設定ファイルの内容 