#########################################################################################
# This file part of BeFAIR (https://github.com/CoronaWhy/befair) standalone distributive
#########################################################################################

help:
	@printf "tgz                  - create tar.gz with distributive\n"
	@printf "check                - checking consistency of standalone distributive\n\n"
	@printf "up                   - 'docker-compose up -d'\n"
	@printf "debug                - 'docker-compose up'\n"
	@printf "down                 - 'docker-compose down'\n"
	@printf "ps                   - 'docker-compose ps'\n\n"
	@printf "volume-prune         - 'docker volume prune'\n"
	@printf "volume-prune-force   - 'docker volume -y prune'\n"
	@printf "reset                - 'docker-compose down' and 'docker volume prune'\n"
.PHONY: help

DIR = $(notdir $(PWD))
tgz:
	tar -C .. -czvf ../befair-standalone_$(DIR)_$(shell date +%Y%m%d).tar.gz $(DIR)/
.PHONY: tgz

OK   := $(shell printf "\"\e[1;32mok\e[0m\"")
FAIL := $(shell printf "\"\e[1;31mfail\e[0m\"")

# help: checking consistency of deploy
check:
	@printf "Checking 'docker-compose config -q' syntax - "
	@useremail=dummy traefikhost=dummy docker-compose config -q && echo $(OK) || { echo $(FAIL); $(CHECK_EXIT) }

	@printf 'Checking existing .env file - '
	@[ -e .env ] && echo $(OK) || { echo $(FAIL); $(CHECK_EXIT) }

	@printf 'Checking existing not only .override.yaml file - '
	@ls *.yaml | grep -qv '\.override.yaml' > /dev/null && echo $(OK) \
		|| { echo $(FAIL)'. Need at least one not override.yaml'; $(CHECK_EXIT) }

	@printf 'Checking not existing *.yml files - '
	@ls *.yml 2> /dev/null >&2 && { echo $(FAIL)'. Please rename or move out *.yml from deployment'; $(CHECK_EXIT) } || echo $(OK)

.PHONY: check

up:
	docker-compose up -d
.PHONY: up

debug:
	docker-compose up
.PHONY: debug

down:
	docker-compose down
.PHONY: down

ps:
	docker-compose ps
.PHONY: ps

volume-prune:
	if [ -z "$$COMPOSE_PROJECT_NAME" ]; then echo COMPOSE_PROJECT_NAME not set; exit 1; fi
	docker volume prune --filter 'name=$(COMPOSE_PROJECT_NAME)'
.PHONY: volume-prune

volume-prune-force:
	if [ -z "$$COMPOSE_PROJECT_NAME" ]; then echo COMPOSE_PROJECT_NAME not set; exit 1; fi
	docker volume -y prune --filter 'name=$(COMPOSE_PROJECT_NAME)'
.PHONY: volume-prune-force

reset: down volume-prune
.PHONY: reset

