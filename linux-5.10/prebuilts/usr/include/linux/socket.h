/*
 * This header was generated from the Linux kernel headers by update_headers.py,
 * to provide necessary information from kernel to userspace, such as constants,
 * structures, and macros, and thus, contains no copyrightable information.
 */
#ifndef _UAPI_LINUX_SOCKET_H
#define _UAPI_LINUX_SOCKET_H
#define _K_SS_MAXSIZE	128
typedef unsigned short __kernel_sa_family_t;
struct sockaddr_storage {
	union {
		struct {
			__kernel_sa_family_t	ss_family;

			char __data[_K_SS_MAXSIZE - sizeof(unsigned short)];


		};
		void *__align;
	};
};
#endif
