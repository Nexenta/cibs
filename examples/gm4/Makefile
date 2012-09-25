include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
#include /usr/share/cibs/rules/autoreconf.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk

summary := GNU implementation of the traditional Unix macro processor
license := GPL
license-file := COPYING

prefix := /usr/gnu

build-depends += \
	pkg:/library/libsigsegv


home     := http://www.gnu.org/software/m4/
name     := m4
version  := 1.4.16
archive  := $(name)-$(version).tar.bz2
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:8a7cef47fecab6272eb86a6be6363b2f \
    sha1:0390c77780ab4cd65b07fe4e2d23e4e39769f967 \
  sha256:42500c1fddd90bcb161e6b58de931d769929c495c124112d67428a23543db90c \
    size:1258362
