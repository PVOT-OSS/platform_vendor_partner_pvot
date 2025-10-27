#
# Copyright 2026 Saalim Quadri
# SPDX-License-Identifier: Apache-2.0
#

# Soong Namespace
PRODUCT_SOONG_NAMESPACES += \
    vendor/partner_pvot

# Inherit arm64 apps-only :/
$(call inherit-product, vendor/partner_pvot/products/apps_arm64.mk)
