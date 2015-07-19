#
# bldr
#
# Build process for provisioning a `chroot` box and
# installing `bldr` which will operate on this box.
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

BASE_BOX ?= http://de.archive.ubuntu.com/ubuntu 
BASE_BOX_NAME ?= vivid
BASE_BOX_ARCH ?= amd64
BASE_BOX_VARIANT ?= buildd

BOX_SOURCE ?= https://raw.githubusercontent.com/akoenig/bldr/master/boxes/nodejs
BOX_NAME ?= $$(basename $(BOX_SOURCE))
BOX_DESTINATION ?= /var/chroots/$(BOX_NAME)

ALLOWED_GROUPS ?= www-data

define SCHROOT_CONFIGURATION
[bldr]
description=bldr $(shell echo "${BOX_NAME}")
type=directory
directory=$(shell echo "${BOX_DESTINATION}")
groups=$(ALLOWED_GROUPS)
endef
export SCHROOT_CONFIGURATION

install: install_dependencies install_base-box install_configure-schroot install_box-provisioning install-bldr

uninstall: uninstall_box uninstall_schroot-configuration uninstall_remove-bldr uninstall_dependencies

install_dependencies:
	#
	# Installing 'bldr' ...
	#

	#
	# (1/5)
	#
	# Installing the 'bldr' dependencies: 'debootstrap' and 'schroot'
	#
	@apt-get update -qq
	@apt-get install debootstrap -qq
	@apt-get install schroot -qq

install_base-box:
	#
	# (2/5)
	#
	# "Installing the base box to '${BOX_DESTINATION}'. This step can take a while."
	#
	@mkdir -p "${BOX_DESTINATION}"
	@debootstrap --variant="${BASE_BOX_VARIANT}" --arch="${BASE_BOX_ARCH}" "${BASE_BOX_NAME}" "${BOX_DESTINATION}" "${BASE_BOX}"

install_configure-schroot:
	#
	# (3/5)
	#
	# Configure `schroot` for new box.
	#
	@echo "$$SCHROOT_CONFIGURATION" > "/etc/schroot/chroot.d/${BOX_NAME}"

install_box-provisioning:
	@echo ""

	#
	# (4/5)
	#
	# Download the box provisioning file from "${BOX_SOURCE}"
	# and Provisioning '${BOX_NAME}' box.
	#
	@wget -qO- "${BOX_SOURCE}" | schroot -c bldr -- 

install-bldr:
	#
	# (5/5)
	#
	# Install the actual `bldr` script to '/usr/local/bin'
	#
	@cp ./bldr /usr/local/bin
    #
	# Done!
	#

uninstall_box:
	#
	# Uninstalling 'bldr' ...
	#

	#
	# (1/4)
	#
	# Uninstall the installed box: $(shell echo "${BOX_DESTINATION}")
	#
	@rm -rf "${BOX_DESTINATION}"

uninstall_schroot-configuration:
	#
	# (2/4)
	#
	# Remove the `schroot` configuration: "$(shell echo /etc/schroot/chroot.d/${BOX_NAME})"
	#
	@rm -rf "/etc/schroot/chroot.d/${BOX_NAME}"

uninstall_remove-bldr:
	#
	# (3/4)
	#
	# Remove 'bldr' script: '/usr/local/bin/bldr'
	#
	@rm /usr/local/bin/bldr

uninstall_dependencies:
	#
	# (4/4)
	#
	# Purging the dependencies 'debootstrap' and 'schroot'
	#
	apt-get purge debootstrap -qq
	apt-get purge schroot -qq

	#
	# Done!
	#
