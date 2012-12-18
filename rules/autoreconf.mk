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

# include guard
ifeq (,$(__autoreconf_mk))

include $(cibs-root)/rules/common.mk

build-depends += \
	pkg:/developer/build/libtool \
	pkg:/developer/build/autoconf \
	pkg:/developer/build/automake \


autoreconf-stamp: patch-stamp unpack-stamp
	autoreconf -fvi $(dir $(configure))
	touch $@

pre-configure-stamp: autoreconf-stamp

# Public interface (tm)
autoreconf:: autoreconf-stamp	

__autoreconf_mk := included
endif
