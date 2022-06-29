include mk/helpers.mk

#################################################################
# NOTE: this targets valid when no active distro is choosing
#################################################################

MAKEFLAGS += --no-print-directory

# help: show all targets with tag 'help'
help:
	@if [ ! -L $(DISTRO_ACTIVE_LINK) ]; then       \
		$(call generate-help,$(MAKEFILE_LIST));    \
	else                                           \
		$(MAKE) -C $(DISTRO_ACTIVE_LINK) $@;       \
	fi
.PHONY: help

# help: run configurator
menuconfig:
	@$(MAKE) -f $(PWD)/mk/distro-include.mk $@
.PHONY: menuconfig

# help: run configurator inside ubuntu container [portable]
menuconfig-docker:
	@$(MAKE) -f $(PWD)/mk/distro-include.mk $@
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
#################################################################

%:
	@if [ ! -L $(DISTRO_ACTIVE_LINK) ]; then                       \
		if [ -e $(DISTRO_ACTIVE_LINK) ]; then                      \
			echo "$(DISTRO_ACTIVE_LINK) is not a symbolic link."   \
                "It should be a link to an active distro" >&2; \
			exit 1;                                                \
		fi;                                                        \
        echo "There is no symbolic link '$(DISTRO_ACTIVE_LINK)'";  \
		echo "You can create it manually to some distro, for ex.:";\
		echo "$$ ln -s distros/hello-world $(DISTRO_ACTIVE_LINK)"; \
		echo "or run '$(MAKE) menuconfig' and choose active distro";\
		echo ;                                                     \
		exit 1;                                                    \
	elif [ ! -e $(DISTRO_ACTIVE_LINK) ]; then                      \
			echo "$(DISTRO_ACTIVE_LINK) is brocken symbolic link." \
                "It should be a link to an active distro" >&2; \
			exit 1;                                               \
    fi; \
	[ -L $(DISTRO_ACTIVE_LINK) ] && $(MAKE) -C $(DISTRO_ACTIVE_LINK) $@
.PHONY: %

# vim: noexpandtab tabstop=4 shiftwidth=4 fileformat=unix
