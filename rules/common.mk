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

variants :=

workdir-base := work
workdir   := $(CURDIR)/$(workdir-base)
sourcedir := $(workdir)/source

define add-variant
protodir-base.$1 = $(workdir-base)/proto/$1
builddir-base.$1 = $(workdir-base)/build/$1
protodir.$1 = $(workdir)/proto/$1
builddir.$1 = $(workdir)/build/$1

configure-stamp    : configure-$1-stamp
build-stamp        : build-$1-stamp
install-stamp      : install-$1-stamp

configure-$1-stamp : pre-configure-stamp
build-$1-stamp     : configure-$1-stamp
install-$1-stamp   : build-$1-stamp

variants += $1

%-$1-stamp: variant = $1

endef


CC.32  = gcc -m32
CC.64  = gcc -m64
CXX.32 = g++ -m32
CXX.64 = g++ -m64

export PATH := /usr/bin:/usr/gnu/bin:/usr/sbin:/sbin
export CFLAGS = -O2
export CXXFLAGS = -O2

prefix = /usr
libdir.32 = $(prefix)/lib/$(mach32)
libdir.64 = $(prefix)/lib/$(mach64)
bindir.32 = $(prefix)/bin
bindir.64 = $(prefix)/bin
includedir = /usr/include
libdir.noarch = $(prefix)/lib
bindir.noarch = $(prefix)/bin

PKG_CONFIG_PATH.32 = /usr/gnu/lib/$(mach32)/pkgconfig:/usr/lib/$(mach32)/pkgconfig
PKG_CONFIG_PATH.64 = /usr/gnu/lib/$(mach64)/pkgconfig:/usr/lib/$(mach64)/pkgconfig
export PKG_CONFIG_PATH = PKG_CONFIG_PATH.$(bits)

# $(bits) are target-specific and defined in 32.mk or 64.mk
bindir     = $(bindir.$(bits))
libdir     = $(libdir.$(bits))
CC         = $(CC.$(bits))
CXX        = $(CXX.$(bits))

builddir   = $(builddir.$(variant))
protodir   = $(protodir.$(variant))



# Common targets for internal usage.
# Some modules (e. g. 32.mk, autotools.mk) add dependencies
# to this, for example configure with autotools
check-build-dep-stamp unpack-stamp patch-stamp pre-configure-stamp configure-stamp build-stamp install-stamp:
	touch $@

install-stamp   : build-stamp
build-stamp     : configure-stamp
configure-stamp : pre-configure-stamp
pre-configure-stamp : patch-stamp unpack-stamp
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
	[ -z "$(generated-files)" ] || rm -f $(generated-files)

__common_mk := included

-include /etc/cibs/cibs.conf

endif
