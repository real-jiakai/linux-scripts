#!/bin/bash

# 更新软件包列表 && 更新所有软件
apt update && apt upgrade -y

# 将新的默认队列调度算法设置为 "fq"
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
# 将新的TCP拥塞控制算法设置为 "bbr"
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
# 立即应用新的系统控制参数
sysctl -p

# 屏蔽25端口的输入和输出（针对SMTP服务）
#!/bin/bash

# 更新软件包列表 && 更新所有软件
apt update && apt upgrade -y

# 将新的默认队列调度算法设置为 "fq"
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
# 将新的TCP拥塞控制算法设置为 "bbr"
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
# 立即应用新的系统控制参数
sysctl -p

# 检查iptables是否存在
if command -v iptables >/dev/null 2>&1; then
    # 屏蔽25端口的输入和输出（针对SMTP服务）
    iptables -A INPUT -p tcp --dport 25 -j DROP
    iptables -A OUTPUT -p tcp --dport 25 -j DROP
else
    # 检查nft是否存在
    if command -v nft >/dev/null 2>&1; then
        # 使用nftables屏蔽25端口的输入和输出（针对SMTP服务）
        # 检查是否存在nftables配置，如果不存在，则初始化
        nft list tables | grep -q inet || nft add table inet filter

        # 检查是否存在chain，如果不存在，则创建
        nft list chains | grep -q 'input\|output' || {
            nft add chain inet filter input { type filter hook input priority 0 \; }
            nft add chain inet filter output { type filter hook output priority 0 \; }
        }

        # 屏蔽25端口的输入和输出
        nft add rule inet filter input tcp dport 25 drop
        nft add rule inet filter output tcp dport 25 drop
    else
        echo "Neither iptables nor nft is available on this system."
    fi
fi
