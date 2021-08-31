/*
 * This header was generated from the Linux kernel headers by update_headers.py,
 * to provide necessary information from kernel to userspace, such as constants,
 * structures, and macros, and thus, contains no copyrightable information.
 */
#ifndef __INCLUDE_UAPI_SOUND_SOF_USER_HEADER_H__
#define __INCLUDE_UAPI_SOUND_SOF_USER_HEADER_H__
#include <linux/types.h>
struct sof_abi_hdr {
	__u32 magic;
	__u32 type;
	__u32 size;
	__u32 abi;
	__u32 reserved[4];
	__u32 data[0];
}  __packed;
#endif
