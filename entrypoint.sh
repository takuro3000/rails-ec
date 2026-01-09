#!/bin/bash
set -e

# Railsサーバーが残したPIDファイルを削除
# これにより、サーバーが正常にシャットダウンされなかった場合でも再起動可能
rm -f /app/tmp/pids/server.pid

# コンテナのメインプロセスを実行
exec "$@"
