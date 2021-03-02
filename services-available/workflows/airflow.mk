# help: init airflow
airflow-init: ./var/db/airflow.db ./var/airflow
	docker-compose run webserver db init
	docker-compose run webserver users create -r Admin -u admin -e team@coronawhy.org -f admin -l user -p admin
.PHONY: airflow-init

./var/airflow:
	@mkdir -p ./var/airflow
	# not secure, just for dev
	@chmod -R 777 ./var/airflow

# help: clean all airflow data (DANGEROUS!!!)
airflow-dist-clean:
	@rm -r ./var/airflow
.PHONY: airflow-dist-clean
