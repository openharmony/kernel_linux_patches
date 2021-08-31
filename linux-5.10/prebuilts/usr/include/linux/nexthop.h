/*
 * This header was generated from the Linux kernel headers by update_headers.py,
 * to provide necessary information from kernel to userspace, such as constants,
 * structures, and macros, and thus, contains no copyrightable information.
 */
#ifndef _UAPI_LINUX_NEXTHOP_H
#define _UAPI_LINUX_NEXTHOP_H
#include <linux/types.h>
struct nhmsg {
	unsigned char	nh_family;
	unsigned char	nh_scope;
	unsigned char	nh_protocol;
	unsigned char	resvd;
	unsigned int	nh_flags;
};
struct nexthop_grp {
	__u32	id;
	__u8	weight;
	__u8	resvd1;
	__u16	resvd2;
};
enum {
	NEXTHOP_GRP_TYPE_MPATH,
	__NEXTHOP_GRP_TYPE_MAX,
};
#define NEXTHOP_GRP_TYPE_MAX (__NEXTHOP_GRP_TYPE_MAX - 1)
enum {
	NHA_UNSPEC,
	NHA_ID,
	NHA_GROUP,
	NHA_GROUP_TYPE,

	NHA_BLACKHOLE,

	NHA_OIF,
	NHA_GATEWAY,
	NHA_ENCAP_TYPE,
	NHA_ENCAP,

	NHA_GROUPS,
	NHA_MASTER,
	NHA_FDB,

	__NHA_MAX,
};
#define NHA_MAX	(__NHA_MAX - 1)
#endif
