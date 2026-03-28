#
# SPDX-FileCopyrightText: 2026 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    vendor/partner_pvot/apps \
    vendor/partner_pvot/apps_src

# Common Configuration
PRODUCT_PACKAGES += \
    privapp_permissions_pvot_product

# Compass
PRODUCT_PACKAGES += \
    PvotCompass

# Messaging
PRODUCT_PACKAGES += \
    Messages
