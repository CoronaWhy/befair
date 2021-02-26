# help: clone latest version ready for distro
superset-clone:
	git clone http://github.com/apache/superset
.PHONY: superset-clone

# help: init superset and start everything
superset-init:
	docker-compose run webserver db init
	docker-compose run webserver users create -r Admin -u admin -e team@coronawhy.org -f admin -l user -p admin
	docker-compose up
.PHONY: superset-init
