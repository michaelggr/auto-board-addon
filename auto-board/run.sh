#!/bin/sh
set -e

# HA 连接：add-on 由 Supervisor 自动注入 SUPERVISOR_TOKEN，走 supervisor 内部地址访问 HA API
export HA_URL="http://supervisor/core"
export HA_TOKEN="${SUPERVISOR_TOKEN}"

# 从 add-on 配置读取可选项（/data/options.json 由 Supervisor 生成）
export GATEWAY_URL="$(node -e "try{console.log(require('/data/options.json').gateway_url||'')}catch(e){console.log('')}")"
BOARD_TOKEN="$(node -e "try{console.log(require('/data/options.json').board_token||'')}catch(e){console.log('')}")"
if [ -n "${BOARD_TOKEN}" ]; then
  export BOARD_TOKEN
fi

# ingress 模式下监听容器内全部网卡（仅在容器网络命名空间内，由 Supervisor ingress 代理，不公网暴露）
export HOST="0.0.0.0"
export PORT="3423"
export DB_PATH="/data/auto-board.db"
export TZ="Asia/Shanghai"

exec npx next start -H 0.0.0.0 -p 3423
