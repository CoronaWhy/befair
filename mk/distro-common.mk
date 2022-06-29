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
	@$(BASE_DIR)/bin/befair check $$(pwd) || true
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
# PROMPT_COMMAND
#		export BASH_ENV=$(BASE_DIR)/.bashrc; exec bash -i
#		exec bash --rcfile $(BASE_DIR)/.bashrc -i

.env:
	@echo "You need to create .env file"
	@exit 1
#endif # ($(DISTRO_DIR),./)

# help: run configurator
menuconfig:
	@$(BASE_DIR)/bin/befair menuconfig
.PHONY: menuconfig

# help: run configurator inside ubuntu container [portable]
menuconfig-docker:
	docker run -it --rm -v $(shell pwd):/work -w /work ubuntu /work/bin/befair menuconfig
.PHONY: menuconfig-docker

# help: export distro as standalone distro
export:
	@$(BASE_DIR)/bin/befair -f export $$(pwd)
.PHONY: export

# vim: noexpandtab tabstop=4 shiftwidth=4 fileformat=unix
