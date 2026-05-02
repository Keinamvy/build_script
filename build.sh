#!/bin/bash

# 1. Cleanup and Initialization
rm -rf .repo/local_manifests
rm -rf device/xiaomi
rm -rf vendor/xiaomi
rm -rf kernel/xiaomi
rm -rf hardware/xiaomi

repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault

# 2. Local Manifests
git clone https://github.com/Keinamvy/local_manifests.git \
    -b infinityx .repo/local_manifests

# 3. Sync Source
/opt/crave/resync.sh
git -C kernel/xiaomi/sm6150 submodule update --init --recursive

# 4. Build Environment and Compilation
export BUILD_USERNAME=Keinamvy
export BUILD_HOSTNAME=crave
source build/envsetup.sh
lunch infinity_sweet2-userdebug
m bacon
