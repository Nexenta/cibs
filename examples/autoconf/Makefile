include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/noarch.mk


summary := GNU utilities for finding files
license := GPLv3
license-file := COPYINGv3

build-depends += \
	compress/xz

configure-env += M4=/usr/gnu/bin/m4

name     := autoconf
home     := http://www.gnu.org/software/$(name)/
version  := 2.69
archive  := $(name)-$(version).tar.xz
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:50f97f4159805e374639a73e2636f22e \
    sha1:e891c3193029775e83e0534ac0ee0c4c711f6d23 \
  sha256:64ebcec9f8ac5b2487125a86a7760d2591ac9e1d3dbd59489633f9de62a57684 \
    size:1214744
