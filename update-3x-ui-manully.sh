#!/bin/bash

# 手动更新3x-ui
ARCH=$(uname -m)
case "${ARCH}" in
  x86_64 | x64 | amd64) XUI_ARCH="amd64" ;;
  i*86 | x86) XUI_ARCH="386" ;;
  armv8* | armv8 | arm64 | aarch64) XUI_ARCH="arm64" ;;
  armv7* | armv7) XUI_ARCH="armv7" ;;
  armv6* | armv6) XUI_ARCH="armv6" ;;
  armv5* | armv5) XUI_ARCH="armv5" ;;
  *) XUI_ARCH="amd64" ;;
esac


wget https://gh.gujiakai.top/https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-${XUI_ARCH}.tar.gz

ARCH=$(uname -m)
case "${ARCH}" in
  x86_64 | x64 | amd64) XUI_ARCH="amd64" ;;
  i*86 | x86) XUI_ARCH="386" ;;
  armv8* | armv8 | arm64 | aarch64) XUI_ARCH="arm64" ;;
  armv7* | armv7) XUI_ARCH="armv7" ;;
  armv6* | armv6) XUI_ARCH="armv6" ;;
  armv5* | armv5) XUI_ARCH="armv5" ;;
  *) XUI_ARCH="amd64" ;;
esac

cd /root/
rm -rf x-ui/ /usr/local/x-ui/ /usr/bin/x-ui
tar zxvf x-ui-linux-${XUI_ARCH}.tar.gz
chmod +x x-ui/x-ui x-ui/bin/xray-linux-* x-ui/x-ui.sh
cp x-ui/x-ui.sh /usr/bin/x-ui
cp -f x-ui/x-ui.service /etc/systemd/system/
mv x-ui/ /usr/local/
systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui
rm -rf x-ui-linux-amd64.tar.gz

# 手动更新xray内核
# 定义目标目录
TARGET_DIR="/usr/local/x-ui/bin"
XRAY_ZIP="Xray-linux-64.zip"

# 获取最新的Xray-core发布的ZIP文件URL
XRAY_LATEST_RELEASE_URL=$(curl -s https://gh-api.gujiakai.top/repos/XTLS/Xray-core/releases/latest | grep browser_download_url | grep 'Xray-linux-64.zip' | cut -d '"' -f 4)

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
