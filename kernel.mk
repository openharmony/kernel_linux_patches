# Copyright (c) 2021 Huawei Device Co., Ltd.
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# ohos makefile to build kernel
PRODUCT_NAME=$(TARGET_PRODUCT)
OHOS_BUILD_HOME := $(realpath $(shell pwd)/../../../)
KERNEL_SRC_TMP_PATH := $(OUT_DIR)/kernel/linux-4.19
ifeq ($(PRODUCT_NAME), Hi3516DV300)
    OHOS_BUILD_HOME := $(OHOS_ROOT_PATH)
    BOOT_IMAGE_PATH = $(OHOS_BUILD_HOME)/device/hisilicon/hispark_taurus/prebuilts
    KERNEL_SRC_TMP_PATH := $(OUT_DIR)/kernel/src_tmp/linux-4.19
endif

KERNEL_SRC_PATH := $(OHOS_BUILD_HOME)/kernel/linux-4.19
KERNEL_PATCH_PATH := $(OHOS_BUILD_HOME)/kernel/linux/patches/linux-4.19
KERNEL_CONFIG_PATH := $(OHOS_BUILD_HOME)/kernel/linux/config/linux-4.19
PREBUILTS_GCC_DIR := $(OHOS_BUILD_HOME)/prebuilts/gcc
PREBUILTS_CLANG_DIR := $(OHOS_BUILD_HOME)/prebuilts/clang
CLANG_HOST_TOOLCHAIN := $(PREBUILTS_CLANG_DIR)/host/linux-x86/clang-r353983c/bin
KERNEL_HOSTCC := $(CLANG_HOST_TOOLCHAIN)/clang
KERNEL_PREBUILT_MAKE := make

ifeq ($(PRODUCT_NAME), Hi3516DV300)
    KERNEL_ARCH := arm
    KERNEL_TARGET_TOOLCHAIN := $(PREBUILTS_GCC_DIR)/linux-x86/arm/gcc-linaro-7.5.0-arm-linux-gnueabi/bin
    KERNEL_TARGET_TOOLCHAIN_PREFIX := $(KERNEL_TARGET_TOOLCHAIN)/arm-linux-gnueabi-
    CLANG_CC := $(CLANG_HOST_TOOLCHAIN)/clang
else ifeq ($(PRODUCT_NAME), hi3516dv300)
    KERNEL_ARCH := arm
    ifeq ($(CLANG_CC), "")
        CLANG_CC := $(OHOS_BUILD_HOME)/prebuilts/clang/ohos/linux-x86_64/clang-10.0.1/bin/clang
    endif
endif

KERNEL_PERL := /usr/bin/perl

KERNEL_CROSS_COMPILE :=
KERNEL_CROSS_COMPILE += CC="$(CLANG_CC)"
ifeq ($(PRODUCT_NAME), Hi3516DV300)
    KERNEL_CROSS_COMPILE += HOSTCC="$(KERNEL_HOSTCC)"
    KERNEL_CROSS_COMPILE += PERL=$(KERNEL_PERL)
    KERNEL_CROSS_COMPILE += CROSS_COMPILE="$(KERNEL_TARGET_TOOLCHAIN_PREFIX)"
else ifeq ($(PRODUCT_NAME), hi3516dv300)
    KERNEL_CROSS_COMPILE += CROSS_COMPILE="arm-linux-gnueabi-"
endif

KERNEL_MAKE := \
    PATH="$(BOOT_IMAGE_PATH):$$PATH" \
    $(KERNEL_PREBUILT_MAKE)


ifneq ($(findstring $(PRODUCT_NAME), hi3516dv300 Hi3516DV300),)
HI3516DV300_PATCH_DIR := $(OHOS_BUILD_HOME)/kernel/linux/patches/linux-4.19/hi3516dv300_small_patch
HI3516DV300_PATCH_FILE := $(HI3516DV300_PATCH_DIR)/hi3516dv300_small.patch
HDF_PATCH_FILE := $(HI3516DV300_PATCH_DIR)/hdf.patch
DFX_PATCH_FILE := $(HI3516DV300_PATCH_DIR)/dfx.patch
KERNEL_IMAGE_FILE := $(KERNEL_SRC_TMP_PATH)/arch/arm/boot/uImage
ifeq ($(PRODUCT_NAME), hi3516dv300)
DEFCONFIG_FILE := hi3516dv300_small_defconfig
else
DEFCONFIG_FILE := hi3516dv300_standard_defconfig
endif
export HDF_PROJECT_ROOT=$(OHOS_BUILD_HOME)/
export PRODUCT_PATH=vendor/hisilicon/hispark_taurus_linux

$(KERNEL_IMAGE_FILE):
	$(hide) echo "build kernel..."
	$(hide) rm -rf $(KERNEL_SRC_TMP_PATH);mkdir -p $(KERNEL_SRC_TMP_PATH);cp -arfL $(KERNEL_SRC_PATH)/. $(KERNEL_SRC_TMP_PATH)/
	$(hide) cd $(KERNEL_SRC_TMP_PATH) && patch -p1 < $(DFX_PATCH_FILE) && patch -p1 < $(HDF_PATCH_FILE) && patch -p1 < $(HI3516DV300_PATCH_FILE)
	$(hide) cp -rf $(KERNEL_CONFIG_PATH)/. $(KERNEL_SRC_TMP_PATH)/
	$(hide) $(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) distclean
	$(hide) $(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(DEFCONFIG_FILE)
	$(hide) $(KERNEL_MAKE) -C $(KERNEL_SRC_TMP_PATH) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) -j64 uImage
endif
.PHONY: build-kernel
build-kernel: $(KERNEL_IMAGE_FILE)
