#
# bldr
#
# Build process for installing `bldr`
#
# Author: André König <andre.koenig@posteo.de>
#
#

CHROOT_SOURCE ?= http://localhost:3000/chroot.tar.gz
CHROOT_DESTINATION ?= /var/bldr
ALLOWED_GROUPS ?= www-data

define SCHROOT_CONFIGURATION
[bldr]
description=bldr environment
type=directory
directory=$(CHROOT_DESTINATION)
groups=$(ALLOWED_GROUPS)
endef
export SCHROOT_CONFIGURATION

install: apt-update debootstrap schroot download-chroot configure-schroot

apt-update:
	apt-get update

debootstrap:
	apt-get install debootstrap -qq

schroot:
	apt-get install schroot -qq

download-chroot:
	wget -qO- ${CHROOT_IMAGE} | tar xvz -C /var/bldr

configure-schroot:
	echo "$$SCHROOT_CONFIGURATION" > /etc/schroot/chroot.d/bldr

install-bldr:
	cp ./bldr /usr/local/bin
