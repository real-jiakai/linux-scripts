#!/bin/bash

# 更新软件包列表 && 更新所有软件
apt update && apt upgrade -y

# 将新的默认队列调度算法设置为 "fq"
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
# 将新的TCP拥塞控制算法设置为 "bbr"
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
# 立即应用新的系统控制参数
sysctl -p

