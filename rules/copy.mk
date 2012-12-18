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

ifeq (,$(__copy_mk))

include $(cibs-root)/rules/common.mk

pre-configure-stamp: copy-stamp

.SECONDEXPANSION:
copy-stamp:  $$(addprefix copy-,$$(addsuffix -stamp,$$(variants) $$(variants)))
	touch $@

copy-%-stamp: patch-stamp unpack-stamp	
	@echo "Copying source for \`$*'"
	[ -n "$(builddir.$*)" ]
	[ -d "$(builddir.$*)" ] || mkdir -p "$(builddir.$*)"
	cp -r -p $(sourcedir)/* $(builddir.$*)/
	touch $@

__copy_mk := included

endif

