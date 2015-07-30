include config.mk

.PHONY = tarball

all: clean tarball rpm debs

clean:
	rm -rf $(BUILD_DIR)/* $(ARTIFACTS_DIR)/* $(ARCHIVE_DIR)/*
install:
	mkdir -m 0755 -p $(VAR) $(SBIN) $(MAN) $(ETC) $(BASHDIR) $(SHAREDIR) $(LIBDIR)
	sed -e "s/\[INSERT_VERSION_HERE\]/$(RELEASE_VERSION)/" dkms > dkms.versioned
	mv -f dkms.versioned dkms
	install -p -m 0755 dkms_common.postinst $(LIBDIR)/common.postinst
	install -p -m 0755 dkms $(SBIN)
	install -p -m 0755 dkms_autoinstaller $(LIBDIR)
	install -p -m 0644 dkms_framework.conf $(ETC)/framework.conf
	install -p -m 0644 dkms_dbversion $(VAR)
	install -p -m 0644 dkms.bash-completion $(BASHDIR)/dkms
	# install compressed manpage with proper timestamp and permissions
	gzip -c -9 dkms.8 > $(MAN)/dkms.8.gz
	chmod 0644 $(MAN)/dkms.8.gz
	touch --reference=dkms.8 $(MAN)/dkms.8.gz
	mkdir   -p -m 0755 $(KCONF)/prerm.d $(KCONF)/postinst.d
	install -p -m 0755 kernel_prerm.d_dkms  $(KCONF)/prerm.d/dkms
	install -p -m 0755 kernel_postinst.d_dkms $(KCONF)/postinst.d/dkms

DOCFILES=sample.spec sample.conf AUTHORS COPYING README.dkms sample-suse-9-mkkmp.spec sample-suse-10-mkkmp.spec

doc-perms:
	# ensure doc file permissions ok
	chmod 0644 $(DOCFILES)

install-redhat-sysv: install doc-perms
	mkdir -m 0755 -p  $(INITD)
	install -p -m 0755 dkms_mkkerneldoth $(LIBDIR)/mkkerneldoth
	install -p -m 0755 dkms_find-provides $(LIBDIR)/find-provides
	install -p -m 0755 lsb_release $(LIBDIR)/lsb_release
	install -p -m 0644 template-dkms-mkrpm.spec $(ETC)
	install -p -m 0644 template-dkms-redhat-kmod.spec $(ETC)
	install -p -m 0755 dkms_service $(INITD)

install-redhat-systemd: install doc-perms
	mkdir -m 0755 -p  $(SYSTEMD)
	install -p -m 0755 dkms_mkkerneldoth $(LIBDIR)/mkkerneldoth
	install -p -m 0755 dkms_find-provides $(LIBDIR)/find-provides
	install -p -m 0755 lsb_release $(LIBDIR)/lsb_release
	install -p -m 0644 template-dkms-mkrpm.spec $(ETC)
	install -p -m 0644 template-dkms-redhat-kmod.spec $(ETC)
	install -p -m 0644 dkms.service $(SYSTEMD)

install-doc:
	mkdir -m 0755 -p $(DOCDIR)
	install -p -m 0644 $(DOCFILES) $(DOCDIR)

install-debian: install install-doc
	mkdir   -p -m 0755 $(SHAREDIR)/apport/package-hooks
	mkdir -m 0755 -p  $(INITD)
	install -p -m 0755 dkms_apport.py $(SHAREDIR)/apport/package-hooks/dkms_packages.py
	install -p -m 0755 dkms_service $(INITD)
	mkdir   -p -m 0755 $(KCONF)/header_postinst.d
	install -p -m 0755 kernel_postinst.d_dkms $(KCONF)/header_postinst.d/dkms
	mkdir   -p -m 0755 $(ETC)/template-dkms-mkdeb/debian
	ln -s template-dkms-mkdeb $(ETC)/template-dkms-mkdsc
	install -p -m 0664 template-dkms-mkdeb/Makefile $(ETC)/template-dkms-mkdeb/
	install -p -m 0664 template-dkms-mkdeb/debian/* $(ETC)/template-dkms-mkdeb/debian/
	chmod +x $(ETC)/template-dkms-mkdeb/debian/postinst
	chmod +x $(ETC)/template-dkms-mkdeb/debian/prerm
	chmod +x $(ETC)/template-dkms-mkdeb/debian/rules
	rm $(DOCDIR)/COPYING*
	rm $(DOCDIR)/sample*

TARBALL=$(ARCHIVE_DIR)/$(RELEASE_STRING).tar.gz
tarball: $(TARBALL)

$(TARBALL): 
	mkdir -p $(BUILD_DIR)/$(RELEASE_STRING)
	cp -ra * $(BUILD_DIR)/$(RELEASE_STRING)
	sed -e "s/\[INSERT_VERSION_HERE\]/$(RELEASE_VERSION)/" dkms > $(BUILD_DIR)/$(RELEASE_STRING)/dkms
	sed -e "s/\[INSERT_VERSION_HERE\]/$(RELEASE_VERSION)/" dkms.spec > $(BUILD_DIR)/$(RELEASE_STRING)/dkms.spec
	find $(BUILD_DIR)/$(RELEASE_STRING) -depth -name .git -type d -exec rm -rf \{\} \; 
	find $(BUILD_DIR)/$(RELEASE_STRING) -depth -name dist -type d -exec rm -rf \{\} \; 
	find $(BUILD_DIR)/$(RELEASE_STRING) -depth -name \*~ -type f -exec rm -f \{\} \; 
	find $(BUILD_DIR)/$(RELEASE_STRING) -depth -name dkms\*.rpm -type f -exec rm -f \{\} \; 
	find $(BUILD_DIR)/$(RELEASE_STRING) -depth -name dkms\*.tar.gz -type f -exec rm -f \{\} \; 
	find $(BUILD_DIR)/$(RELEASE_STRING) -depth -name dkms-freshmeat.txt -type f -exec rm -f \{\} \; 
	rm -rf $(BUILD_DIR)/$(RELEASE_STRING)/debian 
	sync ; sync ; sync 
	tar cvzf $(TARBALL) -C $(BUILD_DIR) $(RELEASE_STRING)
	rm -rf $(BUILD_DIR)/*


rpm: $(TARBALL) dkms.spec
	mkdir -p $(BUILD_DIR)/{BUILD,RPMS,SRPMS,SPECS,SOURCES} 
	cp $(TARBALL) $(BUILD_DIR)/SOURCES
	sed "s/\[INSERT_VERSION_HERE\]/$(RELEASE_VERSION)/" dkms.spec > $(BUILD_DIR)/SPECS/dkms.spec
	pushd $(BUILD_DIR) ; \
	rpmbuild -ba --define "_topdir $(BUILD_DIR)" SPECS/dkms.spec ; \
	popd ; \
	cp $(BUILD_DIR)/RPMS/noarch/* $(BUILD_DIR)/SRPMS/* $(ARTIFACTS_DIR)/

debmagic: $(TARBALL) 
	ln -s $(TARBALL) $(BUILD_DIR)/$(RELEASE_NAME)_$(RELEASE_VERSION).orig.tar.gz
	tar -C $(BUILD_DIR) -xzf $(TARBALL)
	mkdir -p $(BUILD_DIR)/$(RELEASE_STRING)/
	cp -ar debian $(BUILD_DIR)/$(RELEASE_STRING)/
	chmod +x $(BUILD_DIR)/$(RELEASE_STRING)/debian/rules
	pushd $(BUILD_DIR)/$(RELEASE_STRING) ; \
	dch -v $(RELEASE_VERSION) -D $(DIST) "New upstream build of version $(RELEASE_VERSION)" ; \
	dpkg-buildpackage -D -b -rfakeroot -uc -us ; \
	dpkg-buildpackage -D -S -sa -rfakeroot -uc -us ; \
	popd 
	
	cp $(BUILD_DIR)/*.deb $(ARTIFACTS_DIR)/

debs:
	make debmagic DIST=$(DIST)
fm:
	sed -e "s/\[INSERT_VERSION_HERE\]/$(RELEASE_VERSION)/" dkms-freshmeat.txt.in > dkms-freshmeat.txt
