#!/bin/bash
# Build Viettel firmware on macOS using the OpenWrt build container.
#
# Usage:
#   bash scripts/build-viettel-macos.sh [defconfig]

set -euo pipefail

DEFCONFIG="${1:-defconfig/viettel_eng.config}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE="${OPENWRT_BUILD_IMAGE:-ghcr.io/openwrt/buildbot/buildworker-v3.8.0:v9}"

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "ERROR: scripts/build-viettel-macos.sh chỉ dùng cho macOS." >&2
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Không tìm thấy docker. Hãy cài Docker Desktop hoặc Colima trước." >&2
    exit 1
fi

cd "$REPO_ROOT"

echo "=== Build trên macOS bằng container: $IMAGE ==="
docker run --rm \
    --platform linux/arm64 \
    -v "$REPO_ROOT:/workdir" \
    -w /workdir \
    "$IMAGE" \
    bash -lc "git config --global --add safe.directory /workdir && bash scripts/build-viettel.sh '$DEFCONFIG'"
