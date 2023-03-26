#!/bin/bash

# 更新源
echo "first update your system soft source"
sudo apt-get update
# 添加公钥
echo "add some apt-key...please wait a minute..."
# typora : https://typora.io/#linux
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
# add Typora's repository
sudo add-apt-repository 'deb https://typora.io/linux ./'
wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/v2raya.asc
# 添加 V2RayA 软件源
echo "deb https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
# 更新源
echo "apt-key add finished , will update soft source"
sudo apt-get update
# 网络管理 || 运维工作
# ifconfig
echo "now install network manage tools...please wait a minute..."
sudo apt-get install -y net-tools curl wget terminator unzip htop

echo "uninstall docker..."
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install -y ca-certificates gnupg
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
echo "To install docker the latest version"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# test docker install success
# sudo docker run hello-world

echo "now install c/c++ toolchain...please wait a minute..."
# 安装编译工具链
sudo apt install -y gcc g++ 

# 安装其它工具类
echo "now install other tools...please wait a minute..."
sudoo apt install -y nano vim tree unzip bash-completion vlc ncdu

# server不安装 Kazam 是一个很轻量级的屏幕录制工具，也可以用来截图
# echo "now screen record tool...please wait a minute..."
# sudo apt-get install -y kazam

# 版本控制工具
echo "now install version control tools...please wait a minute..."
sudo apt install -y git meld dos2unix

# zsh #server不安装
# echo "now install zsh && oh-my-zsh...please wait a minute..."
sudo apt-get -y install zsh
# oh-my-zsh
# sudo apt install curl # 先安装 curl
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 通信工具 #
# minicom - 调试嵌入式系统必备工具
sudo apt-get -y install minicom
sudo apt-get -y install ssh

# 写作工具 #
# typora : https://typora.io/#linux
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
# wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
# add Typora's repository
# sudo add-apt-repository 'deb https://typora.io/linux ./'
# sudo apt-get update
# install typora
echo "now install typora...please wait a minute..."
sudo apt-get install typora

# 输入法工具 #server不安装
# 注意: Ubuntu 在安装中文语系系统自带有一个智能拼音且输入法系统为iBus，如果安装google或者百度输入法则需要安装切换为fcitx
#sudo apt install -y fcitx
# 搜狗 : https://pinyin.sogou.com/linux/?r=pinyin
# 百度 ：https://srf.baidu.com/site/guanwang_linux/index.html
#sudo apt  install fcitx-bin fcitx-table fcitx-config-gtk fcitx-config-gtk2 fcitx-frontend-all
#sudo apt install qt5-default qtcreator qml-module-qtquick-controls2
#sudo dpkg -i fcitx-baidupinyin.deb                # 安装百度输入法
#sudo dpkg --purge remove fcitx-baidupinyin:amd64  # 卸载

# 梯子 server不安装
# V2Ray 内核
# v2rayA 提供的镜像脚本
echo "now install v2...please wait a minute..."
curl -Ls https://mirrors.v2raya.org/go.sh | sudo bash
# 安装后可以关掉服务，因为 v2rayA 不依赖于该 systemd 服务
sudo systemctl disable v2ray --now
# 安装 v2rayA
# 添加公钥
# wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/v2raya.asc
# 添加 V2RayA 软件源
# echo "deb https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
# sudo apt update
# 安装 V2RayA
sudo apt install v2raya
# 启动 v2rayA
sudo systemctl start v2raya.service
# 设置开机自动启动
sudo systemctl enable v2raya.service

# 娱乐工具 #server不安装
# 网易云 : https://music.163.com/#/download
# sudo dpkg -i netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb
# 腾讯QQ (Linux) : https://im.qq.com/linuxqq/download.html
# wget http://down.qq.com/qqweb/LinuxQQ/linuxqq_2.0.0-b2-1084_amd64.deb
# sudo dpkg -i linuxqq_2.0.0-b2-1084_amd64.deb
# sudo dpkg -r linuxqq  #卸载QQ

echo "now,basic env already,if you found fail,please yourself install fail soft...thank you use my shell..."
