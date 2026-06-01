#!/bin/bash
set -e

DEVICE="merlin"
VARIANT="${1:-user}"
JOBS="${2:-$(nproc)}"

echo "=== Building TWRP for Xiaomi $DEVICE ==="
echo "Device: $DEVICE"
echo "Variant: $VARIANT"
echo "Jobs: $JOBS"
echo ""

# Check if we're in the right directory
if [ ! -f "build/envsetup.sh" ]; then
    echo "Error: This script must be run from the TWRP root directory"
    exit 1
fi

# Source build environment
source build/envsetup.sh

# Lunch the device
echo "Setting up device configuration..."
lunch twrp_${DEVICE}-${VARIANT}

# Clean previous build (optional, remove if you want incremental builds)
# mka clean

# Build recovery
echo "Starting build..."
mka recovery -j${JOBS}

# Check for output
if [ -f "out/target/product/$DEVICE/recovery.img" ]; then
    echo ""
    echo "✓ Build successful!"
    echo "Recovery image: out/target/product/$DEVICE/recovery.img"
    ls -lh out/target/product/$DEVICE/recovery.img
else
    echo "✗ Build may have failed - recovery.img not found"
    exit 1
fi
