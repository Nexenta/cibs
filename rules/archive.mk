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
ifeq (,$(__archive_mk))

.SECONDEXPANSION:

archive-validator := /usr/share/cibs/scripts/validate-archive
validate-%-stamp: download-%-stamp
	if [ -n "$(checksum_$*)" ]; then \
		$(archive-validator) $* $(checksum_$*) ; \
	elif [ -n "$(checksum)" ]; then \
		$(archive-validator) $* $(checksum) ; \
	else \
		echo "** ERROR: No checksum given" >&2; false ; \
	fi
	touch $@

validate-stamp: $$(addprefix validate-,$$(addsuffix -stamp,$$(archives) $$(archive)))
	touch $@
validate: validate-stamp


archive-downloader := /usr/share/cibs/scripts/download-archive
download-%-stamp:
	[ -f "$*" ] || $(archive-downloader) "$*" $(download_$*) $(download)
	touch $@

download-stamp: $$(addprefix download-,$$(addsuffix -stamp,$$(archives) $$(archive)))
	touch $@
download: download-stamp


archive-unpacker := /usr/share/cibs/scripts/unpack-archive
unpack-%-stamp: validate-%-stamp check-build-dep-stamp
	$(archive-unpacker) $* $(sourcedir_$*) $(sourcedir)
	touch $@

unpack-stamp: $$(addprefix unpack-,$$(addsuffix -stamp,$$(archives) $$(archive)))
pre-configure-stamp: unpack-stamp check-build-dep-stamp

checksum: download-stamp
	@echo '# Insert this into Makefile:'
	@echo 'checksum := \'
	@printf "     md5:"; md5sum "$(archive)" | awk '{print $$1 " \\"}'
	@printf "    sha1:"; sha1sum "$(archive)" | awk '{print $$1 " \\"}'
	@printf "  sha256:"; sha256sum "$(archive)" | awk '{print $$1 " \\"}'
	@printf "    size:"; stat -c '%s' "$(archive)"

__archive_mk := included
endif

