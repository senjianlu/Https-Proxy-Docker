# Https-Proxy-Docker

## 启动
```bash
# 目录映射
docker run -d \
  --name=my_https_proxy \
  -p 443:443 \
  -v /rab/docker/https_proxy/config/cat/:/root/cat/ \
  -v /rab/docker/https_proxy/config/ssl/:/root/ssl/ \
  rabbir/https_proxy:latest

# 环境变量
docker run -d \
  --name=my_https_proxy \
  -p 443:443 \
  -e STUNNEL_SSL_CA_PEM="===CA===" \
  -e STUNNEL_SSL_PRIVATE_KEY_PEM="===CERT===" \
  -e CLASH_CONFIG_DOWNLOAD_URL="https://example.com/clash.yaml" \
  -e CLASH_CONFIG_DOWNLOAD_PASSWORD="password" \
  rabbir/https_proxy:latest
```
