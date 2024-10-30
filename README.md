# Introduction

整理一些自用的 Linux 一键脚本。

# Usage

以下是一些常用的 Linux 脚本及其说明：

| 功能描述                                         | 命令                                                                                                                   |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| 创建 1GB 的 swap 交换分区                         | `curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/create_swap.sh \| bash`                    |
| Debian 系的 Linux 发行版安装 Caddy               | `curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/debian-install-caddy.sh \| bash`           |
| 一键安装 Git LFS                                 | `curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/git-lfs-oneclick.sh \| bash`               |
| Rocky Linux 安装 Docker                          | `curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/rocky-linux-install-docker-engine.sh \| bash` |
| 在 autodl 上安装 clash-meta                      | `curl -s https://gh-hk.gujiakai.top/https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/autodl-install-clash-meta.sh \| bash -s -- 你的订阅链接url` |
| 国内 VPS 半自动脚本安装 clash-meta               | `curl https://gh-hk.gujiakai.top/https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/domestic-vps-install-clash-meta.sh \| bash -s -- 订阅链接url` |
| Debian 系机器开机基本操作                         | `curl -fsSL https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/debian-startup.sh \| bash`                |
| 出售流量项目一键部署                              | `curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/sell-my-traffic.sh \| bash`                     |
| 国内机器更新 3x-ui 以及 xray 内核                 | `curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/update-3x-ui-manully.sh \| bash`                |
| Debian 系列的发行版使用 fail2ban                  | `curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/debian-fix-fail2ban.sh \| bash`                 |
| VPS 一键安装 watchtower                          | `curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/install-watchtower.sh \| bash`                   |
| 移除出售流量脚本中的 packetstream 支持            | `curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/remove-packetstream.sh \| bash`                  |
| xui 面板更新 geo 数据并将更新操作添加到定时任务   | `curl -O https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/xui-update-geodata.sh && chmod +x xui-update-geodata.sh && ./xui-update-geodata.sh` |
| 一键安装 yt-dlp                                  | `curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/install_yt_dlp.sh \| sh`                        |

请根据自己的需求选择相应的脚本执行。

## Additional Information 

1、半自动脚本，在autodl上安装clash-meta【注：国内服务器基本上可以用v2rayA项目来科学上网】补充说明：

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

2、国内vps半自动脚本安装clash-meta【注：国内服务器基本上可以用v2rayA项目来科学上网】补充说明：

`curl https://gh-hk.gujiakai.top/https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/domestic-vps-install-clash-meta.sh | bash -s -- 订阅链接url`

执行完毕后，在`/opt/clash`目录下的config.json文件头部保证以下字段：

```yaml
allow-lan: true
external-controller: :9090
external-ui: /root/clash/ui
secret: 你设置的ui界面的密码
```

接着重启clash-meta。

```bash
# 启动
systemctl start clash-meta 
# 重启clash-meta
systemctl restart clash-meta
# 暂停clash-meta
systemctl stop clash-meta
# 查看clash-meta状态
systemctl status clash-meta
```

放行服务器的9090端口后，在浏览器的地址栏输入`http://服务器ip地址:9090/ui`，填写地址为`http://服务器ip地址:9090`，secret的值为一开始在config.yaml头部字段中的secret值。 
进入yacd面板中，选择一个能用的代理节点。

在服务器终端中输入以下内容来设置代理环境。

```
export http_proxy="http://localhost:7890"
export https_proxy="http://localhost:7890"
```

在命令行中输入以下内容测试代理情况。

```
curl ipinfo.io/json
```

如果出现ip归属地为代理节点所在的国家或地区，则表明代理在linux终端生效。

3、出售流量项目一键部署补充说明：`curl https://raw.githubusercontent.com/real-jiakai/linux-scripts/main/sell-my-traffic.sh | bash`

包含的三个出售流量项目分别为：

- traffmonetizer
- repocket
- earnfm

如果需要使用，请将脚本中的对应参数更改为你的账户信息。

