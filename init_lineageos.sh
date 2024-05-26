#!/bin/bash

# 切换到用户的android目录
cd ~/android

# 创建LineageOS 20的目录并进入
# mkdir -p los20 && cd los20
while [ ! -d "los20" ]; do
    mkdir -p los20
done
cd los20

# 初始化repo
echo "Initializing LineageOS repository..."
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# 同步仓库
echo "Syncing repositories..."
repo sync -j4

# 检查上一个命令的退出状态
if [ $? -eq 0 ]; then
    echo "LineageOS repositories synchronized successfully."
else
    echo "Failed to synchronize repositories."
    exit 1
fi
