# ⚠️ 重要な設定ポイント

## エントリーポイント設定について

### 🚨 絶対に変更してはいけない設定

`pyproject.toml`の以下の設定は**必ず**維持すること：

```toml
[project.scripts]
duckduckgo-mcp-server = "server:cli_main"  # ← これを変更しない！
test-search = "test_search:main"
```

### ❌ 間違った設定（エラーになる）

```toml
duckduckgo-mcp-server = "server:main"  # ← これはダメ！
```

**理由**: `main`は`async`関数のため、直接エントリーポイントとして呼び出せない。

### ✅ 正しい設定

```toml
duckduckgo-mcp-server = "server:cli_main"  # ← これが正しい！
```

**理由**: `cli_main`は同期関数で、内部で`asyncio.run(main())`を呼び出している。

## 関数の説明

### `main()` - 非同期メイン関数
```python
async def main():
    """メイン関数"""
    logger.info("DuckDuckGo MCP Server を起動中...")
    # ... MCP Server処理 ...
```

### `cli_main()` - エントリーポイント用ラッパー
```python
def cli_main():
    """コマンドライン実行用のエントリーポイント"""
    asyncio.run(main())
```

## エラーの確認方法

### 正常な場合
```bash
$ timeout 5 uv run duckduckgo-mcp-server
INFO:server:DuckDuckGo MCP Server を起動中...
# 5秒後にタイムアウトで終了（正常）
```

### エラーの場合
```bash
$ timeout 5 uv run duckduckgo-mcp-server
<coroutine object main at 0x...>
sys:1: RuntimeWarning: coroutine 'main' was never awaited
# ← このエラーが出たら設定が間違っている
```

## 修正手順

1. `pyproject.toml`を編集
2. `uv sync`を実行（重要！）
3. `timeout 5 uv run duckduckgo-mcp-server`で動作確認

## Claude Desktop設定

Mac側のClaude Desktop設定は以下の通り：

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

## 📝 チェックリスト

設定完了の確認：

- [ ] `pyproject.toml`のエントリーポイントが`server:cli_main`
- [ ] `uv sync`を実行済み
- [ ] `timeout 5 uv run duckduckgo-mcp-server`でINFOログが表示される
- [ ] Mac側のClaude Desktop設定ファイルが正しい
- [ ] Claude Desktopを再起動済み

全て完了すれば、Claude DesktopからDuckDuckGo検索が利用できる！ 