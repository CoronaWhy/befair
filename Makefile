include mk/helpers.mk

DISTROS_DIR=distros
DISTRO_ACTIVE_LINK=distro-active

# help: show all targets with tag 'help'
help:
	@$(call generate-help,$(MAKEFILE_LIST) mk/distro-common.mk)
.PHONY: help

# help: run configurator
menuconfig:
	@bin/menuconfig
.PHONY: menuconfig

# help: run configurator inside ubuntu container [portable]
menuconfig-docker:
	docker run -it --rm -v $(shell pwd):/work -w /work ubuntu /work/bin/menuconfig 
.PHONY: menuconfig-docker

# help: check all distros consistency
check-all:
	@for DIR in $(DISTROS_DIR)/*; do               \
		printf "=============================";   \
		printf " Checking %-20s " $$DIR;          \
		printf "=============================\n"; \
		$(MAKE) -C $$DIR -f $(PWD)/mk/distro-makefile.mk check; \
		echo;                                     \
	done
.PHONY: check-all

%:
	@if [ ! -L $(DISTRO_ACTIVE_LINK) ]; then                       \
		if [ -e $(DISTRO_ACTIVE_LINK) ]; then                      \
			echo "$(DISTRO_ACTIVE_LINK) is not a symbolic link."   \
                "It should be a link to an active distro" >&2; \
			exit 1;                                                \
		fi;                                                        \
        $(MAKE) menuconfig;                                        \
	elif [ ! -e $(DISTRO_ACTIVE_LINK) ]; then                      \
			echo "$(DISTRO_ACTIVE_LINK) is brocken symbolic link." \
                "It should be a link to an active distro" >&2; \
			exit 1;                                               \
    fi; \
	[ -L $(DISTRO_ACTIVE_LINK) ] && $(MAKE) -C $(DISTRO_ACTIVE_LINK) $@
.PHONY: %

# vim: noexpandtab tabstop=4 shiftwidth=4 fileformat=unix
