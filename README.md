# Https-Proxy-Docker

## 启动
### 一、目录映射启动
需要文件：
- `/root/cat/clash.yaml`：Clash 配置文件
- `/root/ssl/certificate.pem`：证书文件
- `/root/ssl/ca.pem`：CA 文件
- `/root/ssl/private.pem`：私钥文件

```bash
# 目录映射
docker run -d \
  --name=my_https_proxy \
  -p 80:80 \
  -p 443:443 \
  -v /rab/docker/https_proxy/config/cat/:/root/cat/ \
  -v /rab/docker/https_proxy/config/ssl/:/root/ssl/ \
  rabbir/https_proxy:latest
```

### 二、环境变量启动
环境变量：
- `STUNNEL_SSL_CERTIFICATE_PEM`：证书内容（逗号替换换行）
    > ```
    > -----BEGIN CERTIFICATE----- MIIGXzCCBExxxxxxxxxxxxxxxxxxBAQwFADBL MQswCQYDVxxxxxxxxxxxxxxxxxxxxxxyb1NT TCBSU0EgxxxxxxxxxxxxxxxxxxxxxxAwMFoXDTI0 sk5x -----END CERTIFICATE-----
    > ```
- `STUNNEL_SSL_CA_PEM`：CA 内容（逗号替换换行）
    > ```
    > -----BEGIN CERTIFICATE----- MIIGXzCCBExxxxxxxxxxxxxxxxxxBAQwFADBL MQswCQYDVxxxxxxxxxxxxxxxxxxxxxxyb1NT TCBSU0EgxxxxxxxxxxxxxxxxxxxxxxAwMFoXDTI0 sk5x -----END CERTIFICATE-----
    > ```
- `STUNNEL_SSL_PRIVATE_KEY_PEM`：私钥内容（逗号替换换行）
    > ```
    > -----BEGIN RSA PRIVATE KEY----- MIIEowIBAAKCAQEAxxxxxxxxxxxxxxxxxxxxxwFADBL MQswCQYDVxxxxxxxxxxxxxxxxxxxxxxyb1NT TCBSU0EgxxxxxxxxxxxxxxxxxxxxxxAwMFoXDTI0 sk5x -----END RSA PRIVATE KEY-----
    > ```
- `CLASH_CONFIG_DOWNLOAD_URL`：Clash 配置文件下载地址（仅支持 Seafile 分享链接）
- `CLASH_CONFIG_DOWNLOAD_PASSWORD`：Clash 配置文件下载密码（Seafile 分享链接密码）

```bash
# 环境变量
docker run -d \
  --name=my_https_proxy \
  -p 80:80 \
  -p 443:443 \
  -e STUNNEL_SSL_CERTIFICATE_PEM="===CERT===" \
  -e STUNNEL_SSL_CA_PEM="===CA===" \
  -e STUNNEL_SSL_PRIVATE_KEY_PEM="===KEY===" \
  -e CLASH_CONFIG_DOWNLOAD_URL="https://example.com/clash.yaml" \
  -e CLASH_CONFIG_DOWNLOAD_PASSWORD="password" \
  rabbir/https_proxy:latest
```