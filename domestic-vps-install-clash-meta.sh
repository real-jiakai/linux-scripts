#!/bin/bash

# 彩色输出函数
print_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

print_section() {
    echo -e "\n\033[1;33m=== $1 ===\033[0m"
}

# 检查订阅链接是否提供
check_subscription_link() {
    print_section "Checking Subscription Link"
    if [ -z "$1" ]; then
        print_error "No subscription link provided."
        echo "Usage: $0 <subscription_link_url>"
        exit 1
    elif [[ "$1" != http* ]]; then
        print_error "Invalid subscription link. The link must start with 'http'."
        exit 1
    fi
    SUBSCRIPTION_LINK="$1"
    print_success "Subscription link validation passed"
}

# 检测包管理器
detect_package_manager() {
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        UPDATE_CMD="apt update"
        INSTALL_CMD="apt install -y"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        UPDATE_CMD="yum update"
        INSTALL_CMD="yum install -y"
    else
        print_error "Neither apt nor yum package manager found. Cannot proceed with installation."
        exit 1
    fi
}

# 安装clash-meta
install_clash_meta() {
    print_section "Installing Clash Meta"
    
    # 1. 优先更新软件包并安装 jq
    print_info "Updating package list and installing jq..."
    $UPDATE_CMD && $INSTALL_CMD jq
    
    # 2. 检查其他必需工具
    print_info "Checking and installing required tools..."
    for tool in git wget curl lsof; do
        if ! command -v $tool &> /dev/null; then
            print_info "Installing $tool..."
            $INSTALL_CMD $tool
        fi
    done
    
    # 3. 创建clash目录
    print_info "Creating clash directory..."
    mkdir -p /root/clash && cd /root/clash
    
    # 4. 获取最新版本并下载
    print_info "Fetching latest Clash Meta release information..."
    VERSION=$(wget -qO- https://gh-api.gujiakai.top/repos/MetaCubeX/mihomo/releases/latest | jq -r .tag_name)
    print_success "Latest version: $VERSION"
    
    DOWNLOAD_URL="https://github.com/MetaCubeX/mihomo/releases/download/${VERSION}/mihomo-linux-amd64-${VERSION}.gz"
    
    print_info "Downloading Clash Meta binary..."
    wget "https://gh.gujiakai.top/${DOWNLOAD_URL}" -O clash-meta.gz
    
    print_info "Extracting and installing Clash Meta binary..."
    gunzip clash-meta.gz
    chmod +x clash-meta
    mv clash-meta /usr/local/bin/
    print_success "Clash Meta binary installed successfully"
    
    # 5. 下载 Country.mmdb
    print_info "Downloading Country.mmdb..."
    wget https://gh.gujiakai.top/https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
    print_success "Country.mmdb downloaded successfully"
    
    # 6. 克隆 UI repository
    print_info "Cloning the UI repository..."
    git clone -b gh-pages https://gh.gujiakai.top/https://github.com/MetaCubeX/Yacd-meta ui
    print_success "UI repository cloned successfully"
    
    # 7. 下载clash订阅配置
    print_info "Downloading clash subscription configuration..."
    wget "$SUBSCRIPTION_LINK" -O config.yaml
    print_success "Configuration downloaded successfully"
    
    print_success "Clash Meta installation completed successfully"
}

# 创建systemd服务
create_and_register_systemd_service() {
    print_section "Creating Systemd Service"
    
    print_info "Creating systemd service file..."
    cat <<EOF > /etc/systemd/system/clash-meta.service
[Unit]
Description=Clash Meta daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/clash-meta -d /root/clash/
Restart=on-failure
RestartSec=3
LimitNOFILE=999999

[Install]
WantedBy=multi-user.target
EOF

    print_info "Enabling and starting clash-meta service..."
    systemctl daemon-reload
    systemctl enable clash-meta
    systemctl start clash-meta
    
    print_success "Clash-meta service has been created, enabled and started"
}

# 主流程
print_section "Starting Clash Meta Installation"

# 检查传递的订阅链接
check_subscription_link "$1"

# 检测包管理器
detect_package_manager

# 安装clash-meta
install_clash_meta

# 创建并注册systemd服务
create_and_register_systemd_service

# 返回到用户的家目录
cd ~

print_section "Installation Complete"
print_success "Clash Meta has been successfully installed and configured"
print_info "You can manage the service using: systemctl {start|stop|restart|status} clash-meta"
print_info "Web UI is available at: http://your-server-ip:9090/ui"
