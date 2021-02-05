include mk/helpers.mk

# help: show all targets with tag 'help'
help:
	@$(call generate-help,$(MAKEFILE_LIST) mk/common.mk)
.PHONY: help

# help: run configurator
config:
	#@echo $(notdir $(basename $(wildcard services-available/*.yaml)))
	@echo FIXME: config not yet implemented
	@exit 1
.PHONY: config

# help: run wizard for deployment create
create-deployment:
	@echo FIXME: create-deployment not yet implemented
	@exit 1
.PHONY: create

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
        $(MAKE) config;                                           \
    fi
	$(MAKE) -C deploy-active $@
.PHONY: %
