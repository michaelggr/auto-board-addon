# auto-board Home Assistant Add-on

将 [auto-board](https://github.com/michaelggr/auto-board)（米家极客版 + Home Assistant 双源自动化看板）以 Add-on 形式装进 Home Assistant。

## 能力

- HA 地址与令牌由 Supervisor 自动注入，**无需手填 `HA_URL` / `HA_TOKEN`**
- 数据（SQLite + 每日备份）保存在 add-on 的 `/data`，**随 HA 快照一起备份**
- 随 HA 开机自启、由 HA 统一管理与重启
- 支持 amd64 与 aarch64（树莓派）
- 极客版部分完全复用：网页输一次性登录码、75s 心跳、断线黄条降级

## 安装

1. HA → 设置 → 加载项 → 加载项商店 → 右上角「⋮」→ **仓库**
2. 填入：`https://github.com/michaelggr/auto-board-addon` → 添加
3. 刷新商店，找到 **auto-board** → 安装
4. 「配置」页按需填写：
   - `gateway_url`：米家极客版中枢网关地址，如 `http://192.168.1.5`（留空则只跑 HA 半边）
   - `board_token`：看板访问令牌（可选；留空则每次启动随机生成并打印到 add-on 日志）
5. 启动 add-on，点「打开 Web UI」访问 `http://<HA所在机器IP>:3423`
6. 粘贴令牌（若未固定 `board_token`，到 add-on「日志」页查看启动时打印的令牌）
7. 极客版首次使用：页面黄条输入 6 位网关登录码（一次性，重连需新码）

## 可选：加进 HA 侧边栏

Add-on 不用 ingress（Next.js 在 ingress 子路径下静态资源会 404），
如需侧边栏入口，在 `configuration.yaml` 加：

```yaml
panel_iframe:
  auto_board:
    title: auto-board
    icon: mdi:home-automation
    url: http://<HA所在机器IP>:3423
    require_admin: false
```

重启 HA 后侧边栏即出现入口（iframe 内嵌，行为等同直接打开）。

## 端口与网络

- add-on 映射 `3423` 到宿主机，局域网内可访问
- 未使用 host 网络，容器仍可正常访问局域网内的极客版网关与 HA
- 请务必设置 `board_token` 或使用强随机默认值，避免同网段可读写控制接口
