# SPDX-License-Identifier: Apache-2.0
#
# Southbag Mobile OS for the Google Pixel 4a (sunfish).
# Mirrors the official LineageOS product configuration for sunfish, with
# Southbag product identity layered on top.

# Inherit some common LineageOS stuff. Southbag Mobile OS is a LineageOS distribution.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/sunfish/aosp_sunfish.mk)

include device/google/sunfish/device-lineage.mk

# Inherit Southbag Mobile OS common configuration (enforces sunfish-only).
$(call inherit-product, vendor/southbag/config/common.mk)

# Device identifier. This must come after all inclusions
PRODUCT_BRAND := Southbag
PRODUCT_MODEL := Pixel 4a
PRODUCT_NAME := southbag_sunfish
PRODUCT_SYSTEM_NAME := Southbag Mobile OS

# Boot animation
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sunfish-user 13 TQ3A.230805.001.S1 10786265 release-keys" \
    BuildFingerprint=google/sunfish/sunfish:13/TQ3A.230805.001.S1/10786265:user/release-keys \
    DeviceProduct=sunfish

$(call inherit-product, vendor/google/sunfish/sunfish-vendor.mk)
