#
# SPDX-FileCopyrightText: 2026 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: Apache-2.0
#

# Soong Namespace
PRODUCT_SOONG_NAMESPACES += \
    vendor/partner_pvot

# Android Build system uncompresses DEX files (classes*.dex) in the privileged
# apps by default, which breaks APK v2/v3 signature. Because some privileged
# Pvot apps are still shipped with compressed DEX, we need to disable
# uncompression feature to make them work correctly.
DONT_UNCOMPRESS_PRIV_APPS_DEXS := true

# Inherit arm64 apps-only :/
$(call inherit-product, vendor/partner_pvot/products/apps_arm64.mk)

# Inherit SEPolicy
$(call inherit-product, vendor/partner_pvot/sepolicy/sepolicy-pvot.mk)
