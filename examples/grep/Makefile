include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk


summary := GNU grep, egrep and fgrep
license := GPLv3
license-file := COPYING

build-depends += \
	library/pcre \
	compress/xz

prefix := /usr/gnu

name     := grep
home     := http://www.gnu.org/software/$(name)/
version  := 2.14
archive  := $(name)-$(version).tar.xz
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:d4a3f03849d1e17ce56ab76aa5a24cab \
    sha1:fb6ea404a0ef915334ca6212c7b517432ffe193e \
  sha256:e70e801d4fbb16e761654a58ae48bf5020621c95c8e35bd864742577685872e1 \
    size:1195640
