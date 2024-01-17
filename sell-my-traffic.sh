#!/bin/bash

# 检查docker是否安装，如果安装了，则输出信息，并运行项目
# 如果没有安装则先安装docker，安装完毕后，再运行项目
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker could not be found. Installing..."
        install_docker
        echo "Docker is already installed."
        run_projects
    else
        echo "Docker is already installed."
        run_projects
    fi
}

# 安装docker函数
install_docker() {
    curl https://get.docker.com | bash
}

# Function to run traffmonetizer and repocket projects
run_projects() {
    # traffmonetizer project
    docker pull traffmonetizer/cli_v2:latest
    docker run -d --name tm traffmonetizer/cli_v2 start accept --token aIMhNjq+DjIPZdOYCZ/Jjrt2US1uD/uvQhQjEeom0Ig=

    # repocket project
    docker pull repocket/repocket:latest
    echo "RP_EMAIL=gujiakai28@gmail.com" > rp.env
    echo "RP_API_KEY=45b050b1-edba-4a77-b35b-ec1a88c5d9a3" >> rp.env
    docker run --env-file rp.env -d --restart=always repocket/repocket
}

# Start the script by checking for Docker
check_docker
