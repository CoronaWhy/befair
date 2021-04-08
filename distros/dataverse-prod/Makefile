include ../../mk/distro-include.mk

################################################################
# Example of implementation specific distro command
# Uncomment by removing first # it to try
################################################################

# help: down => clean => reboot => up
dev-cycle: down dev-prune up logs

.PHONY: dev-cycle

# help: prune everyting
dev-prune:
	@sudo rm -fr var/dataverse var/database var/solr
	@docker volume prune -f
.PHONY: dev-prune
################################################################
