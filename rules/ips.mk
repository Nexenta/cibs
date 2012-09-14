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
ifeq (,$(__ips_mk))

include /usr/share/cibs/rules/common.mk

manifestdir := $(workdir)/manifest
transdir := /usr/share/cibs/trans

ifeq (,$(ips_version))
ips_version = $(version)
endif

# Substitutions in IPS manifest:
# XXX What about to grep all variables from component makefile?
pkg-define = \
-Dsummary="$(summary)" \
-Dlicense="$(license)" \
-Dlicense-file="$(license-file)" \
-Dhome="$(home)" \
-Dname="$(name)" \
-Dversion="$(version)" \
-Dips_version="$(ips_version)" \
-Darchive="$(archive)" \
-Ddownload="$(download)" \
-Dchecksum="$(checksum)" \
 
pkg-define += \
-DMACH="$(mach)" \
-DMACH32="$(mach32)" \
-DMACH64="$(mach64)" \


# Where to find files:
pkg-protos = \
-d "$(destdir)" \
-d "$(sourcedir)" \
-d . \

transformations := \
$(transdir)/defaults \
$(transdir)/actuators \
$(transdir)/devel \
$(transdir)/docs \
$(transdir)/locale \



# Supplied canonical manifests:
manifests := $(wildcard *.p5m)

#TODO: Expand "glob" action in manifests:
globalizator := /usr/share/cibs/scripts/globalizator
glob-manifests := $(manifests:%=$(manifestdir)/glob-%)
$(glob-manifests): $(manifestdir)/glob-% : %
	[ -d "$(manifestdir)" ] || mkdir -p "$(manifestdir)"
	cp $< $@
glob-stamp: $(glob-manifests)
	touch $@


mogrified-manifests := $(manifests:%=$(manifestdir)/mogrified-%)
$(manifestdir)/mogrified-% : $(manifestdir)/glob-%
	pkgmogrify $(pkg-define) \
		$(transformations) \
		$< | \
		sed -e '/^$$/d' -e '/^#.*$$/d' | uniq > $@ || (rm -f $@; false)
mogrify-stamp: $(mogrified-manifests)	
	touch $@


depend-manifests := $(manifests:%=$(manifestdir)/depend-%)
$(manifestdir)/depend-% : $(manifestdir)/mogrified-%
	pkgdepend generate -m $(pkg-protos) $< > $@ || (rm -f $@; false)
depend-stamp: $(depend-manifests)	
	touch $@
$(depend-manifests): install-stamp	

res_suffix := resolved
resolved-manifests := $(manifests:%=$(manifestdir)/depend-%.$(res_suffix))
$(resolved-manifests): $(depend-manifests)	
	pkgdepend resolve -m -s $(res_suffix) $(depend-manifests)
resolve-stamp: $(resolved-manifests)
	touch $@


# For convenience - make all, before publishing
pre-publish: resolve-stamp

publish-stamp: pre-publish
	@if [ -n "$(ips-repo)" ]; then \
	set -x; \
	pkgsend -s $(ips-repo) publish --fmri-in-manifest \
		$(pkg-protos) \
		$(resolved-manifests) && \
	touch $@; \
	else \
	echo "Variable 'ips-repo' is not defined."; \
	echo "Set either in config file /etc/cibs/cibs.conf,"; \
	echo "or define in command line: $(MAKE) publish ips-repo="; \
	false; \
	fi

publish: publish-stamp


check-build-dep-stamp: check-ips-build-dep-stamp

# issue 'make d=' to skip dependency checking:
check-ips-build-dep-stamp: d=true
check-ips-build-dep-stamp:
	@[ -z "$d" ] || [ -z "$(build-depends)" ] || pkg list $(build-depends) || \
		(echo "type '$(MAKE) build-dep' to install build dependencies"; \
		echo "or add 'd=' to command, e. g. '$(MAKE) build d='"; \
		false)
	touch $@


# Install build dependencies:
build-dep:
	$(root) pkg install $(build-depends)

.PHONY: publish build-dep pre-publish

__ips_mk := included
endif

