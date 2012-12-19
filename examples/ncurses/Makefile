include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/patch.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/32.mk
include /usr/share/cibs/rules/64.mk

summary := The new curses library
license := MIT, BSD
license-file := ncurses.license

name     := ncurses
home     := http://invisible-island.net/$(name)
version  := 5.9
archive  := $(name)-$(version).tar.gz
download := ftp://invisible-island.net/$(name)/$(archive)
checksum := \
     md5:8cb9c412e5f2d96bc6f459aa8c6282a1 \
    sha1:3e042e5f2c7223bffdaac9646a533b8c758b65b5 \
  sha256:9046298fb440324c9d4135ecea7879ffed8546dd1b58e59430ea07a4633f563b \
    size:2826473

configure-options += \
	--with-shared \
	--without-profile \
	--without-debug \
	--disable-rpath \
	--enable-echo \
	--enable-const \
	--enable-pc-files \
	--without-ada \
	--without-tests \
	--enable-symlinks \
	--disable-lp64 \
	--with-chtype='long' \
	--with-mmask-t='long' \
	--disable-termcap \
	--with-default-terminfo-dir=/etc/terminfo \
	--with-terminfo-dirs="/etc/terminfo:/lib/terminfo:/usr/share/terminfo" \
	--with-ticlib=tic \
	--with-termlib=tinfo

configure-env.32 = \
	PKG_CONFIG_LIBDIR="$(libdir.32)/pkgconfig"
configure-options.32 = \
	--without-manpages \
	--without-progs

# We need only 32-bit libs:
build-32-stamp: target = libs
install-32-stamp: target = install.libs

configure-env.64 = \
	PKG_CONFIG_LIBDIR="$(libdir.64)/pkgconfig"
configure-options.64 = \
	--with-progs


# Variant with wide-character support.
# 64-bit only
$(eval $(call add-variant,wide))
%-wide-stamp: bits = 64
configure-options.wide = \
	--enable-widec \
	--disable-overwrite \

# We need only libs:
build-wide-stamp: target = libs
install-wide-stamp: target = install.libs

