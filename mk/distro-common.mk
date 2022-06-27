BASE_DIR=$(abspath $(dir $(filter %mk/distro-common.mk,$(MAKEFILE_LIST)))/..)
DISTRO_DIR=$(abspath $(shell pwd))

# Run all unknown target in distro-active/ directory
ifeq ($(DISTRO_DIR),./)
#$(guile (chdir "distro-active"))
$(chdir "distro-active")
.DEFAULT_GOAL := all
.PHONY: ${MAKECMDGOALS}
$(filter-out all,${MAKECMDGOALS}) all: .forward-all ; @:
.forward-all:
	${MAKE} -C build ${MAKECMDGOALS}
# Never try to remake this makefile.
${MAKEFILE_LIST}: ;
.SUFFIXES:
endif
#else

# add default enviroment file if available
-include .env
# if there is no COMPOSE_PROJECT_NAME in .env, let it be distro directory name
COMPOSE_PROJECT_NAME := $(if $(COMPOSE_PROJECT_NAME),$(COMPOSE_PROJECT_NAME),$(notdir $(DISTRO_DIR)))

# find all *.yaml file in distro directory and set COMPOSE_FILE for docker-compose
export COMPOSE_FILE=$(call join-with,:,$(wildcard *.yaml))

## NOTE: trick to run docker-compose with any command (with completed COMPOSE_FILE variable). Can take only one parameter
#%: DOCKER_COMPOSE_COMMAND := $(MAKECMDGOALS)
#%: MAKECMDGOALS := $(firstword MAKECMDGOALS)
#%:
#	docker-compose $(DOCKER_COMPOSE_COMMAND)
#

# help: show all targets with tag 'help'
help:
	@$(call generate-help,$(MAKEFILE_LIST))
.PHONY: help

print-all-variables:
	$(foreach var,$(.VARIABLES),$(info $(var) = $($(var))))
.PHONY: print-all-variables

print-base-dir:
	@echo $(BASE_DIR)
.PHONY: print-base-dir

print-project-name:
	@echo $(COMPOSE_PROJECT_NAME)
.PHONY: print-project-name

# Find all *.mk files which corrspond to *.yaml files.
# For example if solr.yaml exist in distro directory, search for
# solr.mk which in symbolic link (usually in service-avaliable/) ...
$(foreach mk,$(wildcard $(addsuffix .mk,$(basename $(realpath $(wildcard *.yaml))))), \
    $(eval SERVICE_INCLUDE_MK += $(mk)) \
)

# ...  or current distro directory.
$(foreach mk,$(abspath $(wildcard $(addsuffix .mk,$(basename $(wildcard *.yaml))))), \
    $(eval SERVICE_INCLUDE_MK += $(mk)) \
)

$(foreach mk,$(SERVICE_INCLUDE_MK), \
    $(eval -include $(mk))\
)

OK   := $(shell printf "\"\e[1;32mok\e[0m\"")
FAIL := $(shell printf "\"\e[1;31mfail\e[0m\"")

