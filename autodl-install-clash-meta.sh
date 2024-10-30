#!/bin/bash

# 检查订阅链接是否提供
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

# 安装clash-meta
install_clash_meta() {
    # 1. 优先更新软件包并安装 jq
    apt update && apt install jq -y

    # 2. 检查其他必需工具
    for tool in git wget; do
        if ! command -v $tool &> /dev/null; then
            echo "Installing $tool..."
            apt install $tool -y
        fi
    done

    # Create the clash directory and enter it
    echo "Creating clash directory..."
    mkdir -p clash && cd clash

    # Get the latest release information using the mirror API
    echo "Fetching latest Clash Meta release information..."
    LATEST_RELEASE=$(wget -qO- https://gh-api.gujiakai.top/repos/MetaCubeX/mihomo/releases/latest)
    VERSION=$(echo $LATEST_RELEASE | jq -r .tag_name)
    DOWNLOAD_URL=$(echo $LATEST_RELEASE | jq -r '.assets[] | select(.name | contains("linux-amd64")) | .browser_download_url')

    # Replace the GitHub domain in the download URL with the mirror domain
    DOWNLOAD_URL=$(echo $DOWNLOAD_URL | sed 's#https://github.com/#https://gh-hk.gujiakai.top/https://github.com/#')

    # Download and prepare clash-meta
    echo "Downloading Clash Meta version $VERSION..."
    wget -O clash-meta.gz "$DOWNLOAD_URL"
    gunzip clash-meta.gz
    chmod +x clash-meta

    # Download Country.mmdb (using mirror)
    echo "Downloading Country.mmdb..."
    wget https://gh-hk.gujiakai.top/https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb

    # Clone the UI repository (using mirror)
    echo "Cloning the UI repository..."
    git clone -b gh-pages https://gh-hk.gujiakai.top/https://github.com/MetaCubeX/Yacd-meta ui

    # Download clash subscription link using the provided argument
    echo "Downloading clash subscription..."
    wget "$SUBSCRIPTION_LINK" -O config.yaml
    echo "Clash Meta installation complete."
}

# 创建clash-meta系统服务
create_and_register_clash_meta_service() {
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
}

stop() {
    echo "Stopping clash-meta..."
    PIDS=\$(pidof -x clash-meta)
    if [ -z "\$PIDS" ]; then
        echo "No clash-meta process found."
    else
        kill \$PIDS
    fi
}

status() {
    PIDS=\$(pidof -x clash-meta)
    if [ -z "\$PIDS" ]; then
        echo "clash-meta is not running."
    else
        echo "clash-meta is running. PIDs: \$PIDS"
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
    echo "Clash-meta service has been created and registered."
}

# 主流程
# 检查传递的订阅链接
check_subscription_link "$1"

# 安装clash-meta
install_clash_meta

# 创建并注册clash-meta服务
create_and_register_clash_meta_service

# 返回到用户的家目录
cd ~
echo "Clash installation and configuration is complete."
