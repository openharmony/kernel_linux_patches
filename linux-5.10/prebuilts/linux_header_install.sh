#!/bin/bash

#Copyright (c) 2020-2021 Huawei Device Co., Ltd.
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

# This script is used to prepare header files for musl's libc.so.

set -e
ARM_TYPE=arm
PRJ_ROOT="$PWD/../../../../../"
KERNEL_ROOT="$PRJ_ROOT/kernel/linux/linux-5.10"
ARM_HDR="$KERNEL_ROOT/hdr_install/${ARM_TYPE}_header"
OUT_HDR="$PRJ_ROOT/kernel/linux/patches/linux-5.10/prebuilts/linux_headers_install"
export Z_BUILD_TOP="$PRJ_ROOT"

if [ -d "$ARM_HDR" ];then
rm -r $ARM_HDR
fi

if [ -d "$OUT_HDR" ];then
rm -r $OUT_HDR
fi

mkdir -p $ARM_HDR
mkdir -p $OUT_HDR

pushd $KERNEL_ROOT
make headers_install ARCH=${ARM_TYPE} INSTALL_HDR_PATH=$ARM_HDR
popd

function copy_if_exists () {
    local check_dir=$1
    local src_dir=$2
    local tgt_dir=$3
    mkdir -p ${tgt_dir}
    for file in $(ls -d ${src_dir}/* 2> /dev/null); do
        if [[ -f "${file}" ]] && [[ "${file}" =~ .h$ ]]; then
	    header=$(basename ${file})
	    if [[ -f "${check_dir}/${header}" ]]; then
                cp ${file} ${tgt_dir}
	    fi
	fi
    done
}

cp -r ${KERNEL_ROOT}/include/uapi ${OUT_HDR}
cp -r ${KERNEL_ROOT}/include/generated/uapi ${OUT_HDR}
cp -r ${ARM_HDR}/include/asm  ${OUT_HDR}/uapi
cp -r ${KERNEL_ROOT}/arch/${ARM_TYPE}/include/uapi ${OUT_HDR}/uapi/asm-${ARM_TYPE}
cp -r ${KERNEL_ROOT}/arch/${ARM_TYPE}/include/generated/uapi ${OUT_HDR}/uapi/asm-${ARM_TYPE}
cp -r ${KERNEL_ROOT}/drivers/staging/android/uapi/* ${OUT_HDR}/uapi/linux
copy_if_exists "${KERNEL_ROOT}/include/uapi/asm-generic" \
	"${KERNEL_ROOT}/arch/${ARM_TYPE}/include/generated/asm" \
	"${OUT_HDR}/uapi/asm-${ARM_TYPE}/asm"
cp ${KERNEL_ROOT}/include/linux/compiler_types.h ${OUT_HDR}/uapi/linux
