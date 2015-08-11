dnl -*- Autoconf -*-
dnl Copyright (C) 1993-2010 Free Software Foundation, Inc.
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.

dnl From Bruno Haible, Marcus Daniels, Sam Steingold.

AC_PREREQ(2.57)

AC_DEFUN([CL_MMAP],
[AC_BEFORE([$0], [CL_MUNMAP])AC_BEFORE([$0], [CL_MPROTECT])
AC_CHECK_HEADER(sys/mman.h, , no_mmap=1)dnl
if test -z "$no_mmap"; then
AC_CHECK_FUNC(mmap, , no_mmap=1)dnl
if test -z "$no_mmap"; then
AC_DEFINE(HAVE_MMAP,,[have <sys/mmap.h> and the mmap() function])
AC_CACHE_CHECK(for working mmap, cl_cv_func_mmap_works, [
case "$host" in
  i[34567]86-*-sysv4*)
    # UNIX_SYSV_UHC_1
    avoid=0x08000000 ;;
  mips-sgi-irix* | mips-dec-ultrix*)
    # UNIX_IRIX, UNIX_DEC_ULTRIX
    avoid=0x10000000 ;;
  rs6000-ibm-aix*)
    # UNIX_AIX
    avoid=0x20000000 ;;
  *)
    avoid=0 ;;
esac
mmap_prog_1='
#include <stdlib.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <fcntl.h>
#include <sys/types.h>
#include <sys/mman.h>
int main () {
'
mmap_prog_2="#define bits_to_avoid $avoid"'
#define my_shift 24
#define my_low   1
#ifdef FOR_SUN4_29
#define my_high  31
#define my_size  32768 /* hope that 32768 is a multiple of the page size */
/* i*32 KB for i=1..31 gives a total of 15.5 MB, which is close to what we need */
#else
#define my_high  64
#define my_size  8192 /* hope that 8192 is a multiple of the page size */
/* i*8 KB for i=1..64 gives a total of 16.25 MB, which is close to what we need */
#endif
#if defined(__APPLE__) && defined(__MACH__) && defined(__x86_64__)
/* On MacOS X in 64-bit mode, mmapable addresses start at 2^33. */
#define base_address 0x200000000UL
#else
#define base_address 0
#endif
 {long i;
#define i_ok(i)  ((i) & (bits_to_avoid >> my_shift) == 0)
  for (i=my_low; i<=my_high; i++)
    if (i_ok(i))
      { caddr_t addr = (caddr_t)(base_address + (i << my_shift));
/* Check for 8 MB, not 16 MB. This is more likely to work on Solaris 2. */
#if bits_to_avoid
        long size = i*my_size;
#else
        long size = ((i+1)/2)*my_size;
#endif
        if (mmap(addr,size,PROT_READ|PROT_WRITE,flags|MAP_FIXED,fd,0) == (void*)-1) exit(1);
    }
#define x(i)  *(unsigned char *) (base_address + (i<<my_shift) + (i*i))
#define y(i)  (unsigned char)((3*i-4)*(7*i+3))
  for (i=my_low; i<=my_high; i++) if (i_ok(i)) { x(i) = y(i); }
  for (i=my_high; i>=my_low; i--) if (i_ok(i)) { if (x(i) != y(i)) exit(1); }
  exit(0);
}}
'
AC_TRY_RUN(GL_NOCRASH[$mmap_prog_1
  int flags = MAP_ANON | MAP_PRIVATE;
  int fd = -1;
  nocrash_init();
$mmap_prog_2
], have_mmap_anon=1
cl_cv_func_mmap_anon=yes, ,
: # When cross-compiling, don't assume anything.
)
AC_TRY_RUN(GL_NOCRASH[$mmap_prog_1
  int flags = MAP_ANONYMOUS | MAP_PRIVATE;
  int fd = -1;
  nocrash_init();
$mmap_prog_2
], have_mmap_anon=1
cl_cv_func_mmap_anonymous=yes, ,
: # When cross-compiling, don't assume anything.
)
AC_TRY_RUN(GL_NOCRASH[$mmap_prog_1
#ifndef MAP_FILE
#define MAP_FILE 0
#endif
  int flags = MAP_FILE | MAP_PRIVATE;
  int fd = open("/dev/zero",O_RDONLY,0666);
  if (fd<0) exit(1);
  nocrash_init();
$mmap_prog_2
], have_mmap_devzero=1
cl_cv_func_mmap_devzero=yes, 
retry_mmap=1,
: # When cross-compiling, don't assume anything.
)
if test -n "$retry_mmap"; then
AC_TRY_RUN(GL_NOCRASH[#define FOR_SUN4_29
$mmap_prog_1
#ifndef MAP_FILE
#define MAP_FILE 0
#endif
  int flags = MAP_FILE | MAP_PRIVATE;
  int fd = open("/dev/zero",O_RDONLY,0666);
  if (fd<0) exit(1);
  nocrash_init();
$mmap_prog_2
], have_mmap_devzero=1
cl_cv_func_mmap_devzero_sun4_29=yes, ,
: # When cross-compiling, don't assume anything.
)
fi
if test -n "$have_mmap_anon" -o -n "$have_mmap_devzero"; then
cl_cv_func_mmap_works=yes
else
cl_cv_func_mmap_works=no
fi
])
if test "$cl_cv_func_mmap_anon" = yes; then
AC_DEFINE(HAVE_MMAP_ANON,,[<sys/mman.h> defines MAP_ANON and mmaping with MAP_ANON works])
fi
if test "$cl_cv_func_mmap_anonymous" = yes; then
AC_DEFINE(HAVE_MMAP_ANONYMOUS,,[<sys/mman.h> defines MAP_ANONYMOUS and mmaping with MAP_ANONYMOUS works])
fi
if test "$cl_cv_func_mmap_devzero" = yes; then
AC_DEFINE(HAVE_MMAP_DEVZERO,,[mmaping of the special device /dev/zero works])
fi
if test "$cl_cv_func_mmap_devzero_sun4_29" = yes; then
AC_DEFINE(HAVE_MMAP_DEVZERO_SUN4_29,,[mmaping of the special device /dev/zero works, but only on addresses < 2^29])
fi
fi
fi
])
