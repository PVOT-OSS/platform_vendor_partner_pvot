#
# SPDX-FileCopyrightText: 2026 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: Apache-2.0
#

# Soong Namespace
PRODUCT_SOONG_NAMESPACES += \
    vendor/partner_pvot

# Inherit arm64 apps-only :/
$(call inherit-product, vendor/partner_pvot/products/apps_arm64.mk)

# Inherit SEPolicy
$(call inherit-product, vendor/partner_pvot/sepolicy/sepolicy-pvot.mk)
