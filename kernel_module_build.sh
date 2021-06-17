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


if [ $2 == "hispark_taurus" ];then
    export TARGET_PRODUCT=hi3516dv300
elif [ $2 == "Hi3516DV300" ];then
    export TARGET_PRODUCT=Hi3516DV300
fi

export OHOS_ROOT_PATH=$(pwd)/../../..
#note out_dir style:out/xx/
export OUT_DIR=$1

LINUX_KERNEL_OUT=${OUT_DIR}/kernel/src_tmp/linux-4.19
LINUX_KERNEL_UIMAGE_FILE=${LINUX_KERNEL_OUT}/arch/arm/boot/uImage

HISPARK_TAS_SDK_LINUX_PATH=${OHOS_ROOT_PATH}/device/hisilicon/hispark_taurus/sdk_linux
HISPARK_TAS_SDK_LINUX_MPP_PATH=${HISPARK_TAS_SDK_LINUX_PATH}/soc/src/mpp

make -f kernel.mk

if [ -f ${LINUX_KERNEL_UIMAGE_FILE} ];then
    echo "uImage: ${LINUX_KERNEL_UIMAGE_FILE} build success"
else
    echo "uImage build failed!!!"
    exit 1
fi


if [ $2 == "hispark_taurus" ];then
    cp -rf ${LINUX_KERNEL_UIMAGE_FILE} ${OUT_DIR}/uImage_hi3516dv300_smp
fi

export KERNEL_ROOT=${LINUX_KERNEL_OUT}
pushd ${HISPARK_TAS_SDK_LINUX_MPP_PATH}; make -f sdk.mk; popd

exit 0
