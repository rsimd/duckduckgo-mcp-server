# DuckDuckGo MCP Server - プロジェクト仕様書

## プロジェクト概要

DuckDuckGoの検索機能を提供するModel Context Protocol (MCP) サーバーである。非同期処理によりWeb検索を実行し、構造化された結果を返すツールを提供する。

## 技術仕様

### 使用技術
- **言語**: Python 3.11+ (推奨: Python 3.13)
- **フレームワーク**: MCP (Model Context Protocol)
- **HTTP クライアント**: httpx
- **データ検証**: pydantic
- **非同期処理**: asyncio
- **コンテナ化**: Docker & Docker Compose
- **パッケージ管理**: uv (推奨) または pip

### 依存関係
```
mcp>=1.0.0
httpx>=0.25.0
pydantic>=2.0.0
asyncio-throttle>=1.0.0
```

## ファイル構成

```
duckduckgo-mcp-server/
├── server.py              # メインのMCPサーバー実装
├── pyproject.toml         # uvプロジェクト設定（推奨）
├── requirements.txt       # Python依存関係（従来）
├── run.py                 # 実行スクリプト（uv/python自動判定）
├── README.md             # プロジェクト説明
├── test_search.py        # テスト用スクリプト
├── config.json           # MCP設定ファイル
├── .gitignore           # Git除外設定
├── Dockerfile           # Docker設定（Python 3.13 + uv/pip両対応）
├── compose.yaml         # Docker Compose設定
├── .dockerignore        # Docker除外設定
└── specifications.md     # 本仕様書
```

## 実装仕様

### 1. メインサーバー (`server.py`)

#### クラス構成

**SearchResult (Pydantic Model)**
```python
class SearchResult(BaseModel):
    title: str      # 検索結果のタイトル
    url: str        # 検索結果のURL
    snippet: str    # 検索結果の要約
```

**DuckDuckGoSearcher**
- `base_url`: "https://html.duckduckgo.com/html/"
- `headers`: User-Agentを含むHTTPヘッダー
- `search()`: 非同期検索メソッド
- `_parse_html_results()`: HTML結果パース
- `_clean_html()`: HTMLタグ除去

#### MCP ツール仕様

**search_duckduckgo**
- **説明**: DuckDuckGoで検索を実行し、結果を取得する
- **入力パラメータ**:
  - `query` (必須): 検索クエリ文字列
  - `max_results` (オプション): 最大結果数 (デフォルト: 10, 範囲: 1-20)
- **出力**: フォーマットされた検索結果テキスト

#### HTMLパース仕様
- DuckDuckGoのHTML構造から結果を抽出
- `class="result__title"`でタイトルとURL抽出
- `class="result__snippet"`でスニペット抽出
- HTMLタグとエンティティの除去処理

### 2. テストスクリプト (`test_search.py`)

#### テスト内容
- 3つのテストクエリで検索機能を検証
  - "Python プログラミング"
  - "機械学習 入門"  
  - "東京 天気"
- 各クエリで最大5件の結果を取得
- エラーハンドリングの確認

### 3. 設定ファイル (`config.json`)

#### MCP設定
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "python",
      "args": ["server.py"],
      "cwd": ".",
      "env": {}
    }
  }
}
```

### 4. Docker設定

#### Dockerfile
- ベースイメージ: `python:3.11-slim`
- 必要なシステム依存関係のインストール
- Python依存関係のインストール
- アプリケーションファイルのコピー
- 実行権限の設定

#### Docker Compose (compose.yaml)
- **メインサービス**: `duckduckgo-mcp-server`
  - MCPサーバーの実行
  - 環境変数設定
  - ログボリューム設定
- **テストサービス**: `test-runner`
  - テスト実行用（プロファイル: testing）
  - メインサービスに依存

## セットアップ手順

### 1. uv環境での実行（推奨）

#### 前提条件
- **Python 3.11以降** (推奨: Python 3.13)
- uv パッケージマネージャー

#### uvのインストール
```bash
# uvのインストール（Linux/macOS）
curl -LsSf https://astral.sh/uv/install.sh | sh

# または、pipでインストール
pip install uv
```

#### プロジェクトセットアップ
```bash
# プロジェクトディレクトリに移動
cd duckduckgo-mcp-server

# 依存関係インストールと仮想環境作成（Python 3.13を推奨）
uv sync
```

#### 動作確認
```bash
# テスト実行
uv run test-search

# サーバー起動（STDIOモード）
uv run duckduckgo-mcp-server

# または、実行スクリプト使用
python run.py          # サーバー起動
python run.py test     # テスト実行
```

### 2. ローカル環境での実行（従来方法）

#### 環境準備
```bash
# プロジェクトディレクトリに移動
cd duckduckgo-mcp-server

