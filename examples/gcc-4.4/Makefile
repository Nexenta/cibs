include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/patch.mk
include /usr/share/cibs/rules/32.mk

# Clean all flags cause we are building very specific stuff
CFLAGS := -O2
CXXFLAGS := $(CFLAGS)
LDFLAGS :=


build-depends += \
	library/gmp \
	library/mpfr \
	developer/gnu-binutils \
	developer/macro/gnu-m4 \
	text/gawk \
	developer/parser/bison \
	developer/gperf \
	developer/build/autogen \

configure-options += \
--enable-languages='c,c++,fortran' \
--enable-shared \
--enable-ssp \
--enable-static \
--enable-threads=posix \
--enable-tls \
--program-suffix=-4.4 \
--with-as=/usr/gnu/bin/as \
--with-gnu-as \
--with-ld=/usr/bin/ld \
--without-gnu-ld \


home     := http://gcc.gnu.org
name     := gcc
version  := 4.4.7
archive  := $(name)-$(version).tar.bz2
download := http://gcc.parentingamerica.com/releases/$(name)-$(version)/$(archive)
checksum := \
     md5:295709feb4441b04e87dea3f1bab4281 \
    sha1:a6c834b0c2f58583da1d093de7a81a20ede9af75 \
  sha256:5ff75116b8f763fa0fb5621af80fc6fb3ea0f1b1a57520874982f03f26cd607f \
    size:63179340
