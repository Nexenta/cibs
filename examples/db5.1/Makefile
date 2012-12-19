include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/32.mk
include /usr/share/cibs/rules/64.mk
include /usr/share/cibs/rules/autotools.mk

db-ver := 5.1

summary := Berkeley Database v$(db-ver)
license := BSD
license-file := LICENSE

build-depends += \

configure-options += \
	--enable-cxx \
	--enable-compat185 \
	--enable-sql \
	--enable-stl


configure = $(sourcedir)/dist/configure

name     := db
home     := http://www.oracle.com/technetwork/products/berkeleydb
version  := $(db-ver).29
archive  := $(name)-$(version).tar.gz
download := http://download.oracle.com/berkeley-db/$(archive)
checksum := \
     md5:a94ea755ab695bc04f82b94d2e24a1ef \
    sha1:42dc96c71873c7fde543c916ed866cadee6fa51d \
  sha256:a943cb4920e62df71de1069ddca486d408f6d7a09ddbbb5637afe7a229389182 \
    size:32188074
