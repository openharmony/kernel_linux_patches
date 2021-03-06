/*
 * This header was generated from the Linux kernel headers by update_headers.py,
 * to provide necessary information from kernel to userspace, such as constants,
 * structures, and macros, and thus, contains no copyrightable information.
 */
#ifndef LINUX_ATM_NICSTAR_H
#define LINUX_ATM_NICSTAR_H
#include <linux/atmapi.h>
#include <linux/atmioc.h>
#define NS_GETPSTAT	_IOWR('a',ATMIOC_SARPRV+1,struct atmif_sioc)

#define NS_SETBUFLEV	_IOW('a',ATMIOC_SARPRV+2,struct atmif_sioc)

#define NS_ADJBUFLEV	_IO('a',ATMIOC_SARPRV+3)

typedef struct buf_nr
{
   unsigned min;
   unsigned init;
   unsigned max;
}buf_nr;
typedef struct pool_levels
{
   int buftype;
   int count;
   buf_nr level;
} pool_levels;
#define NS_BUFTYPE_SMALL 1
#define NS_BUFTYPE_LARGE 2
#define NS_BUFTYPE_HUGE 3
#define NS_BUFTYPE_IOVEC 4
#endif
