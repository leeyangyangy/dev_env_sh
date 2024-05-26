#!/bin/bash

# 启用错误检测，命令失败则退出脚本
set -e

# 定义一个数组，用于存储需要安装的软件包列表
packages=(
    "network-management" (
        net-tools curl wget terminator htop aria2
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
# Initial build of OrangeFox && aosp requirements,from orangefox(Building OrangeFox | OrangeFox Recovery wiki) 
git config --global user.email "1787294587@qq.com"
git config --global user.name "leeyangyangy"
echo "clone orangefox scripts..."
git clone https://gitlab.com/OrangeFox/misc/scripts
cd scripts
echo "install build aosp env requirements"
sudo bash setup/android_build_env.sh
sudo bash setup/install_android_sdk.sh
echo "now,basic env already,if you found fail,please yourself install fail soft...thank you use my shell..."
# echo "git clone https://gitlab.com/OrangeFox/misc/scripts" >> aosp.sh
# echo "cd scripts"
# echo "sudo bash setup/android_build_env.sh" >> aosp.sh
# echo "sudo bash setup/install_android_sdk.sh" >> aosp.sh

echo "======== create my sync shell script ========"
echo "create android dir"
mkdir ~/android
mkdir sync_11_rec.sh
mkdir sync_12.1_rec.sh
echo "~/OrangeFox_sync/orangefox_sync.sh --branch 11.0 --path ~/android/fox_11.0" >> sync_11_rec.sh
echo "~/OrangeFox_sync/orangefox_sync.sh --branch 12.1 --path ~/android/fox_12.1" >> sync_12.1_rec.sh
sudo chmod a+x sync_11_rec.sh
sudo chmod a+x sync_12.1_rec.sh
mkdir ~/OrangeFox_sync && cd ~/OrangeFox_sync
echo "======== clone sync shell scripts ========"
git clone https://gitlab.com/OrangeFox/sync.git
# ./sync_12.1_rec.sh
# sync success after...https://wiki.orangefox.tech/en/dev/building
# cd ~/OrangeFox # (or whichever directory has the synced manifest)
#  source build/envsetup.sh
#  export ALLOW_MISSING_DEPENDENCIES=true
#  export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
#  export LC_ALL="C"

# for branches lower than 11.0
#  lunch omni_<device>-eng && mka recoveryimage

# for branches lower than 11.0, with A/B partitioning
#  lunch omni_<device>-eng && mka bootimage

# for the 11.0 (or higher) branch
#  lunch twrp_<device>-eng && mka adbd recoveryimage

# for the 11.0 (or higher) branch, with A/B partitioning
#  lunch twrp_<device>-eng && mka adbd bootimage
# LineageOS source
# repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
# repo sync

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
