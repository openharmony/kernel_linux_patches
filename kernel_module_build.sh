#!/bin/bash
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

set -e

export OUT_DIR=$1
if [ $2 == "hispark_taurus" ];then
    if [ ""x == $(which arm-linux-gnueabi-ld)x ] || [ ""x == $(which arm-linux-gnueabi-gcc)x ];then
        echo "Please install gcc-arm-linux-gnueabi, run \"sudo apt-get install gcc-arm-linux-gnueabi\"."
        exit 1
    fi
    export TARGET_PRODUCT=hi3516dv300
    LINUX_KERNEL_OUT=${OUT_DIR}/kernel/linux-4.19
    if [ $3 != "" ];then
	LLVM_PATH=$3
        export CLANG_CC=${LLVM_PATH}/bin/clang
    fi
elif [ $2 == "Hi3516DV300" ];then
    export TARGET_PRODUCT=Hi3516DV300
    LINUX_KERNEL_OUT=${OUT_DIR}/kernel/src_tmp/linux-4.19
    CLANG_BASE_PATH=$3
fi

export OHOS_ROOT_PATH=$(pwd)/../../..
export PRODUCT_PATH=$4

LINUX_KERNEL_UIMAGE_FILE=${LINUX_KERNEL_OUT}/arch/arm/boot/uImage

make -f kernel.mk

if [ -f ${LINUX_KERNEL_UIMAGE_FILE} ];then
    echo "uImage: ${LINUX_KERNEL_UIMAGE_FILE} build success"
else
    echo "uImage: ${LINUX_KERNEL_UIMAGE_FILE} build failed!!!"
    exit 1
fi

if [ $2 == "hispark_taurus" ];then
    cp -rf ${LINUX_KERNEL_UIMAGE_FILE} ${OUT_DIR}/uImage_hi3516dv300_smp
fi

exit 0
