# DuckDuckGo MCP Server - Claude Desktop設定手順

## 概要

この手順に従って、作成したDuckDuckGo MCP ServerをClaude Desktopで利用できるようにする。

## 前提条件

- Claude Desktopがインストール済みである
- プロジェクトがuvで正常に動作している（`uv sync`が完了済み）

## 設定手順

### 1. Claude Desktop設定ファイルの場所

Linux環境では以下のパスにある：
```
~/.config/claude/claude_desktop_config.json
```

### 2. 設定ディレクトリの作成

設定ディレクトリが存在しない場合は作成する：
```bash
mkdir -p ~/.config/claude
```

### 3. 設定ファイルの編集

`claude_desktop_config.json`を以下の内容で作成・編集する：

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "cwd": "/home/mriki/Workspace/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

### 4. 設定の確認

#### 4.1 プロジェクトが動作することを確認

```bash
cd /home/mriki/Workspace/duckduckgo-mcp-server
uv run duckduckgo-mcp-server
```

#### 4.2 エントリーポイントが動作することを確認

```bash
uv run test-search "Python programming"
```

### 5. Claude Desktopの再起動

設定ファイルを変更した後は、Claude Desktopを完全に再起動する。

### 6. 動作確認

Claude Desktopを起動し、以下のようなメッセージでMCPサーバーの動作を確認する：

```
DuckDuckGoで「Python programming」について検索して
```

## 代替設定オプション

### オプション1: Python直接実行

uvが利用できない場合：

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "python3",
      "args": ["server.py"],
      "cwd": "/home/mriki/Workspace/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

### オプション2: 仮想環境使用

手動で仮想環境を作成した場合：

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "/home/mriki/Workspace/duckduckgo-mcp-server/.venv/bin/python",
      "args": ["server.py"],
      "cwd": "/home/mriki/Workspace/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

### オプション3: run.pyスクリプト使用

自動環境検出を使用する場合：

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "python3",
      "args": ["run.py"],
      "cwd": "/home/mriki/Workspace/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

## トラブルシューティング

### 1. MCP Serverが認識されない

- Claude Desktopを完全に再起動する
- 設定ファイルのJSON構文を確認する
- `cwd`パスが正しいことを確認する

### 2. コマンドが見つからない

- `uv`がインストールされていることを確認する
- パスが正しいことを確認する

### 3. 権限エラー

- プロジェクトディレクトリの読み取り権限を確認する
- 必要に応じて権限を設定する

### 4. ログの確認

デバッグ情報を取得するには：

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "cwd": "/home/mriki/Workspace/duckduckgo-mcp-server",
      "env": {
        "PYTHONUNBUFFERED": "1",
        "LOG_LEVEL": "DEBUG"
      }
    }
  }
}
```

## 利用可能な機能

Claude Desktopで以下の機能が利用できる：

### 1. Web検索ツール

- **ツール名**: `search_web`
- **説明**: DuckDuckGoでWeb検索を実行する
- **パラメータ**: 
  - `query` (文字列): 検索クエリ

### 2. 使用例

```
DuckDuckGoで「機械学習 入門」を検索して最新情報を教えて
```

```
「Python FastAPI」について検索して、チュートリアルを見つけて
```

## 設定完了後の確認事項

1. Claude Desktopのサイドバーに「duckduckgo-search」が表示される
2. 検索要求に対して適切な結果が返される
3. エラーが発生しないことを確認する

これで設定は完了である。 