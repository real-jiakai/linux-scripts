#!/bin/bash

# 检测并安装wget
if ! command -v wget &> /dev/null; then
    echo "wget could not be found, attempting to install..."
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install wget -y || { echo "Failed to install wget with apt"; exit 1; }
    elif command -v yum &> /dev/null; then
        sudo yum update && sudo yum install wget -y || { echo "Failed to install wget with yum"; exit 1; }
    else
        echo "Neither apt nor yum is available to install wget. Exiting..."
        exit 1
    fi
fi

# 检测并安装docker
if ! command -v docker &> /dev/null; then
    echo "Docker could not be found, attempting to install..."
    curl https://get.docker.com | bash || { echo "Failed to install Docker."; exit 1; }
fi

# 返回用户目录并创建watchtower文件夹
cd ~
mkdir -p watchtower && cd watchtower

# 下载compose.yml文件
wget https://raw.githubusercontent.com/real-jiakai/docker-compose/main/watchtower/compose.yml || { echo "Failed to download compose.yml"; exit 1; }

# 执行docker compose up -d
docker compose up -d || { echo "Failed to run docker compose up -d"; exit 1; }

echo "Watchtower has been successfully deployed!"
