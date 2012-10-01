include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk
include /usr/share/cibs/rules/64.mk

summary := handling page faults in user mode
license := GPL
license-file := COPYING


configure-options += --enable-shared

name     := libsigsegv
home     := http://www.gnu.org/software/$(name)/
version  := 2.10
archive  := $(name)-$(version).tar.gz
download := http://ftp.gnu.org/gnu/$(name)/$(archive)
checksum := \
     md5:7f96fb1f65b3b8cbc1582fb7be774f0f \
    sha1:b75a647a9ebda70e7a3b33583efdd550e0eac094 \
  sha256:8460a4a3dd4954c3d96d7a4f5dd5bc4d9b76f5754196aa245287553b26d2199a \
    size:402279
