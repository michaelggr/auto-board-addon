#!/bin/sh
set -e

# 从 add-on 配置读取可选项（/data/options.json 由 Supervisor 生成）
read_option() {
  node -e "try{console.log(require('/data/options.json')['$1']||'')}catch(e){console.log('')}"
}

GATEWAY_URL="$(read_option gateway_url)"
if [ -n "${GATEWAY_URL}" ]; then
  export GATEWAY_URL
fi

# 看板令牌：填了就固定，留空则由应用每次启动随机生成并打印到日志
BOARD_TOKEN="$(read_option board_token)"
if [ -n "${BOARD_TOKEN}" ]; then
  export BOARD_TOKEN
fi

# HA 连接：Supervisor 自动注入 SUPERVISOR_TOKEN，走内部代理地址（无需手填地址与令牌）
export HA_URL="http://supervisor/core"
export HA_TOKEN="${SUPERVISOR_TOKEN}"

# 数据落在 add-on 持久目录，纳入 HA 快照（含每日备份 /data/backup）
export DB_PATH="/data/auto-board.db"
export TZ="Asia/Shanghai"

# 容器内监听全部网卡；对外仅由 add-on 端口映射暴露 3423
exec npx next start -H 0.0.0.0 -p 3423
