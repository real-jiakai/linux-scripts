#!/bin/bash

# Check if subscription link is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <subscription_link>"
    exit 1
fi

SUBSCRIPTION_LINK="$1"

# Install git and wget
apt install git wget -y

# Create the clash directory and enter it
mkdir -p clash && cd clash

# Download mihomo and Country.mmdb
wget https://gh-hk.gujiakai.top/https://github.com/MetaCubeX/mihomo/releases/download/v1.17.0/mihomo-linux-amd64-v1.17.0.gz
gunzip mihomo-linux-amd64-v1.17.0.gz
mv mihomo-linux-amd64-v1.17.0 clash-meta

wget https://gh-hk.gujiakai.top/https://github.com/Dreamacro/maxmind-geoip/releases/download/20231012/Country.mmdb

# Clone the UI repository
git clone -b gh-pages https://github.com/kogekiplay/Yacd-meta ui

# Download clash subscription link using the provided argument
wget "$SUBSCRIPTION_LINK" -O config.yaml

# Create and write the init.d script
cat << 'EOF' > /etc/init.d/clash-meta
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
    kill \$(pgrep -f \$CLASH_META)
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
    *)
        echo "Usage: /etc/init.d/clash-meta {start|stop|restart}"
        exit 1
esac

exit 0
EOF

# Set execute permissions and register as a service
chmod +x /etc/init.d/clash-meta
update-rc.d clash-meta defaults

# Navigate back to the home directory
cd ~

echo "Clash installation and configuration is complete."
