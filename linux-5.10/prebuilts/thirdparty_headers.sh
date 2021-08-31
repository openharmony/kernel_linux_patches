#/bin/bash

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
PRJ_ROOT="${PWD}/../../../../../"
LINUX_HDR="${PRJ_ROOT}/kernel/linux/patches/linux-5.10/prebuilts/linux_headers_install"
TMP_DIR_ORI="${PRJ_ROOT}/kernel/linux/patches/linux-5.10/prebuilts/ohos_tmp_ori"
TMP_DIR="${PRJ_ROOT}/kernel/linux/patches/linux-5.10/prebuilts/ohos_tmp"
MUSL_DIR="${PWD}/usr/include"
export Z_BUILD_TOP="${PRJ_ROOT}"
if [ ! -d "${LINUX_HDR}/uapi/asm-${ARM_TYPE}" ] || [ ! -d "${LINUX_HDR}/uapi/asm-generic" ] || [ ! -d "${LINUX_HDR}/uapi/linux" ];then
    echo "please install headers first!!!"
    exit 1
fi

mkdir -p ${TMP_DIR_ORI}
mkdir -p ${TMP_DIR}

cp -rf ${LINUX_HDR}/* ${TMP_DIR_ORI}
echo "#ifndef _UAPI_LINUX_COMPILER_H" >> ${TMP_DIR_ORI}/uapi/linux/compiler.h
echo "#define _UAPI_LINUX_COMPILER_H" >> ${TMP_DIR_ORI}/uapi/linux/compiler.h
echo "#define __user" >> ${TMP_DIR_ORI}/uapi/linux/compiler.h
echo "#endif" >> ${TMP_DIR_ORI}/uapi/linux/compiler.h

pushd ${PRJ_ROOT}
	python kernel/linux/patches/linux-5.10/prebuilts/update_headers.py 2>/dev/null
popd

if [ ! -d ${MUSL_DIR} ]; then
	mkdir -p ${MUSL_DIR}
fi
cp -rf  ${TMP_DIR}/uapi/* ${MUSL_DIR}/
rm -rf ${TMP_DIR_ORI}
rm -rf ${TMP_DIR}
