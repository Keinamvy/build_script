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

# 4. Apply Patches
PATCH_DIR="device/xiaomi/sweet2/patches"

if [ -d "$PATCH_DIR" ]; then
    echo "Applying patches from $PATCH_DIR..."
    patch -p1 -d build/soong < "$PATCH_DIR"/000*.patch
    patch -p1 -d frameworks/base < "$PATCH_DIR"/001*.patch
    patch -p1 -d packages/apps/InfinitySuite < "$PATCH_DIR"/002*.patch
    patch -p1 -d vendor/extras < "$PATCH_DIR"/003*.patch
else
    echo "Patch directory not found: $PATCH_DIR"
    exit 1
fi

# 5. Build Environment and Compilation
export BUILD_USERNAME=Keinamvy
export BUILD_HOSTNAME=crave
source build/envsetup.sh
lunch infinity_sweet2-userdebug
m bacon
