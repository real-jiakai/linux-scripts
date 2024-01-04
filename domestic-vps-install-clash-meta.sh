#!/bin/bash

# 检查是否提供了配置文件链接
if [ "$#" -ne 1 ]; then
    echo "用法: $0 <订阅链接>"
    exit 1
fi

SUBSCRIPTION_URL=$1

echo "开始安装 Clash Meta..."

# 下载 Clash Meta
wget https://gh-hk.gujiakai.top/https://github.com/MetaCubeX/mihomo/releases/download/v1.18.0/mihomo-linux-amd64-v1.18.0.gz

# 解压并重命名
gunzip mihomo-linux-amd64-v1.18.0.gz
mv mihomo-linux-amd64-v1.18.0 clash-meta

# 移动到 /usr/local/bin 并添加执行权限
mv clash-meta /usr/local/bin/
chmod +x /usr/local/bin/clash-meta

# 创建 Clash 文件夹并下载 Country.mmdb
mkdir -p /opt/clash
cd /opt/clash
wget https://gh-hk.gujiakai.top/https://github.com/Dreamacro/maxmind-geoip/releases/download/20231012/Country.mmdb

# 下载配置文件
curl -fsSL "$SUBSCRIPTION_URL" -o config.yaml

# 克隆 Yacd-meta 面板
git clone -b gh-pages https://gh-hk.gujiakai.top/https://github.com/kogekiplay/Yacd-meta ui

# 创建并配置 clash-meta.service 文件
cat <<EOF > /etc/systemd/system/clash-meta.service
[Unit]
Description=Clash Meta daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/clash-meta -d /opt/clash/
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 重启 systemd 并启动 Clash Meta
systemctl daemon-reload
systemctl enable --now clash-meta

echo "Clash Meta 安装完成。"
