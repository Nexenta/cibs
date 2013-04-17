include /usr/share/cibs/rules/ips.mk
include /usr/share/cibs/rules/autotools.mk
include /usr/share/cibs/rules/archive.mk
include /usr/share/cibs/rules/patch.mk

movefiles := /usr/share/cibs/scripts/movefiles
payload := /usr/share/cibs/scripts/make-payload

$(eval $(call add-variant,default))
%-default-stamp: bits = 64

summary := an interpreted, interactive, object-oriented, extensible programming language
license := Python License
license-file := $(sourcedir)/LICENSE

name     := Python
pyver    := 2.7
version  := 2.7.3
home     := http://www.python.org/
archive  := $(name)-$(version).tar.bz2
download := http://www.python.org/ftp/python/$(version)/$(archive)

PVER := python$(pyver)

checksum-Python-2.7.3.tar.bz2 := \
     md5:c57477edd6d18bd9eeca2f21add73919 \
    sha1:842c4e2aff3f016feea3c6e992c7fa96e49c9aa0 \
  sha256:726457e11cb153adc3f428aaf1901fc561a374c30e5e7da6742c0742a338663c \
    size:11793433

build-depends += \
	compress/bzip2 \
	developer/build/autoconf \
	file/symlinks \
	library/libbz2 \
	library/libdb-5.1 \
	library/libexpat \
	library/libffi \
	library/libgdbm \
	library/libsqlite3 \
	library/ncursesw \
	library/readline \
	library/tinfo \
	library/zlib \
	text/gawk \
	text/help2man \

define __post_configure
	egrep \
	  "^#($$(gawk -v ORS='|' '$$2 ~ /^extension$$/ {print $$1}' debian/PVER-minimal.README.Debian.in)XX)" \
	  $(sourcedir)/Modules/Setup.dist \
	    | sed -e 's/^#//' -e 's/-Wl,-Bdynamic//;s/-Wl,-Bstatic//' \
	    >> $(1)/Modules/Setup.local

	: # unconditionally run makesetup
	cd $(1) && \
	  $(topdir)/$(sourcedir)/Modules/makesetup -c $(topdir)/$(sourcedir)/Modules/config.c.in -s Modules \
	    Modules/Setup.config Modules/Setup.local Modules/Setup
	mv $(1)/config.c $(1)/Modules/

	: # and fix the timestamps
	$(MAKE) -C $(1) Makefile Modules/config.c

	: # apply workaround for missing os.fsync
	sed 's/HAVE_SYNC/HAVE_FSYNC/g' $(1)/pyconfig.h \
		> $(1)/pyconfig.h.new
	touch -r $(1)/pyconfig.h $(1)/pyconfig.h.new
	mv -f $(1)/pyconfig.h.new $(1)/pyconfig.h
endef

pre-configure-stamp: autoconf-stamp
autoconf-stamp: patch-stamp
	cd $(sourcedir) && autoconf
	touch $@

build-default-stamp: post-configure-stamp
post-configure-stamp: configure-default-stamp
	$(call __post_configure,$(builddir))
	touch $@

configure-options += \
	--without-gcc \
	--enable-ipv6 \
	--enable-unicode=ucs4 \
	--with-dbmliborder=bdb:gdbm \
	--with-system-expat \
	--with-system-ffi \
	--enable-shared \

MIN_MODS := $(shell awk '/^  / && $$2 == "module" { print $$1 }' \
		debian/PVER-minimal.README.Debian.in)
MIN_EXTS := $(shell awk '/^  / && $$2 ~ /^extension/ { print $$1 }' \
		debian/PVER-minimal.README.Debian.in)
MIN_BUILTINS := $(shell awk '/^  / && $$2 == "builtin" { print $$1 }' \
		debian/PVER-minimal.README.Debian.in)
MIN_PACKAGES := $(shell awk '/^  / && $$2 == "package" { print $$1 }' \
		debian/PVER-minimal.README.Debian.in)
MIN_ENCODINGS = $(foreach i, \
			$(filter-out \
			  big5% bz2% cp932.py cp949.py cp950.py euc_% \
			  gb% iso2022% johab.py shift_jis% , \
			  $(shell cd $(sourcedir)/Lib/encodings && echo *.py)), \
			encodings/$(i)) \
		 codecs.py stringprep.py

# We install libpython.X.Y.so.* in usual place (libdir),
# but runtime libraries go into the place where python
# looks them for:
install-default-stamp: make-vars += \
	LIBPL=$(prefix)/lib/python$(pyver)/config \
	DESTSHARED=$(prefix)/lib/python$(pyver)/lib-dynload

# Shorter name:
d         := $(protodir.default)
b         := $(builddir.default)
VER       := $(pyver)
scriptdir := usr/lib/python$(VER)
d_min     := work/proto/python-minimal
d_lib     := work/proto/libpython
d_dev     := work/proto/dev-python
d_base    := work/proto/python
libdir    := usr/lib$(lib-suffix.$(bits))

python-minimal.p5m: env += proto=$(d_min)


