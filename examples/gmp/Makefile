include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk
include /usr/share/cibs/rules/64.mk

summary := GNU library for arbitrary precision arithmetic
license := LGPLv3
license-file := COPYING.LIB

build-depends += \
	pkg:/developer/macro/gnu-m4

configure-options += --enable-cxx

# http://gmplib.org/manual/ABI-and-ISA.html
configure-options.32 += ABI=32

name     := gmp
home     := http://www.gnu.org/software/$(name)/
version  := 5.0.5
archive  := $(name)-$(version).tar.bz2
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:041487d25e9c230b0c42b106361055fe \
    sha1:12a662456033e21aed3e318aef4177f4000afe3b \
  sha256:1f588aaccc41bb9aed946f9fe38521c26d8b290d003c5df807f65690f2aadec9 \
    size:2052144
