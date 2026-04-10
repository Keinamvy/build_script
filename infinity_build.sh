#!/bin/bash

# 1. Cleanup and Initialization
rm -rf .repo/local_manifests/

repo init --depth=1 --no-repo-verify --git-lfs \
    -u https://github.com/ProjectInfinity-X/manifest \
    -b 16 \
    -g default,-mips,-darwin,-notdefault

# 2. Local Manifests
git clone https://github.com/Keinamvy/local_manifests.git \
    -b infinityx .repo/local_manifests

# 3. Sync Source
/opt/crave/resync.sh
repo forall Keinamvy/kernel_xiaomi_sm6150 -c "git submodule update --init --recursive"

# 4. Build Environment and Compilation
export BUILD_USERNAME=Keinamvy
export BUILD_HOSTNAME=crave
source build/envsetup.sh
lunch infinity_sweet2-userdebug
m bacon
