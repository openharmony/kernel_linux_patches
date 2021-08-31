/*
 * This header was generated from the Linux kernel headers by update_headers.py,
 * to provide necessary information from kernel to userspace, such as constants,
 * structures, and macros, and thus, contains no copyrightable information.
 */
#ifndef _UAPI_LINUX_VIRTIO_PMEM_H
#define _UAPI_LINUX_VIRTIO_PMEM_H
#include <linux/types.h>
#include <linux/virtio_ids.h>
#include <linux/virtio_config.h>
struct virtio_pmem_config {
	__le64 start;
	__le64 size;
};
#define VIRTIO_PMEM_REQ_TYPE_FLUSH      0
struct virtio_pmem_resp {

	__le32 ret;
};
struct virtio_pmem_req {

	__le32 type;
};
#endif
