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

include $(cibs-root)/rules/common.mk

manifestdir := $(workdir)/manifest
transdir := $(cibs-root)/trans

# Default, can be overriden in Makefile. See next lines.
ips-version = $(version)

# Substitutions in IPS manifest:
makefile-vars := $(shell sed -n 's/^ *\([a-zA-Z][-_0-9a-zA-Z]*\) *[:?]*=.*$$/\1/p' Makefile | sort -u)
pkg-define += $(foreach _,$(makefile-vars),-D $(_)="$($(_))")
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
# file $(protodir.64)/usr/include/header.h path=usr/include/header.64.h
pkg-define += $(foreach _,$(variants),-D protodir.$(_)="$(protodir.$(_))")

# Same for $(builddir.xxx):
pkg-define += $(foreach _,$(variants),-D builddir.$(_)="$(builddir.$(_))")

pkg-define += -D sourcedir="$(sourcedir)"

protodirs += $(foreach _,$(variants),$(protodir.$(_)))

transformations := \
$(transdir)/defaults \
$(transdir)/actuators \
$(transdir)/docs \
$(transdir)/locale \
$(transdir)/arch \




# Manifest generators:
manifests-x := $(wildcard *.p5m.x)
ifneq (,$(manifests-x))
$(warning *.p5m.x files are deprecated because of similarity to RPCGEN sources)
manifests-generated += $(manifests-x:%.x=%)
endif
manifests-gen := $(wildcard *.p5m.gen)
ifneq (,$(manifests-gen))
manifests-generated += $(manifests-gen:%.gen=%)
endif
%.p5m: post-install-stamp
%.p5m: %.p5m.gen
	(echo '# This file was generated by "$<"' > "$@" && \
	env $(env) "./$<" >> "$@") || rm "$@"
%.p5m: %.p5m.x
	(echo '# This file was generated by "$<"' > "$@" && \
	env $(env) "./$<" >> "$@") || rm "$@"

manifests-m4 := $(wildcard *.p5m.m4)
ifneq (,$(manifests-m4))
build-depends += gnu-m4
manifests-generated += $(manifests-m4:%.m4=%)
endif
%.p5m: %.p5m.m4
	echo '# This file was generated from $<' > $@
	gm4 $< >> $@

ifneq (,$(manifests-generated))
manifests += $(manifests-generated)
generated-files += $(manifests-generated)
endif

# Supplied canonical manifests:
manifests := $(filter-out $(manifests-generated),$(wildcard *.p5m))

manifests += $(manifests-generated)

$(manifests-generated): post-install-stamp

#TODO: Expand "glob" action in manifests:
globalizator := $(cibs-root)/scripts/globalizator
glob-manifests := $(manifests:%=$(manifestdir)/glob-%)
$(glob-manifests): $(manifestdir)/glob-% : %
	[ -d "$(manifestdir)" ] || mkdir -p "$(manifestdir)"
	cp $< $@
glob-stamp: $(glob-manifests)
	touch $@


mogrified-manifests := $(manifests:%=$(manifestdir)/mogrified-%)
$(manifestdir)/mogrified-% : $(manifestdir)/glob-%
	pkgmogrify $(pkg-define) -I. \
		$(transformations) \
		$< | \
		sed -e '/^$$/d' -e '/^#.*$$/d' | uniq > $@ || (rm -f $@; exit 1)
mogrify-stamp: $(mogrified-manifests)	
	touch $@


depend-manifests := $(manifests:%=$(manifestdir)/depend-%)
$(manifestdir)/depend-% : $(manifestdir)/mogrified-%
	@protos="-d ."; for p in $(protodirs); do \
		   if [ -d $$p ]; then protos="$$protos -d $$p"; fi \
		   done; \
	   set -x; \
		pkgdepend generate -m $$protos $< > $@ || (rm -f $@; exit 1)
depend-stamp: $(depend-manifests)	
	touch $@
$(depend-manifests): install-stamp	

__ips_manifest_mk := included
endif

