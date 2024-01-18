# Introduction

整理一些自用的linux一键脚本。

# Usage

1、创建1GB的swap交换分区：`curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/create_swap.sh | bash`

2、debian系的linux发行版安装caddy：`curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/debian-install-caddy.sh | bash`

3、一键安装git lfs：`curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/git-lfs-oneclick.sh | bash`

4、rocky linux安装docker：`curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/rocky-linux-install-docker-engine.sh | bash`

5、半自动脚本，在autodl上安装clash-meta：

`curl -s https://gh-hk.gujiakai.top/https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/autodl-install-clash-meta.sh | bash -s -- 你的订阅链接url`

安装完毕后，在config.yaml的头部保证存在以下字段：

```
allow-lan: true
external-controller: :9090
external-ui: /root/clash/ui
secret: 你设置的ui界面的密码
```

在autodl平台的jupyterlab的终端中启动clash-meta服务

```bash
# service clash-meta start/stop/restart/status
service clash-meta start
```

在autodl平台的jupyterlab的终端中输入以下内容来设置代理环境。

```bash
export http_proxy="http://localhost:7890"
export https_proxy="http://localhost:7890"
```

接着在本机电脑的终端中输入类似以下的命令，进行端口转发。

```bash
# 使用 SSH 创建端口转发
# -L 9092:127.0.0.1:9090: 将本地端口 9092 转发到远程服务器的 9090 端口
# root@region-9.autodl.pro: SSH 登录的远程服务器地址
# -p 16030: 使用 16030 端口进行 SSH 连接
ssh -L 9092:127.0.0.1:9090 root@region-9.autodl.pro -p 16030
```

在浏览器地址中访问`http://127.0.0.1:9092/ui`，填写地址为`http://127.0.0.1:9092`，secret的值为一开始在config.yaml头部字段中的secret值。
进入yacd面板中，选择一个能用的代理节点。

回到autodl的jupyterlab终端处，在命令行中输入以下内容测试代理情况。

```bash
curl ipinfo.io/json
```

如果出现ip归属地为代理节点所在的国家或地区，则表明代理在autodl平台生效。

6、国内vps半自动脚本安装clash-meta：

`curl https://gh-hk.gujiakai.top/https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/domestic-vps-install-clash-meta.sh | bash -s -- 订阅链接url`

7、debian系机器开机基本操作：`curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/debian-startup.sh | bash`

8、出售流量项目一键部署：`curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/sell-my-traffic.sh | bash`

包含的四个出售流量项目分别为：

- traffmonetizer
- repocket
- earnfm
- packetstream

如果需要使用，请将脚本中的对应参数更改为你的账户信息。
