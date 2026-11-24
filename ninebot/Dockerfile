# 用官方 python alpine 镜像：自带 pip，且 ninecli 提供 musllinux 平台 wheel，可直接安装
FROM python:3.12-alpine

# ninecli 是 Go 编译的 wheel（musllinux_1_2 平台），alpine 可原生运行
RUN pip install --no-cache-dir ninecli

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