install-stamp: postinst-stamp
postinst-stamp: install-default-stamp
	gfind $(d) -name '*.py[co]' | gxargs -r rm -f
	gfind $(d)/usr/lib/python$(VER) -name '*_failed*.so' | gxargs -r rm -f
	mv $(d)/$(scriptdir)/_sysconfigdata.py \
		$(d)/$(scriptdir)/_sysconfigdata_nd.py
	cp $(b)/libpython$(pyver).a \
		$(d)/$(libdir)/
	rm $(d)/$(scriptdir)/config/*.a
	ln -sf $(topdir)/$(d)/$(libdir)/libpython$(pyver).a \
		$(d)/$(scriptdir)/config/libpython$(pyver).a
	ln -sf $(topdir)/$(d)/$(libdir)/libpython$(pyver).so \
		$(d)/$(scriptdir)/config/libpython$(pyver).so
	symlinks -c $(d)/$(scriptdir)/config/

	cp -p debian/_sysconfigdata.py $(d)/$(scriptdir)/
	mv $(d)/usr/lib/python$(VER)/site-packages \
		$(d)/usr/lib/python$(VER)/dist-packages
	: # remove files, which are not packaged
	rm -f $(d)/usr/bin/smtpd.py
	rm -rf $(d)/usr/lib/python$(VER)/ctypes/macholib
	rm -f $(d)/usr/lib/pkgconfig/python.pc
	rm -f $(d)/usr/bin/python2{,-config}
	rm -f $(d)/usr/share/man/man1/python2{,-config}.1
	gfind $(d) -name 'wininst*.exe' | gxargs -r rm -f

	: # Symlinks to /usr/bin for some tools
	ln -sf ../lib/python$(VER)/pdb.py $(d)/usr/bin/pdb$(VER)
	: # versioned install only
	rm -f $(d)/usr/bin/python-config
	mv $(d)/usr/bin/pydoc $(d)/usr/bin/pydoc$(VER)
	: # Remove version information from the egg-info file
	mv $(d)/$(scriptdir)/lib-dynload/Python-$(VER)*.egg-info \
		$(d)/$(scriptdir)/lib-dynload/Python-$(VER).egg-info
	cp -p $(sourcedir)/Tools/i18n/pygettext.py $(d)/usr/bin/pygettext$(VER)

	mv $(d)/usr/bin/2to3 $(d)/usr/bin/2to3-$(VER)
	PYTHONPATH=$(d)/$(scriptdir) \
	help2man --no-info --version-string=$(VER) --no-discard-stderr \
	  --name 'Python2 to Python3 converter' \
	$(d)/usr/bin/2to3-$(VER) \
	> $(d)/usr/share/man/man1/2to3-$(VER).1

	: # install runtime/python-minimal:
	mkdir -p $(d_min)
	cd $(d_min) && mkdir -p \
		etc/$(PVER) \
		usr/bin \
		usr/include/$(PVER) \
		usr/share/man/man1 \
		$(scriptdir)/lib-dynload \
		$(scriptdir)/config
	cp sitecustomize.py $(d_min)/etc/python$(pyver)/sitecustomize.py
	ln -sf /etc/python$(pyver)/sitecustomize.py \
		$(d_min)/usr/lib/python$(pyver)/sitecustomize.py
	$(movefiles) -s $(d) -d$(d_min) \
		usr/bin/python$(VER) \
		usr/share/man/man1/python$(VER).1 \
		$(foreach i,$(MIN_MODS),$(scriptdir)/$(i).py) \
		$(foreach i,$(MIN_PACKAGES),$(scriptdir)/$(i)) \
		$(foreach i,$(MIN_ENCODINGS),$(scriptdir)/$(i)) \
		$(scriptdir)/config/Makefile \
		usr/include/$(PVER)/pyconfig.h \
		$(scriptdir)/site.py \
		$(shell cd $(d); for i in $(MIN_EXTS); do \
			test -e $(scriptdir)/lib-dynload/$$i.so \
			  && echo $(scriptdir)/lib-dynload/$$i.so; \
		  done; true)

	: # install libpython:
	mkdir -p $(d_lib)
	$(movefiles) -s $(d) -d $(d_lib) \
		$(libdir)/libpython$(pyver).so.1.0
	ln -sf libpython$(pyver).so.1.0 \
		$(d_lib)/$(libdir)/libpython$(pyver).so.1

	: # install developer/python:
	mkdir -p $(d_dev)
	mkdir -p $(d_dev)/usr/share/man/man1
	$(movefiles) -s $(d) -d $(d_dev) \
		usr/lib/python$(VER)/config \
		usr/include/python$(VER) \
		$(libdir)/libpython$(VER).so \
		$(libdir)/libpython$(VER).a \
		$(libdir)/pkgconfig/python-$(VER).pc \
		usr/bin/python$(VER)-config
	cp -p debian/python-config.1 \
		$(d_dev)/usr/share/man/man1/python$(VER)-config.1

	: # No IDLE:
	rm -rf $(d)/usr/bin/idle* \
		$(d)/usr/lib/python$(VER)/idlelib

	: # No Tk:
	rm -rf \
		$(d)/usr/lib/python$(VER)/lib-dynload/_tkinter.so \
		$(d)/usr/lib/python$(VER)/lib-tk

	: # install runtime/python:
	mkdir -p $(d_base)
	$(movefiles) -s $(d) -d $(d_base) \
		$(scriptdir)/test/{regrtest.py,test_support.py,__init__.py,pystone.py}
	rm -rf $(d)/$(scriptdir)/test
	rm -rf $(d)/$(scriptdir)/ctypes/test
	rm -rf $(d)/$(scriptdir)/bsddb/test
	rm -rf $(d)/$(scriptdir)/email/test
	rm -rf $(d)/$(scriptdir)/json/tests
	rm -rf $(d)/$(scriptdir)/sqlite3/test
	rm -rf $(d)/$(scriptdir)/distutils/tests
	rm -rf $(d)/$(scriptdir)/lib2to3/tests
	rm -rf $(d)/$(scriptdir)/unittest/test
	rm -rf $(d)/$(scriptdir)/lib-tk/test
	$(movefiles) -s $(d) -d $(d_base) \
		$(scriptdir)

	touch $@

