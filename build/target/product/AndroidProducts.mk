# SPDX-License-Identifier: Apache-2.0
#
# Southbag Mobile OS product definitions.
# One product only: the Google Pixel 4a (sunfish).
#
# Layout follows vendor/lineage/build/target/product/, which is scanned
# for AndroidProducts.mk files by the build system.

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/southbag_sunfish.mk

# NOTE: the release token tracks vendor/lineage/vars/aosp_target_release in
# the LineageOS tree (aosp_target_release=cp2a on lineage-24.0 as of
# 2026-11-06, the value `breakfast` itself uses). COMMON_LUNCH_CHOICES only
# feeds the interactive lunch menu; scripts/build.sh resolves the token at
# build time instead of hardcoding it here.
COMMON_LUNCH_CHOICES := \
    southbag_sunfish-cp2a-userdebug