# help: checking consistency of distro
check:
	@printf "Checking 'docker-compose config -q' syntax - "
	@useremail=dummy traefikhost=dummy docker-compose config -q && echo $(OK) || { echo $(FAIL); $(CHECK_EXIT) }

	@printf 'Checking existing .env file - '
	@[ -e .env ] && echo $(OK) || { echo $(FAIL); $(CHECK_EXIT) }

	@printf 'Checking existing not only .override.yaml file - '
	@ls *.yaml 2> /dev/null | grep -qv '\.override.yaml' > /dev/null && echo $(OK) \
		|| { echo $(FAIL)'. Need at least one not override.yaml'; $(CHECK_EXIT) }

	@printf 'Checking not existing *.yml files - '
	@ls *.yml 2> /dev/null >&2 && { echo $(FAIL)'. Please rename or move out *.yml from distro'; $(CHECK_EXIT) } || echo $(OK)

	@printf 'Checking links point to files with same name - '
	@for YAML in *.yaml; do \
		if [ -L $$YAML ]; then \
            FILE=$$(readlink $$YAML); \
            if [ "$$(basename $$FILE)" != "$$(basename $$YAML)" ]; then \
				[ -z "$$TEST_FAIL" ] && echo $(FAIL); \
				echo "Link $$YAML point to file $$FILE with different name"; \
				TEST_FAIL=1; \
			fi; \
        fi; \
    done; \
	[ -z "$$TEST_FAIL" ] && echo $(OK) || { true; $(CHECK_EXIT) }

	@printf 'Checking Makefile is valid - '
	@if [ -L Makefile ]; then \
	    case "$$(readlink Makefile)" in \
	        */mk/distro-include.mk) ;; \
	        */mk/distro-makefile.mk) ;; \
	        *) printf $(FAIL)"\nLink Makefile point to file $$(readlink Makefile), but must be to mk/distro-include.mk or mk/distro-makefile.mk\n"; \
				TEST_FAIL=1 ;; \
	    esac; \
	fi; \
	if [ ! -e Makefile ]; then \
	    printf $(FAIL)"\nThere is no Makefile\n"; \
		TEST_FAIL=1; \
	else \
	    if [ ! -L Makefile ] && ! grep -q 'include .*/mk/distro-\(include\|makefile\).mk' Makefile; then \
	        printf $(FAIL)"\nFile Makefile not include mk/distro-include.mk or mk/distro-makefile.mk\n"; \
			TEST_FAIL=1; \
	    fi; \
	fi; \
	[ -z "$$TEST_FAIL" ] && echo $(OK) || { true; $(CHECK_EXIT) }
.PHONY: check

docker-compose compose:
	docker-compose $(P)

# help: 'docker-compose up' with proper parameters
up: CHECK_EXIT=exit 1;
up: check
	docker-compose up -d
.PHONY: up

debug:
	docker-compose up
.PHONY: debug

# help: 'docker-compose up' with dummy override entrypoint for dataverse. dataverse need to be run manual
up-manual:: COMPOSE_FILE=$(COMPOSE_FILE):/tmp/entrypoint.override.yaml
up-manual::
	@echo '/bin/sh -c '\''while :; do echo "============= im dataverse ==========="; set; set > /tmp/env; sleep 30; done'\'' > /tmp/entrypoint.override.yaml
	docker-compose up -d
	# ' just to fix vim highlight

# help: 'docker-compose down'
down:
	docker-compose down
.PHONY: down

# help: 'docker-compose ps'
ps:
	docker-compose ps
.PHONY: ps

# help: 'docker-compose logs -f'
logs:
	docker-compose logs -f
.PHONY: logs

# help: 'docker volume prune' - cleanup data for current distro
volume-prune:
	docker volume prune --filter 'name=$(COMPOSE_PROJECT_NAME)'
.PHONY: volume-prune

# help: 'docker volume -y prune' - cleanup data for current distro without prompt
volume-prune-force:
	docker volume -y prune --filter 'name=$(COMPOSE_PROJECT_NAME)'
.PHONY: volume-prune-force

# help: 'docker-compose down' and 'docker volume prune'
reset: down volume-prune
.PHONY: reset

# help: generate enviroment variables for current distro. Can be user in shell as: eval \$(make env)
env: .env
	@echo export COMPOSE_FILE=$(COMPOSE_FILE)
	@cat .env | sed '/^ *$$\|^#/d;s/^[^#]/export &/'
	@#env --ignore-environment sh -c "set -x;eval $$(/bin/cat .env); echo 123; export -p"
.PHONY: env

# help: bash with enviroment variables for current distro to allow operate docker-compose directly
shell-distro: PROMPT:=\[\e[01;32m\]\u@\h\[\e[01;35m($(COMPOSE_PROJECT_NAME))\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$$ 
shell-distro: .env
	@. ./.env; \
		printf "\nbash with enviroment variables for current distro. Try to run 'docker-compose config' for example\n\n"; \
		PS1="$(PROMPT)" exec bash --noprofile --norc -il
.PHONY: shell-distro

.env:
	@echo "You need to create .env file"
	@exit 1
#endif # ($(DISTRO_DIR),./)

# vim: noexpandtab tabstop=4 shiftwidth=4 fileformat=unix
