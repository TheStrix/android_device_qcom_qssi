# config.mk
#
# Product-specific compile-time definitions.
#

TARGET_BOARD_PLATFORM := $(VENDOR_QTI_PLATFORM)
TARGET_BOOTLOADER_BOARD_NAME := qssi

# Skip recovery images for system image only generation
TARGET_NO_KERNEL   := false
TARGET_NO_RECOVERY := true

# Kernel defconfig
KERNEL_DEFCONFIG = beryllium_defconfig

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := kryo300
#TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a75

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := true

TARGET_CRYPTFS_HW_PATH := vendor/qcom/opensource/cryptfs_hw

BOARD_SECCOMP_POLICY := device/qcom/qssi/seccomp

TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true

-include $(QCPATH)/common/$(VENDOR_QTI_PLATFORM)/BoardConfigVendor.mk

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_USES_WIPOWER := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/qcom/qssi

USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true

# Set Header version for bootimage
BOARD_BOOTIMG_HEADER_VERSION := 1
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOTIMG_HEADER_VERSION)

ifeq ($(ENABLE_AB), true)
# Defines for enabling A/B builds
AB_OTA_UPDATER := true
# Full A/B partition update set
# AB_OTA_PARTITIONS := xbl rpm tz hyp pmic modem abl boot keymaster cmnlib cmnlib64 system bluetooth

# Minimum partition set for automation to test recovery generation code
# Packages generated by using just the below flag cannot be used for updating a device. You must pass
# in the full set mentioned above as part of your make commandline
AB_OTA_PARTITIONS ?= boot system
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
TARGET_NO_RECOVERY := true
#BOARD_USES_RECOVERY_AS_BOOT := true
else
# Non-A/B section. Define cache and recovery partition variables.
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif

#Enable compilation of oem-extensions to recovery
#These need to be explicitly
ifneq ($(AB_OTA_UPDATER),true)
    TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm
endif

#Enable Charging Icon
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

#Enable split vendor image
ENABLE_VENDOR_IMAGE := true
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 57453555712
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_DTBOIMG_PARTITION_SIZE := 0x0800000
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := false

TARGET_USES_IOPHAL := true

BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0xA84000 androidboot.hardware=qcom androidboot.console=ttyMSM0 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 service_locator.enable=1 swiotlb=2048 androidboot.configfs=true firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7 androidboot.usbcontroller=a600000.dwc3
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

BOARD_EGL_CFG := device/qcom/qssi/egl.cfg

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_USES_UNCOMPRESSED_KERNEL := false

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

BOARD_USES_GENERIC_AUDIO := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_NO_RPC := true

TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
TARGET_INIT_VENDOR_LIB := libinit_msm

TARGET_KERNEL_APPEND_DTB := true
TARGET_COMPILE_WITH_MSM_KERNEL := true

#Enable PD locater/notifier
TARGET_PD_SERVICE_ENABLED := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

# Enable dex pre-opt to speed up initial boot
ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
endif

TARGET_USES_GRALLOC1 := true

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

#Enable QTI specific Camera2Client layer
TARGET_USES_QTI_CAMERA2CLIENT := true

#Add non-hlos files to ota packages
ADD_RADIO_FILES := true

#Generate DTBO image
BOARD_KERNEL_SEPARATED_DTBO := true

#To use libhealthd.msm instead of libhealthd.default
BOARD_HAL_STATIC_LIBRARIES := libhealthd.msm

#Enable INTERACTION_BOOST
TARGET_USES_INTERACTION_BOOST := true

#Disable LM
TARGET_USES_LM := false

ifeq ($(ENABLE_VENDOR_IMAGE), false)
$(error "Vendor Image is mandatory !!")
endif


#Enable DRM plugins 64 bit compilation
TARGET_ENABLE_MEDIADRM_64 := true

#Flag to enable System SDK Requirements.
#All vendor APK will be compiled against system_current API set.
BOARD_SYSTEMSDK_VERSIONS:=28
BOARD_VNDK_VERSION:= current
