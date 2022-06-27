# help: run shell inside dataverse container
shell-dataverse:
	docker-compose exec dataverse bash
.PHONY: shell-dataverse

# help: 'docker-compose exec dataverse asadmin'
asadmin:
	docker-compose exec dataverse asadmin 
.PHONY: asadmin

# help: 'docker-compose exec dataverse tail -F /opt/payara/appserver/glassfish/domains/production/logs/server.log'
payara-logs:
	docker-compose exec dataverse tail -n 1000  -F /opt/payara/appserver/glassfish/domains/production/logs/server.log
.PHONY: payara-logs

# help: 'docker-compose exec dataverse vim domain.xml'
edit-domain.xml:
	docker-compose exec dataverse vim ./appserver/glassfish/domains/production/config/domain.xml 
.PHONY: edit-domain.xml
