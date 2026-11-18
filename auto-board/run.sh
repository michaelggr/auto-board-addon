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

# HA 连接：优先用显式配置的 ha_url + ha_token（长期令牌直连，规避 supervisor 代理个别端点 401）；
# 未配置则回退 Supervisor 注入（http://supervisor/core + SUPERVISOR_TOKEN）
HA_URL_OPT="$(read_option ha_url)"
HA_TOKEN_OPT="$(read_option ha_token)"
if [ -n "${HA_URL_OPT}" ] && [ -n "${HA_TOKEN_OPT}" ]; then
  export HA_URL="${HA_URL_OPT}"
  export HA_TOKEN="${HA_TOKEN_OPT}"
else
  export HA_URL="http://supervisor/core"
  export HA_TOKEN="${SUPERVISOR_TOKEN}"
fi

# 数据落在 add-on 持久目录，纳入 HA 快照（含每日备份 /data/backup）
export DB_PATH="/data/auto-board.db"
export TZ="Asia/Shanghai"

# 容器内监听全部网卡；对外仅由 add-on 端口映射暴露 3423
exec npx next start -H 0.0.0.0 -p 3423
