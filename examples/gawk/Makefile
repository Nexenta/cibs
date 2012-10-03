include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk

summary := GNU implementation of the traditional Unix macro processor
license := GPL
license-file := COPYING

build-depends += \
	pkg:/library/libsigsegv \
	pkg:/library/readline \
	pkg:/compress/xz


name     := gawk
home     := http://www.gnu.org/software/$(name)/
version  := 4.0.1
archive  := $(name)-$(version).tar.xz
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:a601b032c39cd982f34272664f8afa49 \
    sha1:9be956d124e0c0794836055846aea78d2dc547ad \
  sha256:ae0cb9a0ac80686df316fcd126d0da7d1fb6a0acfe043320511c1f212f2ecb47 \
    size:1612448
