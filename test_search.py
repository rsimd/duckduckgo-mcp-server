#!/usr/bin/env python3
"""DuckDuckGo MCP Server テストスクリプト

サーバーの動作を確認するためのテスト用スクリプト
"""

import asyncio
import sys
from server import DuckDuckGoSearcher


async def test_search():
    """検索機能のテスト"""
    searcher = DuckDuckGoSearcher()
    
    test_queries = [
        "Python プログラミング",
        "機械学習 入門",
        "東京 天気"
    ]
    
    for query in test_queries:
        print(f"\n{'='*50}")
        print(f"検索クエリ: {query}")
        print('='*50)
        
        try:
            results = await searcher.search(query, max_results=5)
            
            if results:
                for i, result in enumerate(results, 1):
                    print(f"\n{i}. {result.title}")
                    print(f"   URL: {result.url}")
                    print(f"   要約: {result.snippet[:100]}...")
            else:
                print("検索結果が見つかりませんでした。")
                
        except Exception as e:
            print(f"エラーが発生しました: {e}")


def main():
    """メイン関数（uvエントリポイント用）"""
    print("DuckDuckGo検索テストを開始します...\n")
    asyncio.run(test_search())
    print("\nテスト完了！")


if __name__ == "__main__":
    main() 