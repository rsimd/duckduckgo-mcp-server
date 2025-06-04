# 🎯 Cursor IDE - DuckDuckGo MCP Server 設定ガイド

## 概要

Cursor IDEでDuckDuckGo MCP Serverを利用するための設定方法を説明する。CursorはMCP (Model Context Protocol) をネイティブサポートしており、AI Assistantが外部ツールを利用できる。

## 🏗️ 設定オプション

### オプション1: ローカル実行（推奨）

プロジェクト内で直接MCP Serverを実行する方法。

**設定ファイル**: `.cursor/mcp.json`

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

### オプション2: リモート実行

UbuntuサーバーのMCP ServerをSSH経由で利用する方法。

**設定ファイル**: `.cursor/mcp-remote.json`

```json
{
  "mcpServers": {
    "duckduckgo-search-remote": {
      "command": "ssh",
      "args": [
        "-o", "StrictHostKeyChecking=no",
        "dogossegiar.tailb42ea.ts.net",
        "cd /home/mriki/Workspace/duckduckgo-mcp-server && /home/mriki/.local/bin/uv run duckduckgo-mcp-server"
      ],
      "env": {}
    }
  }
}
```

### オプション3: Python直接実行

uvを使わずにPythonで直接実行する方法。

**設定ファイル**: `.cursor/mcp-python.json`

```json
{
  "mcpServers": {
    "duckduckgo-search-python": {
      "command": "python3",
      "args": ["server.py"],
      "env": {}
    }
  }
}
```

## 📋 設定手順

### 1. 設定ファイルの配置

目的に応じて適切な設定ファイルを選択：

#### プロジェクト固有の設定
```bash
# プロジェクトディレクトリ内に作成
cp .cursor/mcp.json .cursor/mcp.json.active
```

#### グローバル設定
```bash
# ホームディレクトリに作成（全プロジェクトで利用）
mkdir -p ~/.cursor
cp .cursor/mcp.json ~/.cursor/mcp.json
```

### 2. Cursorでの確認

1. **Cursor IDEを起動**
2. **Settings → Model Context Protocol** にアクセス
3. **Available Tools** に `search_duckduckgo` が表示されることを確認

### 3. 動作テスト

Cursor ChatでMCP Serverの動作をテスト：

```
DuckDuckGoで「Python プログラミング」を検索して
```

## 🔧 Cursor固有の設定

### Transport Types

Cursorは2つの通信方式をサポート：

#### stdio Transport（推奨）
- ローカルマシンで実行
- Cursorが自動的に管理
- 標準入出力で通信

#### SSE Transport
- ローカル・リモート実行可能
- ネットワーク経由で通信
- チーム間での共有可能

### 設定場所

#### プロジェクト設定
```
.cursor/mcp.json
```
特定のプロジェクトでのみ利用可能

#### グローバル設定  
```
~/.cursor/mcp.json
```
全てのCursorワークスペースで利用可能

## 💡 使用方法

### ツールの自動利用

Cursor Agentは関連性があると判断した場合、自動的にMCPツールを使用する。

### 明示的なツール指定

特定のツールを使用したい場合：

```
DuckDuckGoツールを使って「FastAPI チュートリアル」を検索して
```

### ツール承認

デフォルトでは、Agent がMCPツールを使用する前に承認を求める。

#### Auto-run有効化
設定でAuto-runを有効にすると、承認なしで自動実行される。

## 🎨 利用可能な機能

### 検索ツール

- **ツール名**: `search_duckduckgo`
- **説明**: DuckDuckGoで検索を実行し、結果を取得する
- **パラメータ**:
  - `query` (必須): 検索クエリ
  - `max_results` (任意): 最大結果数（1-20、デフォルト: 10）

### 応答形式

- 構造化された検索結果
- タイトル、URL、要約を含む
- Markdown形式で表示

## 🛠️ トラブルシューティング

### 問題: MCP Serverが認識されない

```bash
# 設定ファイルの構文確認
cat .cursor/mcp.json | jq .

# Cursor再起動
```

### 問題: ツールが表示されない

1. **Settings → Model Context Protocol** で確認
2. 設定ファイルのパスが正しいか確認
3. コマンドが実行可能か確認

### 問題: SSH接続エラー（リモート実行時）

```bash
# SSH接続テスト
ssh dogossegiar.tailb42ea.ts.net "echo 'SSH接続成功'"

# 公開鍵認証確認
ssh-copy-id dogossegiar.tailb42ea.ts.net
```

### 問題: uvコマンドが見つからない

```bash
# uvインストール確認
which uv

# フルパス使用
/home/mriki/.local/bin/uv run duckduckgo-mcp-server
```

## 🔍 デバッグ

### ログ確認

Cursorは内部的にMCPツールの実行をログ出力する。問題が発生した場合：

1. **Developer Console** を開く
2. **Network/Console** タブでエラーを確認
3. 必要に応じて設定を修正

### 詳細ログ有効化

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "env": {
        "PYTHONUNBUFFERED": "1",
        "LOG_LEVEL": "DEBUG"
      }
    }
  }
}
```

## 📊 パフォーマンス

### ローカル実行
- **レスポンス時間**: 1-3秒
- **安定性**: 高
- **リソース**: 軽量

### リモート実行
- **レスポンス時間**: 2-5秒（ネットワーク遅延含む）
- **安定性**: ネットワーク依存
- **利点**: 中央管理可能

## 🚀 活用例

### コード開発時
```
DuckDuckGoで「FastAPI async database」を検索して、非同期データベース処理の実装例を探して
```

### ドキュメント作成時
```
「Python type hints best practices」について最新情報を検索して、ドキュメントに含めて
```

### 学習・調査時
```
「Machine Learning deployment strategies」を検索して、デプロイメント戦略をまとめて
```

これでCursor IDEでも強力なWeb検索機能が利用できる！ 