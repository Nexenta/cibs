# Overview

This is Common [IPS](http://www.oracle.com/technetwork/server-storage/solaris11/technologies/ips-323421.html)
Build System (CIBS). It intend to replace all userland-hell known from OpenSolaris and OpenIndiana.

CIBS is inspired by [Common Debian Build System](http://cdbs-doc.duckcorp.org/en/cdbs-doc.xhtml)

Major features are:

* Makefile-based (need GNU `make`)
* Modular design (include `autotools.mk` for GNU configure, or `cmake.mk` for CMake-based packages)
* Tracking build dependencies
* Building packages independently (no more terrible "consolidations" or "incorporations")


To create and publish an IPS package you need:

* CIBS package installed (`pkg:/developer/pkg/cibs`)
* `Makefile` describing what and how you are building
* At least one canonical IPS manifest.
 
 
Look into directory `examples` for examples.


# Best practices

## Split development file and runtime

In contrast to some crazy distributions (like Solaris or Arch Linux)
we *do* split runtime and development files (as Debian does).

Any shared library should be packaged into separate package reflecting
library's soname, e. g. `library/gmp10` includes libgmp.so.10. Nothing else.
But `library/gmp` includes headers, man pages, maybe static libraries etc. -
anything that required to build applications using GMP. Both packages -
`library/FOO` and `library/FOOxxx` are built from the same source, and
`library/FOO` must depend on `library/FOOxxx` in such a way:

    depend fmri=pkg:/library/FOOxxx@$(ips-version) type=require
    depend fmri=pkg:/library/FOOxxx@$(ips-version) type=incorporate

The trick is that IPS will use `library/FOOxxx` to fulfil runtime
dependencies, and we will be allowed to perform smooth migration
on newer library (e. g. `library/FOOyyy`) without breaking existing
packages. Of course, newer `library/FOO` will depend on `library/FOOyyy`,
but `library/FOOyyy` can be installed along with `library/FOOxxx`.
Again, `library/FOOyyy` and `library/FOOxxx` must be installable together
so none of them can ship docs, man pages or images or anything,
but a shared library itself.

Another example is Node.js or Python. Use `developer/nodejs` and
`runtime/nodejs` package for development files and runtime.
`runtime/nodejs` includes only the binary - `/usr/bin/nodejs` -
and maybe other runtime files, man pages etc.



# CIBS modules

## common.mk

This module defines common variables and targets. All other modules include this module,
and it should not be included directly, unless you are doing something really special.

### Targets provided by common.mk

All targets (but `clean`) provided by this module are abstract and
do nothing.  Other modules extend these targets. Each target has
its annex `target-stamp` which does the real job. Each `*-stamp` is
a file created with `touch` command. All internal dependencies are
implemented through these "stamps", but developer can use basename
for target, e. g. `make unpack` instead of `make unpack-stamp`.

Meaning of these targets depends on other included modules:

* `unpack` - put sources into the source directory (`./work/source` by default),
* `patch` - modify sources,
* `configure` - configure sources, e. g. execute GNU configure or CMake,
* `build` - build sources, e. g. compile with C compiler,
* `install` - install files into proto directory.

Each target in the list above depends on previous target. Yes, except `clean`.

`clean` has a [double-colon rule](http://www.gnu.org/software/make/manual/html_node/Double_002dColon.html)
and by default it is:

    clean::
        rm -f *-stamp
        rm -rf $(workdir)

### Building many variants

`common.mk` defines a macro `add-variant` to extend above targets and  to define
related variables such as `protodir.<variant>`. Calling `$(eval $(call add-variant,FOO))`
will add dependencies to configure-stamp, build-stamp,install-stamp and define
extra variables:

    variants += FOO
    protodir.FOO = $(workdir)/proto/FOO
    builddir.FOO = $(workdir)/build/FOO

    configure-stamp    : configure-FOO-stamp
    build-stamp        : build-FOO-stamp
    install-stamp      : install-FOO-stamp
    %-FOO-stamp: variant = FOO


The `add-variant` macro is used by `32.mk` and `64.mk` modules for
building 32-bit or 64-bit packages.  You may want to use it for any
other purpose, e. g. to compile Curl with OpenSSL or with GNU TLS.
Standard modules, such as `autotools.mk`, take care of every variant defined.
You can tune building by defining variables like `configure-options.FOO`, e. g.:

    $(eval $(call add-variant,ssl))
    $(eval $(call add-variant,gnu))

    configure-options.gnu = --without-ssl --with-gnutls
    configure-options.ssl = --with-ssl --without-gnutls

## autotools.mk

This module defines configure, build and install targets by GNU autotools.
These targets are implicit (e. g. `configure-%-stamp`), and you can completely
override any of them by explicit target (e. g. `configure-foo-stamp`) in the top Makefile.

Variable `configure` holds the name of the configure script ("$(sourcedir)/configure" by default).
You can redefine it if the configure script is not in the top source directory or has a different name.

Use the `configure-options` variable to append or replace options passed to the configure script.
Use the `configure-options.<variant>` to define variant specific options (see above).

Variable `configure-env` holds environment variables for the configure script,
such as CC, CFLAGS, LDFLAGS etc. As usual, you can append or completely replace them.
Use the `configure-env.<variant>` to define variant specific environment variant.

Build and install targets use target-specific variable `target` for invoking `make`.
This variable is empty for `build-%-stamp` and is set to "install" for `install-%-stamp`.
You can redefine it in the top Makefile to build/install only a subset of a package. E. g.
for NCurses with wide character support this will build and install only libraries (without
programs and terminal database):

    $(eval $(call add-variant,wide))
    build-wide-stamp: target = libs
    install-wide-stamp: target = install.libs

Another target-specific variable is "make-vars". The value of this variable
is appended to make command. By default it is set to `V=1`
for `build-%-stamp` (disable silent rules) and to `DESTDIR="$(protodir)"` for
`install-%-stamp`. You can append or completely replace "make-vars" to
make hacks or when you are using autotools.mk for packages which are not
actually use autotools, but some hand-made configure scripts.

## ips.mk

This module provides functions to work with IPS manifests and publish packages.

### Targets provided by ips.mk

* `publish` - publish IPS package into IPS repository
* `pre-publish` - make everything required to publish (including downloading archive,
patching, compiling, mogrifying manifests etc), but do not publish. Usefull for final
verifications what is going into IPS repository. All intermediate and final manifests
are in "work/manifests" directory.
* `build-dep` - install build dependencies

### Variables used by ips.mk

* `ips-repo` - IPS repository to publish, e. g. `make publish ips-repo=http://example.com:1234`

Any variable defined in Makefile will be passed to `pkgmogrify` and 
can be used in IPS manifests (*.p5m). This is especially useful
when with variable `ips-version`, which is by default `= version`.
Example is OpenSSL, where `version = 0.9.8x`, but `ips-version=0.9.8.23`
(because letters are not allowed by IPS).

These variables passed additionally:
`build32` = `#` or empty, and `build64` = `#` or empty. These variables can
be used to cut off some line in package manifest (by commenting out).
By default these vars are `#` (pound).
If module `32.mk` is included, `build32` becomes '' (empty), so lines like:

    $(build32) file path=usr/lib/libfoo.so.1

become uncommented. Same for modules `64.mk`.

Other automatic variables are `protodir.<variant>` and `builddir.<variant>`.
These variables hold paths to corresponding directories used to
install or build package. `<variant>` can be, for example, 32 or 64.
This allow exact specifying which file is requested, e. g.:

    file $(builddir.32)/libfoo.so.1 path=usr/lib/libfoo.so.1

## git.mk

Use this modules to get sources from Git repositories. With this module included
targets `download` and `unpack` mean the same thing - clone git reporitory into
source directory ("work/source"), then checkout given tag, commit or branch.

Makefile should define two variables:

* `git-url` - URL of Git repository, used as `git clone $(git-url) $(sourcedir)`
* `git-checkout` - Git tag, branch or commit; used as `git checkout $(git-checkout)`

For example see "examples/symlinks".

## hg.mk

Same as `git.mk`, but for [Mercurial](http://mercurial.selenic.com/)

Makefile should define two variables:

* `hg-url` - URL of mercurial repository, used as `hg clone $(hg-url) $(sourcedir)`
* `hg-update` - Mercurial tag, branch or commit; used as `hg update $(hg-update)`

## copy.mk

If this module is included, entire source tree will be copied
into all requested building directories. This is useful for
packages that do not support building out of source tree,
such as zlib or openssl.
