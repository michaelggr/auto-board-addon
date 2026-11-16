# auto-board Home Assistant Add-on

将 [auto-board](https://github.com/michaelggr/auto-board)（米家极客版 + Home Assistant 双源自动化看板）以 Add-on 形式嵌入 Home Assistant。

## 安装

1. HA → 设置 → 加载项 → 加载项商店 → 右上角「⋮」→ 仓库
2. 添加仓库地址：`https://github.com/michaelggr/auto-board-addon`
3. 在商店中找到 **auto-board**，点击安装
4. 在「配置」页按需填写：
   - `gateway_url`：米家极客版中枢网关地址，如 `http://192.168.1.5`（留空则只启用 HA 侧）
   - `board_token`：看板访问令牌（可选；留空则每次启动随机生成并打印到 add-on 日志）
5. 启动 add-on，开启「显示于侧边栏」
6. 从 HA 侧边栏进入 auto-board，粘贴令牌（若未固定 token，请在 add-on 日志中查看）
7. 极客版首次使用：在页面黄条中输入 6 位网关登录码（一次性）

## 说明

- HA 地址与令牌由 Supervisor 自动注入，无需手动配置
- 数据（SQLite + 每日备份）保存在 add-on 的 `/data`，纳入 HA 快照
- 支持 amd64 与 aarch64（树莓派）架构
