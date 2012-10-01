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
* Makefile describing what and how you are building
* At least one canonical IPS manifest.
 
 
Look into directory `examples` for examples.

# CIBS modules

## ips.mk

This module provides functions to work with IPS manifests and publish packages.
When `ips.mk` modules is included these targets are available from main `Makefile`:

* `publish` - publish IPS package into IPS repository
* `pre-publish` - make everything required to publish (including downloading archive,
patching, compiling, mogrifying manifests etc), but do not publish. Usefull for final
verifications what is going into IPS repository. All intermediate and final manifests
are in `work/manifests` directory.
* `build-dep` - install build dependencies


Any variable defined in `Makefile` will be passed to `pkgmogrify`, for example:

`pkgmogrify -Darchive="mpfr-3.1.1.tar.xz" -Ddownload="http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.1.tar.xz" -Dhome="http://www.mpfr.org/" -Dlicense="LGPLv3" -Dname="mpfr" -Dsummary="GNU library for multiple-precision floating-point computations with correct rounding" -Dversion="3.1.1" ...`
