# TWRP Build Environment for Xiaomi Merlin (MT6768)

This repository contains a GitHub Codespaces configuration to build TWRP recovery for the Xiaomi Merlin (MT6768) device.

## Quick Start

### 1. Open in Codespaces

Click "Code" → "Codespaces" → "Create codespace on main" to launch the development environment. The container will automatically install all required dependencies (~5-10 minutes).

### 2. Initialize TWRP Repository

```bash
# Initialize repo for TWRP 11.0
repo init -u https://github.com/minimal-manifest-twrp/android_manifest_twrp.git \
  -b twrp-11.0 \
  -g default,-mips,-darwin,-windows

# Sync repository (this takes a while, ~15-30 minutes)
repo sync --force-sync -j4

# Or sync with specific manifest for faster sync
repo sync -j4
```

### 3. Prepare Device Tree

```bash
# Clone device-specific tree
git clone https://github.com/minimal-manifest-twrp/android_device_xiaomi_merlin.git \
  device/xiaomi/merlin

# Clone common trees if needed
git clone https://github.com/minimal-manifest-twrp/android_device_xiaomi_mt6768-common.git \
  device/xiaomi/mt6768-common
```

### 4. Build Recovery

**Option A: Using the build script**
```bash
chmod +x build-twrp-merlin.sh
./build-twrp-merlin.sh
```

**Option B: Manual build**
```bash
source build/envsetup.sh
lunch twrp_merlin-user
mka recovery -j$(nproc)
```

## Build Output

Recovery image location:
```
out/target/product/merlin/recovery.img
```

## Environment Details

- **Base OS**: Ubuntu 22.04
- **Java**: OpenJDK 11
- **Android SDK**: Latest platform-tools
- **Build Tools**: make, ninja, clang, etc.

## Disk Space Considerations

- TWRP source: ~8-10GB
- Build output: ~5-10GB
- **Total needed**: ~20GB (Codespaces provides 32GB)

To free up space during builds:
```bash
rm -rf out/           # Clear build artifacts
du -sh .              # Check current size
```

## Troubleshooting

### Out of Disk Space
```bash
# Clear Android cache
rm -rf out/target/product/merlin
# Remove old builds
rm -rf ~/.cache/ccache
```

### Build Fails
- Check device tree is in correct location
- Verify Java version: `java -version`
- Check manifest version compatibility with device tree
- View full logs in `out/verbose.log`

### Long Build Times
- Use more jobs: `mka recovery -j$(nproc)`
- Disable ccache cleaning between builds
- Consider using prebuilt Android toolchain

## TWRP Variants

- **twrp-11.0**: Latest stable
- **twrp-12.1**: Newer versions (may need different device tree)
- **twrp-13.0**: Latest development

Adjust the repo init command based on desired version.

## Resources

- [TWRP Project](https://twrp.me/)
- [TWRP GitHub](https://github.com/TeamWin)
- [Minimal Manifest TWRP](https://github.com/minimal-manifest-twrp)
- [Merlin Device Tree](https://github.com/minimal-manifest-twrp/android_device_xiaomi_merlin)

## Performance Tips

1. **Increase Codespaces machine**: Use 4-core for faster builds
2. **Parallel compilation**: `mka recovery -j8` (adjust based on cores)
3. **ccache**: Enable compiler cache for faster rebuilds
4. **Network**: Use high-speed connection for repo sync
5. **Background processes**: Stop unnecessary apps during builds

## License

This configuration is for educational purposes. TWRP is licensed under Apache 2.0.
Always respect device manufacturers' licensing and warranty policies.
