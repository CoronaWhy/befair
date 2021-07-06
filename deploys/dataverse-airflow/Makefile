include ../../mk/deploys-template.mk

# help: init and start everything 'dataverse-airflow' deployement
init:
	docker-compose run webserver db init
	docker-compose run webserver users create -r Admin -u admin -e team@coronawhy.org -f admin -l user -p admin
	docker-compose up
.PHONY: init
