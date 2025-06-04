#!/usr/bin/env python3
"""DuckDuckGo MCP Server 実行スクリプト

uvまたはpython直接実行でプロジェクトを起動するためのスクリプト
"""

import subprocess
import sys
import os
from pathlib import Path


def check_uv_available():
    """uvが利用可能かチェック"""
    try:
        subprocess.run(["uv", "--version"], capture_output=True, check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


def run_with_uv():
    """uvを使用してサーバーを実行"""
    print("uvを使用してDuckDuckGo MCP Serverを起動中...")
    try:
        subprocess.run(["uv", "run", "duckduckgo-mcp-server"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"uvでの実行でエラーが発生しました: {e}")
        sys.exit(1)


def run_with_python():
    """標準のpythonを使用してサーバーを実行"""
    print("標準のPythonを使用してDuckDuckGo MCP Serverを起動中...")
    try:
        subprocess.run([sys.executable, "server.py"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Pythonでの実行でエラーが発生しました: {e}")
        sys.exit(1)


def run_test_with_uv():
    """uvを使用してテストを実行"""
    print("uvを使用してテストを実行中...")
    try:
        subprocess.run(["uv", "run", "test-search"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"uvでのテスト実行でエラーが発生しました: {e}")
        sys.exit(1)


def run_test_with_python():
    """標準のpythonを使用してテストを実行"""
    print("標準のPythonを使用してテストを実行中...")
    try:
        subprocess.run([sys.executable, "test_search.py"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Pythonでのテスト実行でエラーが発生しました: {e}")
        sys.exit(1)


def main():
    """メイン関数"""
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        # テストモード
        if check_uv_available() and Path("pyproject.toml").exists():
            run_test_with_uv()
        else:
            run_test_with_python()
    else:
        # サーバー起動モード
        if check_uv_available() and Path("pyproject.toml").exists():
            run_with_uv()
        else:
            run_with_python()


if __name__ == "__main__":
    main() 