#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license
# at http://www.opensource.org/licenses/CDDL-1.0
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each file.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright (C) 2012, Nexenta Systems, Inc. All rights reserved.
#

# include guard:
ifeq (,$(__common_mk))

# Default:
bits := 32

mach := $(shell uname -p)
mach32 :=
mach64 := amd64

workdir     := $(CURDIR)/work
sourcedir   := $(workdir)/source
destdir.32  := $(workdir)/proto
destdir.64  := $(workdir)/proto
builddir.32 := $(workdir)/build/32
builddir.64 := $(workdir)/build/64

CC.32  = gcc -m32
CC.64  = gcc -m64
CXX.32 = g++ -m32
CXX.64 = g++ -m64

export PATH := \
	/usr/gcc/4.4/bin:/usr/gcc/4.3/bin:/usr/gnu/bin:/usr/sbin:/usr/bin:/sbin

# Define LOCAL_MIRROR in environment, e. g. in ~/.bash_profile:
mirrors := $(LOCAL_MIRROR) \
	http://mirror.yandex.ru/gentoo-distfiles/distfiles \
	http://mirror.ovh.net/gentoo-distfiles/distfiles

prefix = /usr
libdir.32 = $(prefix)/lib/$(mach32)
libdir.64 = $(prefix)/lib/$(mach64)
bindir.32 = $(prefix)/bin/$(mach32)
bindir.64 = $(prefix)/bin/$(mach64)
includedir.32 = /usr/include
includedir.64 = /usr/include

PKG_CONFIG_PATH.32 = /usr/gnu/lib/$(mach32)/pkg-config:/usr/lib/$(mach32)/pkg-config
PKG_CONFIG_PATH.64 = /usr/gnu/lib/$(mach64)/pkg-config:/usr/lib/$(mach.64)/pkg-config
export PKG_CONFIG_PATH = PKG_CONFIG_PATH.$(bits)

# $(bits) are target-specific and defined in 32.mk or 64.mk
bindir     = $(bindir.$(bits))
libdir     = $(libdir.$(bits))
includedir = $(includedir.$(bits))
CC         = $(CC.$(bits))
CXX        = $(CXX.$(bits))
builddir   = $(builddir.$(bits))
destdir    = $(destdir.$(bits))



# Common targets for internal usage.
# Some modules (e. g. 32.mk, autotools.mk) add dependencies
# to this, for example configure with autotools
unpack-stamp patch-stamp pre-configure-stamp configure-stamp build-stamp install-stamp:
	touch $@

# Common target to use from command line
# or in component top-level Makefile:
unpack    :: unpack-stamp
patch     :: patch-stamp
configure :: configure-stamp
build     :: build-stamp
install   :: install-stamp
clean     :: 
	rm -f *-stamp
	rm -rf $(workdir)

__common_mk := included

-include /etc/cibs/cibs.conf

endif
