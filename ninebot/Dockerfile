# 用官方 python alpine 镜像：自带 pip，且 ninecli 提供 musllinux 平台 wheel，可直接安装
FROM python:3.12-alpine

# 走国内镜像源安装 ninecli（官方 PyPI 的 files.pythonhosted.org 在国内易读取超时）
RUN pip install --no-cache-dir \
    -i https://pypi.tuna.tsinghua.edu.cn/simple \
    --timeout 120 --retries 5 \
    ninecli

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
