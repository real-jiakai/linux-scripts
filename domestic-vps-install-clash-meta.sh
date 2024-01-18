#!/bin/bash

# 检查订阅链接地址是否提供
check_subscription_link() {
    if [ -z "$1" ]; then
        echo "Error: No subscription link provided."
        echo "Usage: $0 <subscription_link_url>"
        exit 1
    elif [[ "$1" != http* ]]; then
        echo "Error: Invalid subscription link. The link must start with 'http'."
        exit 1
    fi
    SUBSCRIPTION_LINK="$1"
}

# 设置clash-meta
setup_clash_meta() {
    # 检测包管理器并设置安装命令
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        PKG_INSTALL_CMD="apt install -y"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        PKG_INSTALL_CMD="yum install -y"
    else
        echo "Neither apt nor yum package manager found. Cannot install git and wget."
        exit 1
    fi

    # 安装 git 和 wget 如果它们未安装
    for pkg in git wget; do
        if ! command -v "$pkg" &> /dev/null; then
            echo "Installing $pkg..."
            $PKG_INSTALL_CMD "$pkg"
        fi
    done
    
    # 下载并安装 Clash Meta
    echo "开始安装 Clash Meta..."
    wget https://gh-hk.gujiakai.top/https://github.com/MetaCubeX/mihomo/releases/download/v1.18.0/mihomo-linux-amd64-v1.18.0.gz
    gunzip mihomo-linux-amd64-v1.18.0.gz
    mv mihomo-linux-amd64-v1.18.0 clash-meta
    mv clash-meta /usr/local/bin/
    chmod +x /usr/local/bin/clash-meta

    # 创建 Clash 目录并下载 Country.mmdb
    mkdir -p /opt/clash
    cd /opt/clash
    wget https://gh-hk.gujiakai.top/https://github.com/Dreamacro/maxmind-geoip/releases/download/20231012/Country.mmdb

    # 下载配置文件
    curl -fsSL "$SUBSCRIPTION_URL" -o config.yaml

    # 克隆 Yacd-meta 面板
    git clone -b gh-pages https://gh-hk.gujiakai.top/https://github.com/kogekiplay/Yacd-meta ui

    echo "Clash Meta 安装和配置完成。"
}

# 设置clash-meta系统服务
setup_and_start_clash_meta_service() {
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

    # 重载 systemd 配置并启动 Clash Meta 服务
    systemctl daemon-reload
    systemctl enable --now clash-meta

    echo "Clash-meta service has been set up and started."
}

# 检查订阅链接
check_subscription_url "$1"

# 安装和设置 Clash Meta
setup_clash_meta

# 设置并启动 Clash Meta 系统服务
setup_and_start_clash_meta_service

# 返回到用户的家目录
cd ~

# 输出完成信息
echo "Clash Meta 安装和服务配置完成。"
