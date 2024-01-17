#!/bin/bash

# 检查docker是否安装，如果安装了，则输出信息，并运行项目
# 如果没有安装则先安装docker，安装完毕后，再运行项目
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker could not be found. Installing..."
        install_docker
        echo "Docker is already installed."
    else
        echo "Docker is already installed."
    fi
}

# 安装docker函数
install_docker() {
    curl https://get.docker.com | bash
}

# 检测系统使用的包管理器
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v yum &> /dev/null; then
        echo "yum"
    else
        echo "none"
    fi
}

# 检查curl是否安装，如果没有安装，则安装它
check_curl() {
    if ! command -v curl &> /dev/null; then
        echo "curl could not be found. Installing..."
        package_manager=$(detect_package_manager)

        case $package_manager in
            apt)
                sudo apt update
                sudo apt install -y curl
                ;;
            yum)
                sudo yum install -y curl
                ;;
            *)
                echo "No supported package manager found. Cannot install curl."
                return 1
                ;;
        esac
    else
        echo "curl is already installed."
    fi
}


# 运行出售流量项目
run_projects() {
    # traffmonetizer 项目
    if [ ! -d "$HOME/traffmonetizer" ]; then
        echo "Creating directory for traffmonetizer..."
        mkdir -p "$HOME/traffmonetizer"
    else
        echo "Directory for traffmonetizer already exists."
    fi
    cd "$HOME/traffmonetizer"
    if [ ! -f compose.yml ]; then
        echo "Downloading compose.yml for traffmonetizer..."
        curl -fsSL https://raw.githubusercontent.com/real-jiakai/docker-compose/main/traffmonetizer/compose.yml -o compose.yml
    else
        echo "compose.yml for traffmonetizer already exists."
    fi
    if [ $(docker ps -a -f name=tm -q) ]; then
        echo "Updating traffmonetizer project..."
        docker compose pull
        docker compose up -d
    else
        echo "Deploying traffmonetizer project..."
        docker compose up -d
    fi
    echo "traffmonetizer project has been deployed or updated."

    # repocket项目
    if [ ! -d "$HOME/repocket" ]; then
        echo "Creating directory for repocket..."
        mkdir -p "$HOME/repocket"
    else
        echo "Directory for repocket already exists."
    fi
    cd "$HOME/repocket"
    if [ ! -f compose.yml ] || [ ! -f rp.env ]; then
        echo "Downloading compose.yml and rp.env for repocket..."
        curl -fsSL https://raw.githubusercontent.com/real-jiakai/docker-compose/main/repocket/compose.yml -o compose.yml
        curl -fsSL https://raw.githubusercontent.com/real-jiakai/docker-compose/main/repocket/rp.env -o rp.env
    else
        echo "compose.yml and rp.env for repocket already exist."
    fi
    if [ $(docker ps -a -f name=repocket -q) ]; then
        echo "Updating repocket project..."
        docker compose pull
        docker compose up -d
    else
        echo "Deploying repocket project..."
        docker compose up -d
    fi
    echo "repocket project has been deployed or updated."

    # earnfm项目
    if [ ! -d "$HOME/earnfm" ]; then
        echo "Creating directory for earnfm..."
        mkdir -p "$HOME/earnfm"
    else
        echo "Directory for earnfm already exists."
    fi
    cd "$HOME/earnfm"
    if [ ! -f compose.yml ]; then
        echo "Downloading compose.yml for earnfm..."
        curl -fsSL https://raw.githubusercontent.com/real-jiakai/docker-compose/main/earnfm/compose.yml -o compose.yml
    else
        echo "compose.yml for earnfm already exists."
    fi
    if [ $(docker ps -a -f name=earnfm-client -q) ]; then
        echo "Updating earnfm project..."
        docker compose pull
        docker compose up -d
    else
        echo "Deploying earnfm project..."
        docker compose up -d
    fi
    echo "earnfm project has been deployed or updated."

    # packetstream项目
    if [ ! -d "$HOME/packetstream" ]; then
        echo "Creating directory for packetstream..."
        mkdir -p "$HOME/packetstream"
    else
        echo "Directory for packetstream already exists."
    fi
    cd "$HOME/packetstream"
    if [ ! -f compose.yml ]; then
        echo "Downloading compose.yml for packetstream..."
        curl -fsSL https://raw.githubusercontent.com/real-jiakai/docker-compose/main/packetstream/compose.yml -o compose.yml
    else
        echo "compose.yml for packetstream already exists."
    fi
    if [ $(docker ps -a -f name=psclient -q) ]; then
        echo "Updating packetstream project..."
        docker compose pull
        docker compose up -d
    else
        echo "Deploying packetstream project..."
        docker compose up -d
    fi
    echo "packetstream project has been deployed or updated."
}

# 检查docker安装情况
check_docker

# check_curl安装情况
check_curl

# 运行出售流量项目
run_projects

# 在所有项目部署完成后输出提示信息
echo "All traffic selling projects have been deployed successfully."
