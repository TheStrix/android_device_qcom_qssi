DEVICE_DIR := $(call my-dir)

##########
# QTI platform name
# - use for TARGET_BOARD_PLATFORM logic during compile-time and runtime
# - for QSSI target, the reference chipset for compilation
VENDOR_QTI_PLATFORM := sdm845
VENDOR_QTI_DEVICE := qssi

##########
# QSSI configuration
# - Single System Image project structure
TARGET_USES_QSSI := true

# Enable AVB 2.0
#BOARD_AVB_ENABLE := true

TARGET_DEFINES_DALVIK_HEAP := true

$(call inherit-product, device/qcom/$(VENDOR_QTI_DEVICE)/common64.mk)

PRODUCT_NAME := pa_qssi
PRODUCT_DEVICE := $(VENDOR_QTI_DEVICE)
PRODUCT_MODEL := QSSI system image for arm64

#Inherit all except heap growth limit from phone-xhdpi-2048-dalvik-heap.mk
PRODUCT_PROPERTY_OVERRIDES  += \
  dalvik.vm.heapstartsize=8m \
  dalvik.vm.heapsize=512m \
  dalvik.vm.heaptargetutilization=0.75 \
  dalvik.vm.heapminfree=512k \
  dalvik.vm.heapmaxfree=8m

# Property to enable app trigger
PRODUCT_PROPERTY_OVERRIDES  += \
  ro.vendor.at_library=libqti-at.so\
  persist.vendor.qti.games.gt.prof=1

# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
# 196610 is decimal for 0x30002 to report version 3.2
PRODUCT_PROPERTY_OVERRIDES  += \
  ro.opengles.version=196610

# RRO configuration
TARGET_USES_RRO := true

# Default A/B configuration.
#ENABLE_AB ?= true

TARGET_KERNEL_VERSION := 4.9
TARGET_KERNEL_VERSION ?= $(patsubst kernel/msm-%,%,$(firstword $(wildcard kernel/msm-*)))
ifeq ($(TARGET_KERNEL_VERSION),)
  $(error Unable to find a usable kernel tree at kernel/msm-*)
endif

TARGET_USES_NQ_NFC := false
ifeq ($(TARGET_USES_NQ_NFC),true)
# Flag to enable and support NQ3XX chipsets
NQ3XX_PRESENT := true
endif

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

# WLAN chipset
WLAN_CHIPSET := qca_cld3

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

-include $(QCPATH)/common/config/qtic-config.mk
-include hardware/qcom/display/config/sdm845.mk

#PRODUCT_BOOT_JARS += telephony-ext \
#                     tcmiface
PRODUCT_PACKAGES += telephony-ext
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

TARGET_DISABLE_DASH := true

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/sdm845/sdm845.mk

PRODUCT_PACKAGES += fs_config_files

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    brillo_update_payload \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

DEVICE_MANIFEST_FILE := device/qcom/qssi/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/qssi/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/qssi/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := device/qcom/qssi/vendor_framework_compatibility_matrix.xml

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

PRODUCT_PACKAGES += \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \

# Context hub HAL
PRODUCT_PACKAGES += \
    android.hardware.contexthub@1.0-impl.generic \
    android.hardware.contexthub@1.0-service

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

PRODUCT_PACKAGES += android.hardware.usb@1.0-service

# WLAN host driver
ifneq ($(WLAN_CHIPSET),)
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
endif

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#for wlan
PRODUCT_PACKAGES += \
    wificond \
    wifilogd

#Enable debug libraries
ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_PACKAGES += libstagefright_debug \
                    libmediaplayerservice_debug
endif

# Kernel modules install path
KERNEL_MODULES_INSTALL := system
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_DEVICE)/$(KERNEL_MODULES_INSTALL)/lib/modules

#Enable full treble flag

#Add soft home, back and multitask keys
PRODUCT_PROPERTY_OVERRIDES += \
    qemu.hw.mainkeys=0

# system prop for opengles version
#
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
# 196610 is decimal for 0x30002 to report version 3.2
PRODUCT_PROPERTY_OVERRIDES  += \
    ro.opengles.version=196610

#system prop for bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.qcom.bluetooth.soc=cherokee

PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true

PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/vendor/lib64/libril-qc-hal-qmi.so

#Property to set BG App limit
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.qti.sys.fw.bg_apps_limit=60

#Enable QTI KEYMASTER and GATEKEEPER HIDLs
KMGK_USE_QTI_SERVICE := true

ifneq ($(strip $(TARGET_USES_RRO)),true)
DEVICE_PACKAGE_OVERLAYS += device/qcom/qssi/overlay
endif

#VR
PRODUCT_PACKAGES += android.hardware.vr@1.0-impl \
                    android.hardware.vr@1.0-service
#Thermal
PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service

# Camera HIDL configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

TARGET_SCVE_DISABLED := true
#TARGET_USES_QTIC := false
#TARGET_USES_QTIC_EXTENSION := false

SDM845_DISABLE_MODULE := true

ENABLE_VENDOR_RIL_SERVICE := true

# Enable vndk-sp Libraries
PRODUCT_PACKAGES += vndk_package

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE:=true

#Enable WIFI AWARE FEATURE
WIFI_HIDL_FEATURE_AWARE := true

# Enable STA + SAP Concurrency.
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# Enable SAP + SAP Feature.
QC_WIFI_HIDL_FEATURE_DUAL_AP := true

TARGET_USES_MKE2FS := true

$(call inherit-product, build/make/target/product/product_launched_with_o_mr1.mk)

TARGET_MOUNT_POINTS_SYMLINKS := false

# propery "ro.vendor.build.security_patch" is checked for
# CTS compliance so need to make sure its set with following
# format "YYYY-MM-DD" on production devices.
#
ifeq ($(ENABLE_VENDOR_IMAGE), true)
 VENDOR_SECURITY_PATCH := 2018-06-05
endif

# Inherit from the proprietary version
-include vendor/xiaomi/beryllium/BoardConfigVendor.mk
-include vendor/xiaomi/sdm845-common/BoardConfigVendor.mk

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/xiaomi/beryllium/beryllium-vendor.mk)
$(call inherit-product-if-exists, vendor/xiaomi/sdm845-common/sdm845-common-vendor.mk)
