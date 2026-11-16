# 直接复用已发布的多架构镜像，仅替换启动入口以注入 Supervisor 连接信息
FROM ghcr.io/michaelggr/auto-board:latest
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]
