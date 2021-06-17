#!/bin/bash

set -e

export TARGET_PRODUCT=hi3516dv300
export OHOS_ROOT_PATH=$(pwd)/../../..
export OUTDIR=$1

LINUX_KERNEL_OUT=${OHOS_ROOT_PATH}/out/kernel/src_tmp/linux-4.19
LINUX_KERNEL_OUT_DIR=${OHOS_ROOT_PATH}/out/kernel
HISPARK_TAS_SDK_LINUX_PATH=${OHOS_ROOT_PATH}/device/hisilicon/hispark_taurus/sdk_linux
HISPARK_TAS_SDK_LINUX_MPP_PATH=${HISPARK_TAS_SDK_LINUX_PATH}/soc/src/mpp

make -f kernel.mk
cp -rf $LINUX_KERNEL_OUT/arch/arm/boot/uImage $OUTDIR/uImage_hi3516dv300_smp

pushd ${HISPARK_TAS_SDK_LINUX_MPP_PATH}; make -f sdk.mk; popd
rm -rf $LINUX_KERNEL_OUT_DIR
