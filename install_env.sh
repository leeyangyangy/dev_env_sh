#!/bin/bash

# 代理本机网络,使用脚本之前修改本机的代理地址,以免无法正常使用部分功能
# export http://localhost:2080
# export https://localhost:2080

# 启用错误检测，命令失败则退出脚本
set -e

# 定义一个数组，用于存储需要安装的软件包列表
packages=(
    "network-management" (
        net-tools curl wget htop aria2
    )
    "docker" (
        docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    )
    "c-toolchain" (
        ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
        bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
        gperf haveged help2man intltool libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev libgmp3-dev \
        libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libpython3-dev libreadline-dev \
        libssl-dev libtool lrzsz mkisofs msmtp ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 \
        python3-pyelftools python3-setuptools qemu-utils rsync scons squashfs-tools subversion swig texinfo \
        uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
    )
    "other-tools" (
        nano vim tree unzip bash-completion vlc ncdu
    )
    "version-control" (
        git
    )
    "zsh" (
        zsh
    )
    "communication-tools" (
        minicom openssh-server
    )
)

# 定义一个函数来安装软件包
install_packages() {
    local group_name=$1
    local pkgs=(${packages[$group_name]})
    echo "Installing ${group_name}..."
    sudo apt-get install -y "${pkgs[@]}"
}

# 定义一个函数来处理安装失败的情况
handle_failure() {
    echo "An error occurred. Exiting..."
    exit 1
}

# 设置trap，以便在发生错误时调用handle_failure函数
trap 'handle_failure' ERR

# 更新源
echo "Updating your system software source..."
sudo apt-get update

# 卸载旧版本的Docker并安装新版本
echo "Uninstalling old Docker versions..."
sudo apt-get remove docker docker-engine docker.io containerd runc
# ... 其他Docker安装步骤 ...

# 循环遍历packages数组，安装每个软件包组
for i in "${!packages[@]}"; do
    if ! install_packages $i; then
        echo "Failed to install ${i}. You can rerun the script to continue from here."
        exit 1
    fi
done

# 安装Zsh和Oh My Zsh
echo "Installing Zsh and Oh My Zsh..."
# sudo apt-get -y install zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "All packages installed successfully."

echo "please intput your git user.email and user.name"
git config --global user.email "1787294587@qq.com"
git config --global user.name "leeyangyangy"

# Initial build of OrangeFox && aosp requirements,from orangefox(Building OrangeFox | OrangeFox Recovery wiki) 
# 克隆OrangeFox misc/scripts仓库
echo "Cloning OrangeFox misc/scripts repository..."
git clone https://gitlab.com/OrangeFox/misc/scripts.git
if [ $? -ne 0 ]; then
    echo "Failed to clone the repository."
    exit 1
fi

# 进入scripts目录
cd scripts
if [ $? -ne 0 ]; then
    echo "Failed to enter the scripts directory."
    exit 1
fi

# 安装Android构建环境
echo "Installing build AOSP environment requirements..."
sudo bash setup/android_build_env.sh
if [ $? -ne 0 ]; then
    echo "Failed to setup android build environment."
    exit 1
fi

# 安装Android SDK
echo "Installing Android SDK..."
sudo bash setup/install_android_sdk.sh
if [ $? -ne 0 ]; then
    echo "Failed to install Android SDK."
    exit 1
fi

echo "All scripts executed successfully."

# 定义一个函数来检查上一个命令是否成功执行
check_error() {
    if [ $1 -ne 0 ]; then
        echo "Error occurred with $? at line $2."
        exit $1
    fi
}

# 创建android和OrangeFox_sync目录
echo "======== create my sync shell script ========"
mkdir -p ~/android ~/OrangeFox_sync
check_error $? ${LINENO}

# 克隆sync脚本
echo "======== clone sync shell scripts ========"
git clone https://gitlab.com/OrangeFox/sync.git
check_error $? ${LINENO}
cd ~/OrangeFox_sync/sync/
./orangefox_sync.sh --branch 12.1 --path ~/android/fox_12.1
check_error $? ${LINENO}

# 测试当前构建环境
echo "======== test current build env ========"
cd ~/android/fox_12.1
git clone https://gitlab.com/OrangeFox/device/lavender.git  device/xiaomi/lavender
check_error $? ${LINENO}

echo "All operations completed successfully."

source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export LC_ALL="C"

# for branches lower than 11.0
#  lunch omni_<device>-eng && mka recoveryimage

# for branches lower than 11.0, with A/B partitioning
#  lunch omni_<device>-eng && mka bootimage

# for the 11.0 (or higher) branch
#  lunch twrp_<device>-eng && mka adbd recoveryimage

# for the 11.0 (or higher) branch, with A/B partitioning
lunch twrp_lavender-eng && mka adbd bootimage

# 切换到用户的android目录
cd ~/android

# 创建LineageOS 20的目录并进入
mkdir -p los20 && cd los20

# 初始化repo
echo "Initializing LineageOS repository..."
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# 同步仓库
echo "Syncing repositories..."
repo sync -j12

# 检查上一个命令的退出状态
if [ $? -eq 0 ]; then
    echo "LineageOS repositories synchronized successfully."
else
    echo "Failed to synchronize repositories."
    exit 1
fi

# Pixel Experience

# Initialize local repository
# repo init -u https://github.com/PixelExperience/manifest -b thirteen

# Sync
# repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
# Build

# Set up environment
# $ . build/envsetup.sh

# Choose a target
# $ lunch aosp_$device-userdebug

# Build the code
# $ mka bacon -j16
