#!/bin/sh
# Copyright (c) 2026 HiSilicon (Shanghai) Technologies Co., Ltd.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see
# <https://www.gnu.org/licenses/>.

patch_dir=${1}
echo "${patch_dir}: ${1}"
echo "Current directory $(pwd)"
echo "patching aifly begin..."

# Apply patch idempotently: skip if already applied, fail on real conflicts.
apply_patch() {
	patch_file="$1"
	name=$(basename "${patch_file}")

	if patch -p1 --dry-run < "${patch_file}" >/dev/null 2>&1; then
		patch -p1 < "${patch_file}" || exit 1
		echo "Applied: ${name}"
	elif patch -p1 --dry-run -R < "${patch_file}" >/dev/null 2>&1; then
		echo "Already applied, skipping: ${name}"
	else
		echo "Failed to apply patch: ${name}" >&2
		exit 1
	fi
}

# DTC resolves <dt-bindings/...> only under scripts/dtc/include-prefixes.
# Vendor patches add new headers under include/dt-bindings; hardlink any
# missing files into the DTC include tree.
sync_dt_bindings() {
	src_root="include/dt-bindings"
	dtc_root="scripts/dtc/include-prefixes/dt-bindings"

	[ -d "${src_root}" ] || return 0

	find "${src_root}" -type f | while read -r src; do
		rel="${src#${src_root}/}"
		dst="${dtc_root}/${rel}"
		[ -e "${dst}" ] && continue
		mkdir -p "$(dirname "${dst}")"
		ln "${src}" "${dst}"
	done
}

apply_patch "${patch_dir}/0001-kernel-hispark_aifly.patch"
apply_patch "${patch_dir}/0002-kernel-compile-support.patch"
apply_patch "${patch_dir}/0003-kernel-drm.patch"
apply_patch "${patch_dir}/0004-kernel-vo.patch"
apply_patch "${patch_dir}/0005-kernel-dhcp-support.patch"
apply_patch "${patch_dir}/0006-kernel-mipi-support.patch"
apply_patch "${patch_dir}/0007-kernel-nca9555.patch"
apply_patch "${patch_dir}/0008-power-key-dts.patch"
sync_dt_bindings
echo "patching aifly finished..."
