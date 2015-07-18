#
# bldr
#
# Build process for installing `bldr`
#
# Author: André König <andre.koenig@posteo.de>
#
#

#
# Configuration
#
# You can override these by exporting them as environment
# variables before executing `make`
#
#
CHROOT_SOURCE ?= http://localhost:3000/chroot.tar.gz
CHROOT_DESTINATION ?= /var/chroots/bldr
ALLOWED_GROUPS ?= www-data

define SCHROOT_CONFIGURATION
[bldr]
description=bldr environment
type=directory
directory=$(CHROOT_DESTINATION)
groups=$(ALLOWED_GROUPS)
endef
export SCHROOT_CONFIGURATION

install: dependencies download-chroot configure-schroot install-bldr

uninstall: remove-chroot remove-schroot-configuration uninstall-dependencies uninstall-bldr

dependencies:
	@echo "bldr: (1/5) Updating apt-get cache."
	@apt-get update -qq

	@echo "bldr: (2/5) Installing debootstrap."
	@apt-get install debootstrap -qq
	
	@echo "bldr: (2/5) Installing schroot."
	@apt-get install schroot -qq

uninstall-dependencies:
	@echo "bldr: (3/4) Uninstalling dependencies."

	apt-get purge debootstrap -qq
	apt-get purge schroot -qq

download-chroot:
	@echo "bldr: (3/5) Downloading the 'bldr' chroot."
	mkdir -p ${CHROOT_DESTINATION}
	wget -qO- ${CHROOT_SOURCE} | tar xz -C ${CHROOT_DESTINATION}

remove-chroot:
	echo "bldr: (1/4) Removing 'bldr' chroot."
	@rm -rf ${CHROOT_DESTINATION}

configure-schroot:
	@echo "bldr: (4/5) Configuring schroot."
	echo "$$SCHROOT_CONFIGURATION" > /etc/schroot/chroot.d/bldr

remove-schroot-configuration:
	echo "bldr: (2/4) Removing 'schroot' configuration."
	rm /etc/schroot/chroot.d/bldr

install-bldr:
	@echo "bldr: (5/5) Installing 'bldr' CLI."
	@cp ./bldr /usr/local/bin

uninstall-bldr:
	@echo "bldr: (4/4) Uninstalling 'bldr'."
	rm /usr/local/bin/bldr
