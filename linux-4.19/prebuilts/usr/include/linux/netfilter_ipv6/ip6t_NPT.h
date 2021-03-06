/*
 * This header was generated from the Linux kernel headers by update_headers.py,
 * to provide necessary information from kernel to userspace, such as constants,
 * structures, and macros, and thus, contains no copyrightable information.
 */
#ifndef __NETFILTER_IP6T_NPT
#define __NETFILTER_IP6T_NPT
#include <linux/types.h>
#include <linux/netfilter.h>
struct ip6t_npt_tginfo {
	union nf_inet_addr	src_pfx;
	union nf_inet_addr	dst_pfx;
	__u8			src_pfx_len;
	__u8			dst_pfx_len;

	__sum16			adjustment;
};
#endif
