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

# 安装clash-meta
install_clash_meta() {
    print_section "Installing Clash Meta"
    
    # 1. 优先更新软件包并安装 jq
    print_info "Updating package list and installing jq..."
    apt update && apt install jq -y
    
    # 2. 检查其他必需工具
    print_info "Checking and installing required tools..."
    for tool in git wget lsof; do
        if ! command -v $tool &> /dev/null; then
            print_info "Installing $tool..."
            apt install $tool -y
        fi
    done
    
    # 3. 创建clash目录并进入
    print_info "Creating and entering clash directory..."
    mkdir -p ~/clash && cd ~/clash
    
    # Get the latest release information using the mirror API
    print_info "Fetching latest Clash Meta release information..."
    # 1. 获取最新版本号
    VERSION=$(wget -qO- https://gh-api.gujiakai.top/repos/MetaCubeX/mihomo/releases/latest | jq -r .tag_name)
    print_success "Latest version: $VERSION"
    
    # 2. 拼接下载链接
    DOWNLOAD_URL="https://github.com/MetaCubeX/mihomo/releases/download/${VERSION}/mihomo-linux-amd64-${VERSION}.gz"
    
    # 3. 通过镜像下载
    print_info "Downloading Clash Meta binary..."
    wget "https://gh.gujiakai.top/${DOWNLOAD_URL}" -O clash-meta.gz
    
    # 4. 解压
    print_info "Extracting Clash Meta binary..."
    gunzip clash-meta.gz
    
    # 5. 重命名并添加执行权限
    # mv "mihomo-linux-amd64-${VERSION}" clash-meta
    chmod +x clash-meta
    print_success "Clash Meta binary prepared successfully"
    
    # 下载 Country.mmdb (using mirror)
    print_info "Downloading Country.mmdb..."
    wget https://gh.gujiakai.top/https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb
    print_success "Country.mmdb downloaded successfully"
    
    # 克隆 UI repository (using mirror)
    print_info "Cloning the UI repository..."
    git clone -b gh-pages https://gh.gujiakai.top/https://github.com/MetaCubeX/Yacd-meta ui
    print_success "UI repository cloned successfully"
    
    # 下载clash订阅链接
    print_info "Downloading clash subscription configuration..."
    wget "$SUBSCRIPTION_LINK" -O config.yaml
    print_success "Configuration downloaded successfully"
    
    print_success "Clash Meta installation completed successfully"
}

# 创建clash-meta系统服务
create_and_register_clash_meta_service() {
    print_section "Creating System Service"
    
    print_info "Creating service file..."
    cat <<EOF > /etc/init.d/clash-meta
#!/bin/sh
### BEGIN INIT INFO
# Provides:          clash-meta
# Required-Start:    \$network \$remote_fs
# Required-Stop:     \$network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: clash-meta Proxy Services
# Description:       Start or stop the clash-meta proxy services.
### END INIT INFO

CLASH_META="/root/clash/clash-meta"
CLASH_DIR="/root/clash/"

start() {
    echo "Starting clash-meta..."
    nohup \$CLASH_META -d \$CLASH_DIR > /dev/null 2>&1 &
    
    # 等待一秒让进程启动
    sleep 1
    
    # 检查进程是否成功启动
    if pidof -x clash-meta > /dev/null; then
        echo "clash-meta started successfully (PID: $(pidof -x clash-meta))"
        return 0
    else
        echo "Failed to start clash-meta"
        return 1
    fi
}

stop() {
    echo "Stopping clash-meta..."
    PIDS=\$(pidof -x clash-meta)
    if [ -z "\$PIDS" ]; then
        echo "No clash-meta process found."
        return 0
    else
        kill \$PIDS
        sleep 1
        if pidof -x clash-meta > /dev/null; then
            echo "Force stopping clash-meta..."
            kill -9 \$(pidof -x clash-meta)
        fi
        echo "clash-meta stopped successfully."
    fi
}

status() {
    PIDS=\$(pidof -x clash-meta)
    if [ -z "\$PIDS" ]; then
        echo "clash-meta is not running."
        return 1
    else
        echo "clash-meta is running. PIDs: \$PIDS"
        return 0
    fi
}

case "\$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: /etc/init.d/clash-meta {start|stop|restart|status}"
        exit 1
esac
exit 0
EOF

    chmod +x /etc/init.d/clash-meta
    update-rc.d clash-meta defaults
    print_success "Clash-meta service has been created and registered"
}

# 主流程
print_section "Starting Clash Meta Installation"

# 检查传递的订阅链接
check_subscription_link "$1"

# 安装clash-meta
install_clash_meta

# 创建并注册clash-meta服务
create_and_register_clash_meta_service

# 返回到用户的家目录
cd ~

print_section "Installation Complete"
print_success "Clash Meta has been successfully installed and configured"
print_info "You can now manage the service using: sudo service clash-meta {start|stop|restart|status}"
