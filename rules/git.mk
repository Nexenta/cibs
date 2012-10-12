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
ifeq (,$(__git_mk))

protodirs += $(sourcedir)

build-depends += developer/versioning/git

download-stamp: check-build-dep-stamp
unpack-stamp: download-stamp

download-stamp:
	git clone $(git-url) $(sourcedir)
	cd $(sourcedir) && git checkout $(git-checkout)
	touch $@
download: download-stamp

__git_mk := included
endif

