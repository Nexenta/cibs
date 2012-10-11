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

# CIBS modules

## common.mk

This module defines common variables and targets. All other modules include this module,
and it should not be included directly, unless you are doing something really special.

### Targets provided by common.mk

All targets (but `clean`) provided by this module are abstract and do nothing. Other modules extend
these targets. Each target has its annex `target-stamp` which does
the real job. Each `*-stamp` is a file created with `touch` command. All internal
dependencies are implemented through these "stamps", but developer can use basename
for target, e. g. `make unpack` instead of `make unpack-stamp`.

Meaning of these targets depends on other included modules:

* `unpack` - put sources into the source directory (`./work/source` by default),
* `patch` - modify sources,
* `configure` - configure sources, e. g. execute GNU configure or CMake,
* `build` - build sources, e. g. compile with C compiler,
* `install` - install files into proto directory.
* `clean` - remove all stamps and working directory (`./work` by default)

Each target in the list above depends on previous target. Yes, except `clean`.

`clean` has a [double-colon rule](http://www.gnu.org/software/make/manual/html_node/Double_002dColon.html)
and by default it is:

    clean::
        rm -f *-stamp
        rm -rf $(workdir)


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
can be used in IPS manifests (*.p5m).

## git.mk

Use this modules to get sources from Git repositories. With this module included
targets `download` and `unpack` mean the same thing - clone git reporitory into
source directory ("work/source"), then checkout given tag, commit or branch.

Makefile should define two variables:

* `git-url` - URL of Git repository, used as `git clone $(git-url) $(sourcedir)`
* `git-checkout` - Git tag, branch or commit; used as `git checkout $(git-checkout)`

For example see "examples/symlinks".

