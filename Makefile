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

dependencies:
	apt-get update -qq
	apt-get install debootstrap -qq
	apt-get install schroot -qq

uninstall-dependencies:
	apt-get purge debootstrap -qq
	apt-get purge schroot -qq

download-chroot:
	mkdir -p ${CHROOT_DESTINATION}
	wget -qO- ${CHROOT_SOURCE} | tar xvz -C ${CHROOT_DESTINATION}

remove-chroot:
	rm -rf ${CHROOT_DESTINATION}

configure-schroot:
	echo "$$SCHROOT_CONFIGURATION" > /etc/schroot/chroot.d/bldr

remove-schroot-configuration:
	rm /etc/schroot/chroot.d/bldr

install-bldr:
	cp ./bldr /usr/local/bin

uninstall-bldr:
	rm /usr/local/bin

uninstall: uninstall-dependencies remove-chroot remove-schroot-configuration
