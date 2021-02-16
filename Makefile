include mk/helpers.mk

# help: show all targets with tag 'help'
help:
	@$(call generate-help,$(MAKEFILE_LIST) mk/common.mk)
.PHONY: help

# help: run configurator
menuconfig:
	@bin/menuconfig
.PHONY: menuconfig

# help: check deployment consistency
check:
	@echo FIXME: not yet implemented
.PHONY: check

%:
	@if [ ! -L deploy-active ]; then                              \
		if [ -e deploy-active ]; then                             \
			echo "deploy-active is not a symbolic link."          \
                "It's should be link to active deploy setup" >&2; \
			exit 1;                                               \
		fi;                                                       \
        $(MAKE) menuconfig;                                       \
    fi
	$(MAKE) -C deploy-active $@
.PHONY: %
