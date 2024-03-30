#!/bin/bash

# 停止并移除packetstream容器
if docker ps -a | grep -q packetstream; then
    echo "Stopping and removing packetstream containers..."
    docker ps -a | grep packetstream | awk '{print $1}' | xargs docker stop | xargs docker rm
else
    echo "No packetstream containers found."
fi

# 移除packetstream镜像
if docker images | grep -q packetstream; then
    echo "Removing packetstream images..."
    docker images | grep packetstream | awk '{print $3}' | xargs docker rmi
else
    echo "No packetstream images found."
fi

# 删除packetstream相关的文件夹
if [ -d "$HOME/packetstream" ]; then
    echo "Removing packetstream directory..."
    rm -rf "$HOME/packetstream"
else
    echo "packetstream directory does not exist."
fi

echo "packetstream removal completed."
