# SPDX-License-Identifier: Apache-2.0
#
# Southbag Mobile OS common configuration.
# Southbag Mobile OS is compatible with the Google Pixel 4a (sunfish) only.

ifneq ($(TARGET_DEVICE),sunfish)
$(error Southbag Mobile OS supports the Google Pixel 4a (sunfish) only)
endif

SOUTHBAG_VERSION := 0.1.0
SOUTHBAG_BASE := lineage-24.0

# Southbag system properties (ro.southbag.*), incl. "Kevin is watching".
TARGET_PRODUCT_PROP += vendor/southbag/config/southbag.prop
