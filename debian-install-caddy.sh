#!/bin/bash

# 一键安装 Caddy 的脚本

# 更新系统包
sudo apt update

# 安装依赖
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https

# 添加 Caddy 的 GPG 密钥
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

# 添加 Caddy 的 APT 源
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list

# 更新 APT 包索引
sudo apt update

# 安装 Caddy
sudo apt install caddy

# 输出安装后的 Caddy 版本
caddy version

echo "Caddy 安装完成！"
