# help: 'docker-compose exec ${DATAVERSE_CONTAINER_NAME} curl http://localhost:8080/api/admin/index'
solr-make-index::
	docker-compose exec $(DATAVERSE_CONTAINER_NAME) curl http://localhost:8080/api/admin/index | xargs
.PHONY: solr-make-index

