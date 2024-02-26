#!/bin/bash

# 转到/usr/local/x-ui目录
cd /usr/local/x-ui

# 下载Xray-core的ZIP文件
curl -O https://gh-hk.gujiakai.top/https://github.com/XTLS/Xray-core/releases/download/v1.8.8/Xray-linux-64.zip

# 解压ZIP文件
unzip -o Xray-linux-64.zip

# 将xray文件重命名为xray-linux-amd64
mv xray xray-linux-amd64

# 将xray-linux-amd64、geoip.dat和geosite.dat文件移动到/usr/local/x-ui/bin目录中
mv -f xray-linux-amd64 geoip.dat geosite.dat /usr/local/x-ui/bin/

# 删除ZIP文件以节省空间
rm Xray-linux-64.zip

echo "Xray-core更新完成。"
