#!/bin/bash

# 定义 Vim 的安装路径
INSTALL_PATH="$HOME/.local"

# 定义 Vim 的版本号
VIM_VERSION="v9.1.0407"

# 第一步：下载源码并解压
echo "Downloading Vim source code..."
wget https://github.com/vim/vim/releases/tag/$VIM_VERSION -O $VIM_VERSION.tar.gz
tar -xzf $VIM_VERSION.tar.gz
cd $VIM_VERSION

# 检查下载和解压是否成功
if [ $? -ne 0 ]; then
    echo "Failed to download or extract Vim source code."
    exit 1
fi

# 第二步：编译源码
echo "Compiling Vim source code..."
./configure --prefix=$INSTALL_PATH --enable-python3interp=yes
make
make install

# 检查编译和安装是否成功
if [ $? -ne 0 ]; then
    echo "Failed to compile or install Vim."
    exit 1
fi

# 第三步：链接
echo "Setting up Vim alias..."
# alias vim="$INSTALL_PATH/bin/vim"
# echo "alias vim='$INSTALL_PATH/bin/vim'" >> ~/.bashrc

alias vim='~/.local/bin/vim'
echo "alias vim='~/.local/bin/vim'" >> ~/.bashrc

# 第四步：检查 Vim 版本
echo "Checking Vim version..."
vim --version

# 输出完成信息
echo "Vim has been successfully installed and upgraded."

# 退出脚本
exit 0
