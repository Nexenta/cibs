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
ifeq (,$(__ips_manifest_mk))

include /usr/share/cibs/rules/common.mk

manifestdir := $(workdir)/manifest
transdir := /usr/share/cibs/trans

# Default, can be overriden in Makefile. See next lines.
ips-version = $(version)

# Substitutions in IPS manifest:
makefile-vars := $(shell sed -n 's/^ *\([a-zA-Z][-_0-9a-zA-Z]*\) *[:?]*=.*$$/\1/p' Makefile | sort -u)
pkg-define = $(foreach _,$(makefile-vars),-D $(_)="$($(_))")
pkg-define += -D ips-version="$(ips-version)"	

 
pkg-define += \
-D MACH="$(mach)" \
-D MACH32="$(mach32)" \
-D MACH64="$(mach64)" \
-D mach="$(mach)" \
-D mach32="$(mach32)" \
-D mach64="$(mach64)" \
-D build32="$(build32)" \
-D build64="$(build64)" \

# Add $(protodir.<variant>) to use in manifest:
# file $(protodir.64) path=usr/include/header.64.h
pkg-define += $(foreach _,$(variants),-D protodir.$(_)="$(protodir-base.$(_))")

# Same for $(builddir.xxx):
pkg-define += $(foreach _,$(variants),-D builddir.$(_)="$(builddir-base.$(_))")

# Where to find files:
pkg-protos = $(foreach _,$(variants),-d "$(protodir.$(_))")
pkg-protos += -d "$(sourcedir)"
pkg-protos += -d .

transformations := \
$(transdir)/defaults \
$(transdir)/actuators \
$(transdir)/devel \
$(transdir)/docs \
$(transdir)/locale \
$(transdir)/arch \



# Supplied canonical manifests:
manifests := $(wildcard *.p5m)

# Manifest generators:
manifests-x := $(wildcard *.p5m.x)
manifests += $(manifests-x:%.x=%)
%.p5m: %.p5m.x
	./$< > $@

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

__ips_manifest_mk := included
endif

