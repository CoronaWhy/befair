# help: 'docker-compose exec ${DATAVERSE_CONTAINER_NAME} asadmin'
asadmin:
	docker-compose exec $(DATAVERSE_CONTAINER_NAME) asadmin 
.PHONY: asadmin

# help: 'docker-compose exec ${DATAVERSE_CONTAINER_NAME} tail -F /opt/payara/appserver/glassfish/domains/production/logs/server.log'
payara-logs:
	docker-compose exec $(DATAVERSE_CONTAINER_NAME) tail -n 1000  -F /opt/payara/appserver/glassfish/domains/production/logs/server.log
.PHONY: payara-logs

# help: 'docker-compose exec ${DATAVERSE_CONTAINER_NAME} vim domain.xml'
edit-domain.xml:
	docker-compose exec $(DATAVERSE_CONTAINER_NAME) vim ./appserver/glassfish/domains/production/config/domain.xml 
.PHONY: edit-domain.xml
