#!/bin/bash
set -e

echo "=== Installing TWRP Build Dependencies ==="

# Update package lists
apt-get update

# Install essential build tools
apt-get install -y \
  build-essential \
  curl \
  flex \
  bison \
  git \
  git-lfs \
  gnupg \
  gperf \
  grep \
  imagemagick \
  lib32z1-dev \
  lib32ncurses5 \
  libc6-dev \
  libcap-dev \
  libexpat1-dev \
  libgmp-dev \
  liblz4-tool \
  libsdl1.2-dev \
  libssl-dev \
  libtool \
  libxml2 \
  libxml2-utils \
  lz4 \
  m4 \
  make \
  openjdk-11-jdk \
  openssl \
  patch \
  pkg-config \
  pngcrush \
  python3 \
  python3-dev \
  python-is-python3 \
  rsync \
  schedtool \
  squashfs-tools \
  ssh \
  texinfo \
  time \
  tree \
  unzip \
  wget \
  xsltproc \
  zip \
  zlib1g-dev

# Install Android SDK Platform Tools
echo "Installing Android SDK Platform Tools..."
mkdir -p /opt/android-sdk
cd /opt/android-sdk
wget -q https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip -q platform-tools-latest-linux.zip
rm platform-tools-latest-linux.zip

# Setup environment variables
cat >> /etc/profile.d/android-env.sh << 'EOF'
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
EOF

# Clone TWRP manifest (optional - user can do this later)
echo "=== TWRP Build Environment Ready ==="
echo ""
echo "To build TWRP for Xiaomi Merlin (MT6768):"
echo "1. repo init -u https://github.com/minimal-manifest-twrp/android_manifest_twrp.git -b twrp-11.0 -g default,-mips,-darwin,-windows"
echo "2. repo sync --force-sync (or add specific device manifests)"
echo "3. source build/envsetup.sh"
echo "4. lunch twrp_merlin-user"
echo "5. mka recovery -j\$(nproc)"
echo ""
echo "Device-specific notes:"
echo "- Device tree: https://github.com/minimal-manifest-twrp/android_device_xiaomi_merlin"
echo "- Check device codename and partition layout before building"
