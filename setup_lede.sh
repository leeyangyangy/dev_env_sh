#!/bin/bash

# 切换到主目录
cd ~

# 克隆 Lean 的 LEDE 源码仓库
echo "Cloning Lean's LEDE repository..."
git clone https://github.com/coolsnowwolf/lede
if [ $? -ne 0 ]; then
    echo "Failed to clone the repository."
    exit 1
fi

# 进入lede目录
cd lede

# 更新所有feeds
echo "Updating feeds..."
./scripts/feeds update -a

# 安装所有可用的包
echo "Installing all feeds..."
./scripts/feeds install -a

# 启动配置界面
echo "Starting configuration..."
make menuconfig

echo "LEDE setup is complete. Please configure your build as needed."
