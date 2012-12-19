include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/64.mk

summary := the basic file, shell and text manipulation utilities of the GNU operating system
license := GPL
license-file := COPYING

prefix := /usr/gnu

build-depends += \
	pkg:/compress/xz \
	pkg:/library/gmp


name     := coreutils
home     := http://www.gnu.org/software/$(name)/
version  := 8.20
archive  := $(name)-$(version).tar.xz
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:3d69af8f561fce512538a9fe85f147ff \
    sha1:b120f138758100060333c2ed207ee276dd318980 \
  sha256:dbcb798764827a0f74be738662ecb516705cf520330cd3d7b2640fdffa499eb2 \
    size:5273788
