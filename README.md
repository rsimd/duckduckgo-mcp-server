This project was created by the AI code editor "Cursor".
The large language model (LLM) used by Cursor is "GPT-4.1".
Detailed specifications are documented in [specifications.md](specifications.md).

# DuckDuckGo MCP Server

DuckDuckGoの検索機能を提供するModel Context Protocol (MCP) サーバーです。

## 対応アプリケーション

- **Claude Desktop** - Mac/Windows/Linux
- **Cursor IDE** - AI搭載コードエディター  
- その他のMCP対応アプリケーション

## 機能

- DuckDuckGoでのWebページ検索
- 検索結果の要約と詳細情報の取得
- 非同期処理による高速な検索
- フォールバック機能による安定性確保

## 前提条件

- **Python 3.11以降** (推奨: Python 3.13)
- uv パッケージマネージャー (推奨) または pip

## セットアップ

### uv を使用する場合（推奨）

1. [uv](https://docs.astral.sh/uv/) をインストールします:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

2. プロジェクトの依存関係をインストールします:
```bash
uv sync
```

3. サーバーの起動:
```bash
uv run duckduckgo-mcp-server
# または
python run.py
```

### 従来の方法（pip）

1. 依存関係のインストール:
```bash
pip install -r requirements.txt
```

2. サーバーの起動:
```bash
python server.py
```

## 使用方法

このMCPサーバーは以下のツールを提供します:
- `search_duckduckgo`: DuckDuckGoで検索を実行

## 設定

特別な設定は不要です。DuckDuckGoのAPIは無料で利用可能です。

## テスト

### uv を使用する場合
```bash
uv run test-search
# または
python run.py test
```

### 従来の方法
```bash
python test_search.py
```

## Docker での実行

Docker環境でも実行可能です（Python 3.13 + uvとpipの両方をサポート）:

```bash
# ビルドと起動
docker compose up --build -d

# テスト実行
docker compose --profile testing up test-runner

# 停止
docker compose down
```

## MCP クライアントでの使用

### Claude Desktop

詳細は [`CLAUDE_DESKTOP_SETUP.md`](CLAUDE_DESKTOP_SETUP.md) を参照してください。

#### ローカル環境（uv）
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "cwd": "/path/to/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

### Cursor IDE

詳細は [`CURSOR_SETUP.md`](CURSOR_SETUP.md) を参照してください。

#### プロジェクト設定（`.cursor/mcp.json`）
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "env": {}
    }
  }
}
```

#### グローバル設定（`~/.cursor/mcp.json`）
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "env": {}
    }
  }
}
```

### リモート環境での使用

SSH経由でリモートサーバー上のMCP Serverを利用する場合は [`CONNECTION_SOLUTION.md`](CONNECTION_SOLUTION.md) を参照してください。

## トラブルシューティング

問題が発生した場合は以下を参照してください：

- [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) - 一般的な問題と解決方法
- [`CONNECTION_SOLUTION.md`](CONNECTION_SOLUTION.md) - リモート接続問題の解決方法
- [`IMPORTANT_NOTES.md`](IMPORTANT_NOTES.md) - 重要な設定ポイント

## ライセンス

MIT License 