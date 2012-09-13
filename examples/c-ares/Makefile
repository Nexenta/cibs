
# We are going to package for IPS ;-)
include /usr/share/cibs/rules/ips.mk

# We are using tarball(s)
include /usr/share/cibs/rules/archive.mk

# We are using GNU configure
include /usr/share/cibs/rules/autotools.mk

# We will build 32-bit version
include /usr/share/cibs/rules/32.mk

# ... and 64-bit
include /usr/share/cibs/rules/64.mk


summary := C library that performs DNS requests and name resolves asynchronously
license := MIT

# build-depends +=
# build-conflicts +=

home     := http://c-ares.haxx.se
name     := c-ares
version  := 1.9.1
archive  := $(name)-$(version).tar.gz
download := $(home)/download/$(archive)
checksum := \
	sha1:fe41e47f300bfd587b7f552a141ad3bf85437b0f \
	sha256:023f28001f2f839645c8700187391a011198950c73ddd91510c7549d87373936 \
	md5:389db4917a3b58c4ce4ebfe961fd84c4 \
	size:782945

# archives := more.zip tarballs.tar.bz2
# download_more.zip := ftp://...
# download_tarballs.tar.bz2 := https://...
# checksum_more.zip := ...
# checksum_tarballs.tar.bz2 := ...
#
# patch::
# 	autoreconf -vi



