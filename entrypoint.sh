#!/bin/sh

# 1. 判断 stunnel 运行要求是否满足
# 1.1 环境变量 STUNNEL_SSL_CERTIFICATE_PEM 是否存在，存在的话写入 /root/ssl/certificate.pem 文件
if [ -n "$STUNNEL_SSL_CERTIFICATE_PEM" ]; then
    echo "$STUNNEL_SSL_CERTIFICATE_PEM" > /root/ssl/certificate.pem
    # 删除开头的 -----BEGIN CERTIFICATE----- 和结尾的 -----END CERTIFICATE-----
    sed 's/-----BEGIN CERTIFICATE-----//g' -i /root/ssl/certificate.pem
    sed 's/-----END CERTIFICATE-----//g' -i /root/ssl/certificate.pem
    # 将空格替换为换行符
    sed 's/ /\n/g' -i /root/ssl/certificate.pem
    # 删除空行
    sed '/^$/d' -i /root/ssl/certificate.pem
    # 在第一行前添加 -----BEGIN CERTIFICATE-----
    sed -i '1i -----BEGIN CERTIFICATE-----' /root/ssl/certificate.pem
    # 在最后一行后添加 -----END CERTIFICATE-----
    sed -i '$a -----END CERTIFICATE-----' /root/ssl/certificate.pem
fi
# 1.2 环境变量 STUNNEL_SSL_CA_PEM 是否存在，存在的话写入 /root/ssl/ca.pem 文件
if [ -n "$STUNNEL_SSL_CA_PEM" ]; then
    echo "$STUNNEL_SSL_CA_PEM" > /root/ssl/ca.pem
    # 删除开头的 -----BEGIN CERTIFICATE----- 和结尾的 -----END CERTIFICATE-----
    sed 's/-----BEGIN CERTIFICATE-----//g' -i /root/ssl/ca.pem
    sed 's/-----END CERTIFICATE-----//g' -i /root/ssl/ca.pem
    # 将空格替换为换行符
    sed 's/ /\n/g' -i /root/ssl/ca.pem
    # 删除空行
    sed '/^$/d' -i /root/ssl/ca.pem
    # 在第一行前添加 -----BEGIN CERTIFICATE-----
    sed -i '1i -----BEGIN CERTIFICATE-----' /root/ssl/ca.pem
    # 在最后一行后添加 -----END CERTIFICATE-----
    sed -i '$a -----END CERTIFICATE-----' /root/ssl/ca.pem
fi
# 1.3 环境变量 STUNNEL_SSL_PRIVATE_KEY_PEM 是否存在，存在的话写入 /root/ssl/private.pem 文件
if [ -n "$STUNNEL_SSL_PRIVATE_KEY_PEM" ]; then
    echo "$STUNNEL_SSL_PRIVATE_KEY_PEM" > /root/ssl/private.pem
    # 删除开头的 -----BEGIN RSA PRIVATE KEY----- 和结尾的 -----END RSA PRIVATE KEY-----
    sed 's/-----BEGIN RSA PRIVATE KEY-----//g' -i /root/ssl/private.pem
    sed 's/-----END RSA PRIVATE KEY-----//g' -i /root/ssl/private.pem
    # 将空格替换为换行符
    sed 's/ /\n/g' -i /root/ssl/private.pem
    # 删除空行
    sed '/^$/d' -i /root/ssl/private.pem
    # 在第一行前添加 -----BEGIN RSA PRIVATE KEY-----
    sed -i '1i -----BEGIN RSA PRIVATE KEY-----' /root/ssl/private.pem
    # 在最后一行后添加 -----END RSA PRIVATE KEY-----
    sed -i '$a -----END RSA PRIVATE KEY-----' /root/ssl/private.pem
fi
# 1.4 更新 /root/ssl/stunnel.pem 文件
# 合并文件
cat /root/ssl/certificate.pem /root/ssl/ca.pem /root/ssl/private.pem > /root/ssl/stunnel.pem

# 2. 判断 clash 运行要求是否满足
# 2.1 环境变量 CLASH_CONFIG_DOWNLOAD_URL 是否存在，存在的话下载配置文件
if [ -n "$CLASH_CONFIG_DOWNLOAD_URL" ]; then
    # CLASH_CONFIG_DOWNLOAD_PASSWORD 环境变量存在的话下载配置文件时带上密码
    if [ -n "$CLASH_CONFIG_DOWNLOAD_PASSWORD" ]; then
        cd /root/ && bash download.sh $CLASH_CONFIG_DOWNLOAD_URL config.yaml $CLASH_CONFIG_DOWNLOAD_PASSWORD
    else
        cd /root/ && bash download.sh $CLASH_CONFIG_DOWNLOAD_URL config.yaml
    fi
    # 下载完成后将配置文件移动到 /root/cat/config.yaml
    mv /root/config.yaml /root/cat/config.yaml
fi
# 2.2 判断 /root/cat/config.yaml 文件是否存在
if [ ! -f /root/cat/config.yaml ]; then
    echo "CLASH_CONFIG_DOWNLOAD_URL or /root/cat/config.yaml is required!"
    exit 1
fi

# 3. 判断是否满足 apache2 运行要求
# 3.1 /root/ssl/.well-known/ 目录不存在的话创建
if [ ! -d /root/ssl/.well-known ]; then
    mkdir -p /root/ssl/.well-known
fi
echo "Hello, World!" > /root/ssl/.well-known/hello.txt
# 3.2 允许 .well-known 目录被访问
# echo "Alias /.well-known /var/www/html/.well-known" >> /etc/apache2/conf-available/well-known.conf
# echo "<Directory /var/www/html/.well-known>" >> /etc/apache2/conf-available/well-known.conf
# echo "    Options Indexes FollowSymLinks" >> /etc/apache2/conf-available/well-known.conf
# echo "    AllowOverride None" >> /etc/apache2/conf-available/well-known.conf
# echo "    Require all granted" >> /etc/apache2/conf-available/well-known.conf
# echo "</Directory>" >> /etc/apache2/conf-available/well-known.conf
# chown -R www-data:www-data /var/www/html/.well-known
# chmod -R 755 /var/www/html/.well-known
# a2enconf well-known

# 4. 启动
# 4.1 启动 apache2（后台运行）
apachectl -D FOREGROUND &
# 4.2 启动 stunnel（后台运行）
stunnel
# 4.3 启动 clash
cd /root/ && ./clash -f /root/cat/config.yaml