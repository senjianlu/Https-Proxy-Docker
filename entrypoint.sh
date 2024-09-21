#!/bin/sh

# 1. 判断 stunnel 运行要求是否满足
# 1.1 环境变量 STUNNEL_SSL_CA_PEM 是否存在，存在的话写入 /root/ssl/ca.pem 文件
if [ -n "$STUNNEL_SSL_CA_PEM" ]; then
    echo "$STUNNEL_SSL_CA_PEM" > /root/ssl/ca.pem
fi
# 1.2 环境变量 STUNNEL_SSL_PRIVATE_KEY_PEM 是否存在，存在的话写入 /root/ssl/private.pem 文件
if [ -n "$STUNNEL_SSL_PRIVATE_KEY_PEM" ]; then
    echo "$STUNNEL_SSL_PRIVATE_KEY_PEM" > /root/ssl/private.pem
fi
# 1.3 更新 /root/ssl/stunnel.pem 文件
# 合并文件
cat /root/ssl/ca.pem /root/ssl/private.pem > /root/ssl/stunnel.pem

# 2. 判断 clash 运行要求是否满足
# 2.1 环境变量 CLASH_CONFIG_DOWNLOAD_URL 是否存在，存在的话下载配置文件
if [ -n "$CLASH_CONFIG_DOWNLOAD_URL" ]; then
    # CLASH_CONFIG_DOWNLOAD_PASSWORD 环境变量存在的话下载配置文件时带上密码
    if [ -n "$CLASH_CONFIG_DOWNLOAD_PASSWORD" ]; then
        cd /root/ && bash download.sh $CLASH_CONFIG_DOWNLOAD_URL $CLASH_CONFIG_DOWNLOAD_PASSWORD
    else
        cd /root/ && bash download.sh $CLASH_CONFIG_DOWNLOAD_URL
    fi
    # 下载完成后将配置文件移动到 /root/cat/config.yaml
    mv /root/config.yaml /root/cat/config.yaml
fi
# 2.2 判断 /root/cat/config.yaml 文件是否存在
if [ ! -f /root/cat/config.yaml ]; then
    echo "CLASH_CONFIG_DOWNLOAD_URL or /root/cat/config.yaml is required!"
    exit 1
fi

# 3. 启动
# 3.1 启动 stunnel
stunnel
# 3.2 启动 clash
cd /root/ && ./clash -f /root/cat/config.yaml