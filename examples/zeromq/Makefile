include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
#include /usr/share/cibs/rules/patch.mk
#include /usr/share/cibs/rules/autoreconf.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk
include /usr/share/cibs/rules/64.mk


summary := The ZeroMQ messaging library
license := LGPL
license-file := COPYING.LESSER

build-depends += \
	pkg:/library/libpgm	

#/usr/gcc/4.3/bin/gcc -m32 -luuid   -o test
#ld: warning: file libdladm.so.1: required by /usr/lib/libdlpi.so.1, not found
configure-env += LDFLAGS="-L/lib"

configure-options += --with-system-pgm

home     := http://www.zeromq.org
name     := zeromq
version  := 2.2.0
archive  := $(name)-$(version).tar.gz
download := http://download.zeromq.org/$(archive)
checksum := \
     md5:1b11aae09b19d18276d0717b2ea288f6 \
    sha1:e4bc024c33d3e62f658640625e061ce4e8bd1ff1 \
  sha256:43904aeb9ea6844f72ca02e4e53bf1d481a1a0264e64979da761464e88604637 \
    size:1900378
