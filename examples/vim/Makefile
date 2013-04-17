package ?= ips
include /usr/share/cibs/rules/$(package).mk
include /usr/share/cibs/rules/hg.mk
bits = 64

license := ViM
license-file := vim.license

hg-url  := https://vim.googlecode.com/hg/
download := $(hg-url)
home    := http://www.vim.org
name    := vim
version := 7.3.905
# hg update $(hg-update)
hg-update := v$(subst .,-,$(version))

build-depends += \
	developer/build/autoconf \
	developer/python \
	library/tinfo


pre-configure-stamp: autoconf-stamp
autoconf-stamp: patch-stamp
	cp $(sourcedir)/src/config.mk.dist $(sourcedir)/src/auto/config.mk
	$(MAKE) -C $(sourcedir)/src autoconf
	$(MAKE) -C $(sourcedir) distclean
	touch $@

$(eval $(call add-variant,basic))
$(eval $(call add-variant,nox))
$(eval $(call add-variant,tiny))

# Clean protodir, because they do not exist, we do not use them,
# and pkg requires them to exist
pkg-protos := -d .

configure-options := \
	--prefix=/usr \
	--mandir='$${prefix}'/share/man \
	--without-local-dir \
	--enable-fail-if-missing \

configure-options.nox := $(configure-options) \
	--without-x --enable-gui=no \
	--enable-pythoninterp \

configure-options.tiny := $(configure-options) \
	--with-features=small \
	--disable-gui \
	--disable-xsmp \
	--disable-xsmp-interact \
	--disable-netbeans \
	--enable-nls \
	--enable-multibyte \
	--enable-acl \

configure-options.basic := $(configure-options.nox) \
	--disable-luainterp \
	--disable-mzschemeinterp \
	--disable-perlinterp \
	--disable-pythoninterp \
	--disable-python3interp \
	--disable-rubyinterp \
	--disable-tclinterp \

d_tmp := work/proto/tmp
d_common := work/proto/vim-common
d_runtime := work/proto/vim-runtime
movefiles := /usr/share/cibs/scripts/movefiles

# We are building in source dir, but within subdirs:
configure-%-stamp: SHADOWDIR=vim-$*
configure-%-stamp:
	$(MAKE) -C $(sourcedir)/src shadow SHADOWDIR=$(SHADOWDIR)
	cd $(sourcedir) && if test -f src/auto/config.cache; then make distclean; fi
	cd $(sourcedir)/src/$(SHADOWDIR) && \
		LDFLAGS="$(LDFLAGS)" CPPFLAGS="$(CPPFLAGS)" CFLAGS="$(CFLAGS)" CC="$(CC)"\
		./configure $(configure-options.$*)
	touch $@

build-%-stamp: SHADOWDIR=vim-$*
build-%-stamp:
	$(MAKE) -C $(sourcedir)/src/$(SHADOWDIR)
	touch $@

install-basic-stamp:
	$(MAKE) -C $(sourcedir)/src/vim-basic DESTDIR=$(topdir)/$(d_tmp) \
	    installvimbin \
	    installtutorbin \
	    installgtutorbin \
	    installruntime \
	    installtools \
	    install-icons \
	    install-languages
	rm -f $(protodir)/usr/bin/vim
	touch $@

install-nox-stamp install-tiny-stamp:
	touch $@

post-install-stamp: vim-common-stamp vim-runtime-stamp
vim-common-stamp: install-stamp
	mkdir -p $(d_common)
	$(movefiles) -s $(d_tmp) -d $(d_common) \
		usr/bin/xxd \
		usr/share/man/man1/xxd.1 \
		usr/share/man/man1/vimdiff.1 \
		usr/share/man/man1/vim.1
	mkdir -p $(d_common)/etc/vim
	mkdir -p $(d_common)/usr/share/vim
	mkdir -p $(d_common)/var/lib/vim/addons
	cp vimrc $(d_common)/etc/vim/vimrc
	ln -sf ../../../etc/vim $(d_common)/usr/share/vim/vimfiles
	ln -sf ../../../etc/vim/vimrc $(d_common)/usr/share/vim/vimrc
	ln -sf vim73 $(d_common)/usr/share/vim/vimcurrent
	ln -sf vim.1 $(d_common)/usr/share/man/man1/rvim.1
	ln -sf vim.1 $(d_common)/usr/share/man/man1/rview.1
	touch $@

vim-runtime-stamp: install-stamp
	mkdir -p $(d_runtime)
	$(movefiles) -s $(d_tmp) -d $(d_runtime) \
		usr/bin/vimtutor \
		usr/share/man/man1/vimtutor.1 \
		usr/share/vim
	touch $@


