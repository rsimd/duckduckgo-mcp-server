FROM python:3.13-slim

# 作業ディレクトリを設定
WORKDIR /app

# システムの依存関係をインストール（uvもインストール）
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && pip install uv

# プロジェクト設定ファイルをコピー
COPY pyproject.toml ./
COPY requirements.txt ./
COPY README.md ./

# uvがある場合はuvを使用、そうでなければpipを使用
RUN if [ -f pyproject.toml ]; then \
        uv venv && \
        . .venv/bin/activate && \
        uv pip install -e .; \
    else \
        pip install --no-cache-dir -r requirements.txt; \
    fi

# アプリケーションのソースコードをコピー
COPY . .

# ファイルに実行権限を付与
RUN chmod +x server.py test_search.py

# 環境変数設定（uvの仮想環境を使用する場合）
ENV PATH="/app/.venv/bin:$PATH"

# ポートを公開（MCPはSTDIOを使用するため、実際には使用されない）
EXPOSE 8000

# デフォルトコマンド（uvの仮想環境が存在する場合はそれを使用）
CMD ["/bin/bash", "-c", "if [ -d .venv ]; then source .venv/bin/activate && python server.py; else python server.py; fi"] 