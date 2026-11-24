#!/bin/sh
set -e

# python:alpine 镜像没有 bashio，用 python 解析 HA 注入的 /data/options.json
read_option() {
    python3 -c "import json;print(json.load(open('/data/options.json')).get('$1','') or '')"
}

ACCOUNT="$(read_option account)"
PASSWORD="$(read_option password)"
API_TOKEN="$(read_option api_token)"

# tokens.json 持久化到 /data，add-on 重启/升级不丢失登录态
export NINEBOT_CONFIG_DIR=/data/ninebot
mkdir -p "$NINEBOT_CONFIG_DIR"

# 已有凭证先验证；失效才重新登录，避免每次启动都请求九号服务器触发风控
NEED_LOGIN=1
if [ -f "$NINEBOT_CONFIG_DIR/tokens.json" ]; then
    if ninecli whoami >/dev/null 2>&1; then
        NEED_LOGIN=0
        echo "[ninebot] 已有登录凭证有效，跳过登录"
    else
        echo "[ninebot] 登录凭证已失效，重新登录"
    fi
fi

if [ "$NEED_LOGIN" = "1" ]; then
    if [ -z "$ACCOUNT" ] || [ -z "$PASSWORD" ]; then
        echo "[ninebot] 未配置九号账号或密码，无法登录（请到 add-on 配置页填写）"
    else
        echo "[ninebot] 正在使用九号账号登录..."
        if ninecli login -u "$ACCOUNT" -p "$PASSWORD"; then
            echo "[ninebot] 登录成功"
        else
            echo "[ninebot] 登录失败，请检查账号密码是否正确"
        fi
    fi
fi

# 启动明文 REST 代理，供 HA 的 RESTful 集成读取
if [ -n "$API_TOKEN" ]; then
    echo "[ninebot] REST 服务启动于 0.0.0.0:18009（已启用 Bearer 鉴权）"
    exec ninecli serve --bind 0.0.0.0:18009 --token "$API_TOKEN"
else
    echo "[ninebot] REST 服务启动于 0.0.0.0:18009（未启用鉴权）"
    exec ninecli serve --bind 0.0.0.0:18009
fi
