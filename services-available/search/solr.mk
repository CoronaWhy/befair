# help: 'docker-compose exec dataverse curl http://localhost:8080/api/admin/index'
solr-make-index::
	docker-compose exec dataverse curl -s http://localhost:8080/api/admin/index | xargs
.PHONY: solr-make-index

# help: 'docker-compose exec dataverse curl -s http://localhost:8080/api/admin/index/status
solr-status::
	docker-compose exec dataverse curl -s http://localhost:8080/api/admin/index/status | xargs
.PHONY: solr-status