# 依存関係インストール（Python 3.11以降が必要）
pip install -r requirements.txt
```

#### 動作確認
```bash
# テスト実行
python test_search.py

# サーバー起動（STDIOモード）
python server.py
```

### 3. Docker環境での実行

#### 前提条件
- Docker Engine 20.10以降
- Docker Compose V2

#### ビルドと起動
```bash
# プロジェクトディレクトリに移動
cd duckduckgo-mcp-server

# イメージのビルドとサービス起動（Python 3.13 + uv/pip両対応）
docker compose up --build -d

# ログの確認
docker compose logs -f duckduckgo-mcp-server

# テスト実行（オプション）
docker compose --profile testing up test-runner

# サービス停止
docker compose down
```

#### コンテナ内での作業
```bash
# コンテナに入る
docker compose exec duckduckgo-mcp-server bash

# テスト手動実行
docker compose exec duckduckgo-mcp-server python test_search.py
```

## 使用方法

### MCPクライアントでの使用

#### uv環境
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

#### ローカル環境（従来）
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "python",
      "args": ["server.py"],
      "cwd": "/path/to/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

#### Docker環境
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "docker",
      "args": ["compose", "exec", "-T", "duckduckgo-mcp-server", "python", "server.py"],
      "cwd": "/path/to/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

### 検索例
```json
{
  "tool": "search_duckduckgo",
  "arguments": {
    "query": "Python async programming",
    "max_results": 5
  }
}
```

## 実装上の注意点

### HTMLパース
- DuckDuckGoのHTML構造に依存した簡易パーサー
- 将来的にはBeautifulSoupやlxml等の堅牢なパーサーに置き換え推奨

### エラーハンドリング
- ネットワークエラーの適切な処理
- HTMLパースエラーの無視（continue）
- MCPエラーレスポンスの返却

### パフォーマンス
- 非同期HTTPクライアント（httpx）使用
- タイムアウト設定: 30秒
- 日本語地域設定（kl=jp-jp）

### Docker環境での注意点
- MCPサーバーはSTDIOモードで動作するため、ポートマッピング不要
- ログは`./logs`ディレクトリにマウント可能
- 環境変数`PYTHONUNBUFFERED=1`でリアルタイムログ出力

## 拡張可能性

### 追加可能な機能
1. **画像検索**: DuckDuckGo画像検索API対応
2. **ニュース検索**: ニュース専用検索
3. **キャッシュ機能**: 検索結果のローカルキャッシュ
4. **フィルタリング**: 言語・地域・日付フィルター
5. **バッチ検索**: 複数クエリの並列処理

### 改善点
1. **HTMLパーサー**: BeautifulSoup4導入
2. **レート制限**: 検索頻度制限機能
3. **ログ強化**: 構造化ログ（JSON形式）
4. **設定外部化**: 環境変数での設定管理
5. **テスト拡充**: ユニットテスト・統合テストの追加
6. **マルチステージビルド**: Dockerイメージの最適化

## Cursorでの再現手順

### 1. プロジェクト作成
```bash
mkdir duckduckgo-mcp-server
cd duckduckgo-mcp-server
```

### 2. ファイル作成順序
1. `pyproject.toml` - uvプロジェクト設定（Python 3.13対応）
2. `requirements.txt` - 依存関係定義（従来互換）
3. `run.py` - 実行スクリプト（uv/python自動判定）
4. `server.py` - メイン実装（238行）
5. `README.md` - プロジェクト説明
6. `test_search.py` - テストスクリプト
7. `config.json` - MCP設定
8. `.gitignore` - Git除外設定
9. `Dockerfile` - Docker設定（Python 3.13）
10. `compose.yaml` - Docker Compose設定
11. `.dockerignore` - Docker除外設定
12. `specifications.md` - 本仕様書

### 3. 重要な実装ポイント
- MCPサーバーの初期化とハンドラー登録
- DuckDuckGoのHTML構造理解
- 非同期プログラミングパターン（Python 3.13の最新機能活用）
- エラーハンドリング戦略
- MCPプロトコル準拠
- Dockerコンテナ最適化（Python 3.13対応）

### 4. デバッグ時の確認点
- DuckDuckGoのレスポンス形式変更
- HTMLパース結果の検証
- MCPクライアントとの通信確認
- 文字エンコーディング問題
- Dockerネットワーク設定
- コンテナ内環境変数
- **Python 3.13固有の非同期処理改善**

この仕様書に従えば、Python 3.13を活用した最新の構成でCursorを使用して同等のプロジェクトを再現できる。 