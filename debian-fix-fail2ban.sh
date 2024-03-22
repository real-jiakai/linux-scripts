#!/bin/bash

# 检查 fail2ban 是否安装
if ! command -v fail2ban-client &> /dev/null; then
    echo "fail2ban 未安装，开始安装..."

    # 检测系统并选择安装工具
    if [[ -e /etc/debian_version ]]; then
        sudo apt-get update
        sudo apt-get install fail2ban -y
    elif [[ -e /etc/redhat-release ]]; then
        sudo yum update
        sudo yum install fail2ban -y
    else
        echo "不支持的 Linux 发行版"
        exit 1
    fi
fi

# 检查 fail2ban 状态
if ! sudo systemctl is-active --quiet fail2ban; then
    echo "fail2ban 服务未运行，尝试配置并启动..."

    # 修改 fail2ban 配置
    echo -e "[sshd]\nbackend=systemd\nenabled=true" | sudo tee /etc/fail2ban/jail.local

    # 启动 fail2ban 并设置为开机启动
    sudo systemctl enable --now fail2ban
fi

# 再次检查 fail2ban 状态
if sudo systemctl is-active --quiet fail2ban; then
    echo "fail2ban 配置成功，服务正在运行。"
else
    echo "fail2ban 启动失败，请检查配置。"
fi
