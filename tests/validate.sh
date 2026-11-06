#!/usr/bin/env bash
# Static validation for the Southbag Mobile OS scaffold.
# Runs anywhere (no AOSP tree needed); complements, never replaces, a real build.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
check() { if eval "$2"; then echo "PASS: $1"; else echo "FAIL: $1"; fail=1; fi; }

check "product makefile exists"            "test -f build/target/product/southbag_sunfish.mk"
check "AndroidProducts.mk exists"          "test -f build/target/product/AndroidProducts.mk"
check "product registered in AndroidProducts.mk" "grep -q 'southbag_sunfish.mk' build/target/product/AndroidProducts.mk"
check "product name is southbag_sunfish"   "grep -q 'PRODUCT_NAME := southbag_sunfish' build/target/product/southbag_sunfish.mk"
check "product inherits aosp_sunfish.mk"   "grep -q 'device/google/sunfish/aosp_sunfish.mk' build/target/product/southbag_sunfish.mk"
check "product inherits southbag common"   "grep -q 'vendor/southbag/config/common.mk' build/target/product/southbag_sunfish.mk"
check "product inherits lineage phone config" "grep -q 'vendor/lineage/config/common_full_phone.mk' build/target/product/southbag_sunfish.mk"
check "product inherits sunfish vendor blobs" "grep -q 'vendor/google/sunfish/sunfish-vendor.mk' build/target/product/southbag_sunfish.mk"
check "sunfish-only guard present"         "grep -q 'ifneq (\$(TARGET_DEVICE),sunfish)' config/common.mk"
check "southbag prop file exists"          "test -f config/southbag.prop"
check "prop file sets ro.southbag.version" "grep -q 'ro.southbag.version=' config/southbag.prop"
check "Kevin is watching motto present"    "grep -q 'ro.southbag.motto=Kevin is watching' config/southbag.prop"
check "Kevin is CEO property"              "grep -q 'ro.southbag.ceo=Kevin' config/southbag.prop"
check "common.mk includes prop file"       "grep -q 'TARGET_PRODUCT_PROP += vendor/southbag/config/southbag.prop' config/common.mk"
check "product sets Southbag system name"  "grep -q 'PRODUCT_SYSTEM_NAME := Southbag Mobile OS' build/target/product/southbag_sunfish.mk"

check "manifest is well-formed XML"        "python3 -c 'import xml.dom.minidom,sys; xml.dom.minidom.parse(\"manifest/southbag.xml\")'"
check "manifest pins device tree"          "grep -q 'android_device_google_sunfish' manifest/southbag.xml"
check "manifest pins kernel"               "grep -q 'android_kernel_google_msm-4.14' manifest/southbag.xml"
check "manifest pins vendor blobs"         "grep -q 'proprietary_vendor_google_sunfish' manifest/southbag.xml"
check "manifest maps this repo to vendor/southbag" "grep -q 'path=\"vendor/southbag\"' manifest/southbag.xml"

check "build script uses explicit lunch"   "grep -q 'lunch \"southbag_sunfish-' scripts/build.sh"
check "no breakfast/brunch bare-product reliance" "! grep -Eq '^\s*(breakfast|brunch) southbag' scripts/build.sh"
check "no secrets in tree"                 "! grep -rEI '(ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|BEGIN [A-Z ]*PRIVATE KEY)' --exclude-dir=.git ."

if [ "$fail" -ne 0 ]; then echo "VALIDATION FAILED"; exit 1; fi
echo "ALL CHECKS PASSED"
