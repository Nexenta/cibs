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

skip := \#

build32 := $(skip)
build64 := $(skip)

# Default:
bits := 64

# Prepended to commands which require root privileges
# May be overriden in /etc/cibs/cibs.conf to, for example, pfexec
root-cmd := sudo

mach := $(shell uname -p)
mach32 :=
mach64 := amd64

define add-variant
destdir.$1 = $(workdir)/proto/$1
builddir.$1 = $(workdir)/build/$1
endef


workdir         := $(CURDIR)/work
sourcedir       := $(workdir)/source
$(eval $(call add-variant,64))

CC.32  = gcc -m32
CC.64  = gcc -m64
CXX.32 = g++ -m32
CXX.64 = g++ -m64

export PATH := /usr/bin:/usr/gnu/bin:/usr/sbin:/sbin
export CFLAGS = -O2

prefix = /usr
libdir.32 = $(prefix)/lib/$(mach32)
libdir.64 = $(prefix)/lib/$(mach64)
bindir.32 = $(prefix)/bin/$(mach32)
bindir.64 = $(prefix)/bin/$(mach64)
includedir.32 = /usr/include
includedir.64 = /usr/include
libdir.noarch = $(prefix)/lib
bindir.noarch = $(prefix)/bin
includedir.noarch = /usr/include

PKG_CONFIG_PATH.32 = /usr/gnu/lib/$(mach32)/pkg-config:/usr/lib/$(mach32)/pkg-config
PKG_CONFIG_PATH.64 = /usr/gnu/lib/$(mach64)/pkg-config:/usr/lib/$(mach64)/pkg-config
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
check-build-dep-stamp unpack-stamp patch-stamp pre-configure-stamp configure-stamp build-stamp install-stamp:
	touch $@

install-stamp   : build-stamp
build-stamp     : configure-stamp
configure-stamp : patch-stamp
patch-stamp     : unpack-stamp
unpack-stamp    : check-build-dep-stamp

# Common target to use from command line
# or in component top-level Makefile:
unpack    : unpack-stamp
patch     : patch-stamp
configure : configure-stamp
build     : build-stamp
install   : install-stamp

# clean is special and can be extended in Makefile:
clean :: 
	rm -f *-stamp
	rm -rf $(workdir)

__common_mk := included

-include /etc/cibs/cibs.conf

endif
