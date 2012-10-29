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
ifeq (,$(__deb_mk))

include /usr/share/cibs/rules/ips-manifest.mk

debmaker := /usr/share/cibs/scripts/debmaker.pl

DEBVERSION ?= ips

pkg-define += -D COMPONENT_VERSION="$(ips-version)"

debsdir := ./debs

deb-build-depends = \
	$(subst /,-, \
		$(subst pkg:/,,$(build-depends)) \
	)


pre-deb: depend-stamp

deb-stamp: pre-deb
	[ -n "$(debsdir)" ]
	[ -d "$(debsdir)" ] || mkdir -p "$(debsdir)"
	$(root-cmd) $(debmaker) \
		-V "$(DEBVERSION)" \
		-S "$(name)" \
		-O "$(debsdir)" \
		$(pkg-define) \
		$(pkg-protos) \
		$(depend-manifests) \

	touch $@

deb: deb-stamp

check-build-dep-stamp: check-deb-build-dep-stamp

# issue 'make d=' to skip dependency checking:
check-deb-build-dep-stamp: d=true
check-deb-build-dep-stamp:
	@[ -z "$d" ] || [ -z "$(build-depends)" ] || dpkg -l $(deb-build-depends) || \
		(echo "type '$(MAKE) build-dep' to install build dependencies"; \
		echo "or add 'd=' to command, e. g. '$(MAKE) build d='"; \
		false)
	touch $@


# Install build dependencies:
build-dep:
	$(root-cmd) apt-get install $(deb-build-depends)

.PHONY: deb build-dep pre-deb

__deb_mk := included
endif

