RELEASE_DATE := "22-September-2014"

RELEASE ?= 2.2.1
VERSION ?= 0
RELEASE_NAME ?= dkms
RELEASE_VERSION ?= $(RELEASE).$(VERSION)
RELEASE_STRING ?= $(RELEASE_NAME)-$(RELEASE_VERSION)
DIST ?= unstable
SHELL=bash

#Define the top-level build directory
TOPDIR ?= $(shell pwd)/
BUILD_DIR ?= $(shell readlink -f $(TOPDIR)../build)
ARTIFACTS_DIR ?= $(shell readlink -f $(TOPDIR)../artifacts)
ARCHIVE_DIR ?= $(shell readlink -f $(TOPDIR)../archive)

DESTDIR ?= $(BUILD_DIR)

SBIN = $(DESTDIR)/usr/sbin
ETC = $(DESTDIR)/etc/dkms
VAR = $(DESTDIR)/var/lib/dkms
MAN = $(DESTDIR)/usr/share/man/man8
INITD = $(DESTDIR)/etc/rc.d/init.d
LIBDIR = $(DESTDIR)/usr/lib/dkms
BASHDIR = $(DESTDIR)/etc/bash_completion.d
KCONF = $(DESTDIR)/etc/kernel
SHAREDIR = $(DESTDIR)/usr/share
DOCDIR = $(SHAREDIR)/doc/dkms
SYSTEMD = $(DESTDIR)/etc/systemd/system
