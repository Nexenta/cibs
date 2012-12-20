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
ifeq (,$(__autotools_mk))

include $(cibs-root)/rules/common.mk


configure := $(sourcedir)/configure
configure-env = \
	CC="$(CC)" \
	CXX="$(CXX)" \
	CFLAGS="$(CFLAGS)" \
	CXXFLAGS="$(CXXFLAGS)" \
	CPPFLAGS="$(CPPFLAGS)" \
	$(configure-env.$(variant)) \


configure-options = \
	--prefix="$(prefix)" \
	--libdir="$(libdir)" \
	--bindir="$(bindir)" \
	--includedir=\$${prefix}/include \
	--infodir=/usr/share/info \
	--mandir=\$${prefix}/share/man \
	--localstatedir=/var \
	$(configure-options.$(variant)) \


configure-%-stamp:
	[ -d "$(builddir)" ] || mkdir -p "$(builddir)"
	cd "$(builddir)" && \
		env $(configure-env) \
		$(configure) $(configure-options)
	touch $@

build-%-stamp: target =
build-%-stamp: make-vars = V=1
build-%-stamp:
	cd "$(builddir)" && $(MAKE) $(make-jobs:%=-j%) $(target) $(make-vars)
	touch $@

install-%-stamp: target = install
install-%-stamp: make-vars = DESTDIR="$(protodir)"
install-%-stamp:
	cd "$(builddir)" && $(MAKE) $(target) $(make-vars)
	touch $@


__autotools_mk := included
endif
