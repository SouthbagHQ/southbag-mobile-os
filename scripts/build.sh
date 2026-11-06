#!/usr/bin/env bash
# Build Southbag Mobile OS for the Google Pixel 4a (sunfish).
#
# Requirements (per the LineageOS build guide for sunfish):
#   - x86_64 Linux (Ubuntu 20.04 LTS or newer recommended)
#   - 64 GB RAM or more (lineage-21 and up), plus ZRAM if short
#   - 400 GB free storage (SSD strongly recommended)
#   - Android build packages per the LineageOS build guide
#
# Usage: scripts/build.sh [workdir]
set -euo pipefail

BRANCH="lineage-24.0"
WORK_DIR="${1:-$HOME/android/southbag}"
MANIFEST_URL="https://raw.githubusercontent.com/SouthbagHQ/southbag-mobile-os/main/manifest/southbag.xml"

echo "==> Southbag Mobile OS build for Pixel 4a (sunfish), base ${BRANCH}"
echo "==> Work directory: ${WORK_DIR}"
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"

if [ ! -d .repo ]; then
  echo "==> repo init (${BRANCH})"
  repo init -u https://github.com/LineageOS/android.git -b "${BRANCH}" --git-lfs --no-clone-bundle
fi

echo "==> Installing Southbag local manifest"
mkdir -p .repo/local_manifests
# NOTE: if SouthbagHQ/southbag-mobile-os is private, this fetch and the
# repo sync of the southbag project need GitHub authentication (e.g. a
# credential helper or gh auth). Never commit tokens to this repo.
curl -fsSL "${MANIFEST_URL}" -o .repo/local_manifests/southbag.xml

echo "==> repo sync"
repo sync -c -j"$(nproc)" --force-sync --no-clone-bundle --no-tags

echo "==> Selecting product"
source build/envsetup.sh
# breakfast/brunch do NOT work with the bare product name here: on
# lineage-24.0 they hardcode the `lineage_` prefix
# (vendor/lineage/build/envsetup.sh). Resolve the release token exactly the
# way breakfast does and lunch the full combo directly.
source vendor/lineage/vars/aosp_target_release
echo "==> lunch southbag_sunfish-${aosp_target_release}-userdebug"
lunch "southbag_sunfish-${aosp_target_release}-userdebug"

echo "==> Building (this takes hours on a suitable machine)"
mka bacon

echo "==> Done. Images are in out/target/product/sunfish/"
