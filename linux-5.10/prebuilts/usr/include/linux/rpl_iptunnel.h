/*
 * This header was generated from the Linux kernel headers by update_headers.py,
 * to provide necessary information from kernel to userspace, such as constants,
 * structures, and macros, and thus, contains no copyrightable information.
 */
#ifndef _UAPI_LINUX_RPL_IPTUNNEL_H
#define _UAPI_LINUX_RPL_IPTUNNEL_H
enum {
	RPL_IPTUNNEL_UNSPEC,
	RPL_IPTUNNEL_SRH,
	__RPL_IPTUNNEL_MAX,
};
#define RPL_IPTUNNEL_MAX (__RPL_IPTUNNEL_MAX - 1)
#define RPL_IPTUNNEL_SRH_SIZE(srh) (((srh)->hdrlen + 1) << 3)
#endif
