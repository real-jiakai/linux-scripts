#!/bin/bash

# 检查并安装 wget
if ! command -v wget &> /dev/null; then
    echo "wget could not be found, attempting to install..."
    if [[ $(command -v yum) ]]; then
        sudo yum install wget -y
    elif [[ $(command -v apt-get) ]]; then
        sudo apt-get install wget -y
    else
        echo "Neither yum nor apt-get is available. Cannot install wget automatically."
        exit 1
    fi
fi

# 提供选项给用户
echo "请选择你想要更新的geo数据源:"
echo "1、V2Ray 官方 geoip.dat 和 geosite.dat"
echo "2、L佬的V2Ray 路由规则文件加强版"
read -p "输入选择 (1 或 2): " choice

# 设置下载目录
DOWNLOAD_DIR="/usr/local/x-ui/bin"

# 初始化变量
GEOIP_URL=""
GEOSITE_URL=""

case $choice in
    1)
        GEOIP_URL="https://github.com/v2fly/geoip/releases/latest/download/geoip.dat"
        GEOSITE_URL="https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat"
        ;;
    2)
        GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
        GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
        ;;
    *)
        echo "无效输入，脚本退出."
        exit 1
        ;;
esac

# 下载文件
wget -N --no-check-certificate -q -O "${DOWNLOAD_DIR}/geoip.dat" "$GEOIP_URL"
wget -N --no-check-certificate -q -O "${DOWNLOAD_DIR}/geosite.dat" "$GEOSITE_URL"
echo "geoip、geosite数据更新完成"

# 定义crontab任务
cron_job="0 3 * * * wget -N --no-check-certificate -q -O ${DOWNLOAD_DIR}/geoip.dat ${GEOIP_URL}; wget -N --no-check-certificate -q -O ${DOWNLOAD_DIR}/geosite.dat ${GEOSITE_URL}"

# 清除所有旧的geo更新任务
(crontab -l | grep -v 'geoip.dat' | grep -v 'geosite.dat') | crontab -

# 添加新的crontab任务
(crontab -l 2>/dev/null; echo "$cron_job") | crontab -

echo "已更新crontab，设置为每天凌晨3点自动更新geo数据。"
