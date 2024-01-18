#!/bin/bash

# 检查订阅链接是否提供
check_subscription_link() {
    if [ -z "$1" ]; then
        echo "Error: No subscription link provided."
        echo "Usage: $0 <subscription_link_url>"
        exit 1
    fi
    SUBSCRIPTION_LINK="$1"
}

# 安装clash-meta
install_clash_meta() {
    # Check if git and wget are installed, install them if they are not
    if ! command -v git &> /dev/null; then
        echo "Installing git..."
        apt install git -y
    fi

    if ! command -v wget &> /dev/null; then
        echo "Installing wget..."
        apt install wget -y
    fi

    # Create the clash directory and enter it
    echo "Creating clash directory..."
    mkdir -p clash && cd clash

    # Download clash-meta and Country.mmdb
    echo "Downloading clash-meta and Country.mmdb..."
    wget https://gh-hk.gujiakai.top/https://github.com/MetaCubeX/mihomo/releases/download/v1.17.0/mihomo-linux-amd64-v1.17.0.gz
    gunzip mihomo-linux-amd64-v1.17.0.gz
    mv mihomo-linux-amd64-v1.17.0 clash-meta
    chmod +x clash-meta

    wget https://gh-hk.gujiakai.top/https://github.com/Dreamacro/maxmind-geoip/releases/download/20231012/Country.mmdb

    # Clone the UI repository
    echo "Cloning the UI repository..."
    git clone -b gh-pages https://gh-hk.gujiakai.top/https://github.com/kogekiplay/Yacd-meta ui

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
