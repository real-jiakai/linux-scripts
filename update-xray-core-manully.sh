#!/bin/bash

# 定义目标目录
TARGET_DIR="/usr/local/x-ui/bin"
XRAY_ZIP="${TARGET_DIR}/Xray-linux-64.zip"

# 确保目标目录存在
mkdir -p $TARGET_DIR

# 获取最新的Xray-core发布的ZIP文件URL
XRAY_LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep browser_download_url | grep 'Xray-linux-64.zip' | cut -d '"' -f 4)

if [ -z "$XRAY_LATEST_RELEASE_URL" ]; then
  echo "无法获取Xray最新版本的下载链接。"
  exit 1
fi

# 下载最新版本的Xray-core
echo "下载Xray最新版本..."
curl -L $XRAY_LATEST_RELEASE_URL -o $XRAY_ZIP

# 解压ZIP文件
echo "解压Xray..."
unzip -o $XRAY_ZIP -d $TARGET_DIR

# 重命名文件
echo "更新文件..."
mv -f ${TARGET_DIR}/xray ${TARGET_DIR}/xray-linux-amd64

# 清理ZIP文件
rm $XRAY_ZIP

echo "Xray-core更新完成。"
