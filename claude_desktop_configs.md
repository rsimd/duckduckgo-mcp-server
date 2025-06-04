# Claude Desktop設定例

## 1. uv使用（推奨）

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

## 2. Python直接実行

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "python3",
      "args": ["server.py"],
      "cwd": "/path/to/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

## 3. 実行スクリプト使用

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "python3",
      "args": ["run.py"],
      "cwd": "/path/to/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

## 4. 仮想環境使用

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "/path/to/duckduckgo-mcp-server/.venv/bin/python",
      "args": ["server.py"],
      "cwd": "/path/to/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

## 5. Docker使用

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

## パス設定のポイント

### macOS例
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "cwd": "/Users/username/projects/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

### Windows例
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "cwd": "C:\\Users\\username\\projects\\duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

### Linux例
```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "cwd": "/home/username/projects/duckduckgo-mcp-server",
      "env": {}
    }
  }
}
```

## 環境変数設定

デバッグ時やカスタム設定が必要な場合：

```json
{
  "mcpServers": {
    "duckduckgo-search": {
      "command": "uv",
      "args": ["run", "duckduckgo-mcp-server"],
      "cwd": "/path/to/duckduckgo-mcp-server",
      "env": {
        "PYTHONUNBUFFERED": "1",
        "LOG_LEVEL": "DEBUG"
      }
    }
  }
}
``` 