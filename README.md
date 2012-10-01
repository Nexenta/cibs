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
 
 
Look into directory "`examples`" for examples.

# CIBS modules

