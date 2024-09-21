# 基础镜像系统版本为 ubuntu:20.04
FROM ubuntu:20.04

# 维护者信息
LABEL maintainer="Rabbir admin@cs.cheap"

# Docker 内用户切换到 root
USER root

# 设置时区为东八区
ENV TZ Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime > /etc/timezone

# 安装依赖
RUN apt-get update -y
RUN apt-get install wget -y

# 下载 Clash 和其配置文件
RUN mkdir -vp /root/cat/
WORKDIR /root/
RUN wget https://github.com/senjianlu/Clash-Docker/raw/master/backup/clash
RUN chmod +x /root/clash
# 配置文件
RUN mkdir -vp /root/.config/clash/
WORKDIR /root/.config/clash/
RUN wget https://github.com/senjianlu/Clash-Docker/raw/master/backup/Country.mmdb
RUN wget https://github.com/senjianlu/Clash-Docker/raw/master/backup/cache.db
RUN wget https://github.com/senjianlu/Clash-Docker/raw/master/backup/config.yaml

# 安装 stunnel
RUN mkdir -vp /root/ssl/
WORKDIR /root/
RUN apt-get install stunnel -y
# 编辑配置文件
RUN echo "client = no" > /etc/stunnel/stunnel.conf
RUN echo "[squid]" >> /etc/stunnel/stunnel.conf
RUN echo "accept = 443" >> /etc/stunnel/stunnel.conf
RUN echo "connect = 127.0.0.1:8910" >> /etc/stunnel/stunnel.conf
RUN echo "cert = /root/ssl/stunnel.pem" >> /etc/stunnel/stunnel.conf

# 安装 httpd 以映射证书认证文件
RUN apt-get install apache2 -y
# 创建认证文件存放用的目录
RUN mkdir -vp /root/ssl/.well-known/
RUN mkdir -vp /var/www/html/.well-known/
# 建立软链接
RUN ln -s /root/ssl/.well-known/ /var/www/html/.well-known/

# 下载 Seafile 脚本到容器
WORKDIR /root/
RUN wget https://raw.githubusercontent.com/senjianlu/seafile-scripts/master/download.sh

# 拷贝 entrypoint.sh 到容器
COPY entrypoint.sh /root/entrypoint.sh

# 指定启动的时候执行 entrypoint.sh
ENTRYPOINT ["/bin/sh", "/root/entrypoint.sh" ]