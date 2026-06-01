.PHONY: help init sync setup build clean help

DEVICE = merlin
JOBS = $(shell nproc)
VARIANT = user

help:
	@echo "TWRP Build Environment for Xiaomi Merlin"
	@echo ""
	@echo "Available targets:"
	@echo "  make init       - Initialize TWRP repo (must run first)"
	@echo "  make sync       - Sync TWRP source tree"
	@echo "  make setup      - Setup device trees and environment"
	@echo "  make build      - Build recovery image"
	@echo "  make clean      - Clean build output"
	@echo "  make help       - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make init && make sync && make setup && make build"
	@echo "  make build JOBS=8"
	@echo "  make clean"

init:
	@echo "[*] Initializing TWRP repository..."
	repo init -u https://github.com/minimal-manifest-twrp/android_manifest_twrp.git \
		-b twrp-11.0 \
		-g default,-mips,-darwin,-windows
	@echo "[✓] Repo initialized. Run 'make sync' next."

sync:
	@echo "[*] Syncing TWRP source tree..."
	repo sync --force-sync -j4
	@echo "[✓] Sync complete."

setup:
	@echo "[*] Setting up device tree..."
	chmod +x setup-twrp.sh
	./setup-twrp.sh
	@echo "[✓] Setup complete. Run 'make build' to compile."

build:
	@echo "[*] Building TWRP for $(DEVICE)..."
	@echo "    Device: $(DEVICE)"
	@echo "    Variant: $(VARIANT)"
	@echo "    Jobs: $(JOBS)"
	source build/envsetup.sh && \
	lunch twrp_$(DEVICE)-$(VARIANT) && \
	mka recovery -j$(JOBS)
	@if [ -f "out/target/product/$(DEVICE)/recovery.img" ]; then \
		echo "[✓] Build successful!"; \
		ls -lh out/target/product/$(DEVICE)/recovery.img; \
	else \
		echo "[✗] Build failed - recovery.img not found"; \
		exit 1; \
	fi

clean:
	@echo "[*] Cleaning build output..."
	rm -rf out/
	@echo "[✓] Clean complete."

clean-all:
	@echo "[*] Full clean (removes all build data)..."
	rm -rf out/ .repo/
	@echo "[✓] Full clean complete."

check-deps:
	@echo "Checking required tools..."
	@command -v repo >/dev/null 2>&1 && echo "[✓] repo" || echo "[✗] repo (not found)"
	@command -v git >/dev/null 2>&1 && echo "[✓] git" || echo "[✗] git (not found)"
	@command -v java >/dev/null 2>&1 && echo "[✓] java" || echo "[✗] java (not found)"
	@command -v make >/dev/null 2>&1 && echo "[✓] make" || echo "[✗] make (not found)"
