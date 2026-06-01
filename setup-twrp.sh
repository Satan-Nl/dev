#!/bin/bash
# Setup script for TWRP Merlin builds
# This script prepares the environment after cloning the TWRP source

set -e

DEVICE="merlin"
TWRP_BRANCH="${1:-twrp-11.0}"

echo "=========================================="
echo "TWRP Setup for Xiaomi $DEVICE (MT6768)"
echo "=========================================="
echo ""

# Check if repo exists
if [ ! -d ".repo" ]; then
    echo "Error: Not in TWRP root directory or repo not initialized"
    echo "Please run:"
    echo "  repo init -u https://github.com/minimal-manifest-twrp/android_manifest_twrp.git -b $TWRP_BRANCH"
    exit 1
fi

echo "[1/4] Syncing repository..."
repo sync --force-sync -j4

echo "[2/4] Cloning device tree..."
if [ ! -d "device/xiaomi/$DEVICE" ]; then
    git clone https://github.com/minimal-manifest-twrp/android_device_xiaomi_${DEVICE}.git \
        device/xiaomi/$DEVICE
    echo "✓ Device tree cloned"
else
    echo "✓ Device tree already exists"
fi

echo "[3/4] Cloning MediaTek common tree..."
if [ ! -d "device/mediatek/common" ]; then
    git clone https://github.com/minimal-manifest-twrp/android_device_mediatek_common.git \
        device/mediatek/common 2>/dev/null || true
fi

echo "[4/4] Setting up environment..."
source build/envsetup.sh

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "To build TWRP for $DEVICE:"
echo "  lunch twrp_${DEVICE}-user"
echo "  mka recovery -j\$(nproc)"
echo ""
echo "Or use the build script:"
echo "  ./build-twrp-merlin.sh"
echo ""
