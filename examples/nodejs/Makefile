include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/patch.mk
include /usr/share/cibs/rules/copy.mk
include /usr/share/cibs/rules/64.mk
# Not autotools, but similar:
include /usr/share/cibs/rules/autotools.mk

# Must run from the current directory:
configure := ./configure

# Flock wrapper even does not return error on failure:
export LINK = $(CXX)

name := nodejs
version := 0.8.15
home := http://nodejs.org
archive := node-v$(version).tar.gz
download := http://nodejs.org/dist/v$(version)/$(archive)
checksum := \
     md5:6cb31180b07475db103e694f65e8bb9b \
    sha1:a7874cde1a87497992f1f8ea0fdaa760f617a94f \
  sha256:1758639c6df3e081fe26585472d0f1961c5703b44ba6c57ecdf66a4c015792b1 \
    size:11867033

summary := event-based server-side javascript engine
license := BSD
license-file := LICENSE

build-depends += \
	library/libv8 \
	library/c-ares \
	library/libev \
	library/openssl

# Node.js configure is a autotools lookalike confuserator:
configure-options := \
	--dest-os=solaris \
	--prefix=/usr \
	--without-npm \
	--shared-v8 \
	--shared-zlib \
	--shared-openssl \
	--no-ssl2

