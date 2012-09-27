include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk
include /usr/share/cibs/rules/64.mk

summary := GNU library for multiple-precision floating-point computations with correct rounding
license := LGPLv3
license-file := COPYING.LESSER

build-depends += \
	pkg:/library/gmp \
	pkg:/compress/xz \

name     := mpfr
home     := http://www.mpfr.org/
version  := 3.1.1
archive  := $(name)-$(version).tar.xz
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:91d51c41fcf2799e4ee7a7126fc95c17 \
    sha1:7527c322b91fe8e6055ead551e1b46b9f1712ccd \
  sha256:49d5acc32dbeec30a8e26af9c19845763d63feacb8bf97b12876008419f5a17a \
    size:1071688
