#!/bin/bash

# 创建目录
mkdir -p /root/.local/bin

# 下载yt-dlp
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /root/.local/bin/yt-dlp

# 设置执行权限
chmod a+rx /root/.local/bin/yt-dlp

# 将yt-dlp的安装路径添加到PATH环境变量
echo "export PATH=\$PATH:/root/.local/bin" >> ~/.bashrc

# 重新加载.bashrc以应用环境变量更改
source ~/.bashrc

# 检查yt-dlp是否安装成功
yt_dlp_version=$(yt-dlp --version)
if [ -n "$yt_dlp_version" ]; then
    echo "yt-dlp installation successful, version: $yt_dlp_version"
else
    echo "yt-dlp installation failed."
fi
