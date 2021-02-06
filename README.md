# BeFAIR
BeFAIR (Be Findable, Accessible, Interoperable, Reusable) Open Science Framework.

BeFAIR is a Common Distributed Research Infrastructure where users can add and run any tools and components by themselves using Debian's way of managing services.
All selected services should be available on a selected subdomain name and could be easily integrated together with Dataverse, BeFAIR data repository.

The infrastructure was designed as out-of-the-box solution that research community can install with one command just as normal Operating System. The roadmap includes releases containing Open Data available for the different sciences, however COVID-19 Data Hub is our current priority.

# Available services

Available basic infrastructure components:
* traefik
* postgresql
* SOLR

The list of services integrated in BeFAIR:
* [Dataverse](http://github.com/IQSS/dataverse) 
* [Semantic Gateway](https://github.com/Dans-labs/semantic-gateway)
* [Apache Airflow](https://github.com/apache/airflow)
* [Apache Superset](https://github.com/apache/superset) (in progress) 
* [FAIRDataPoint](https://github.com/FAIRDataTeam/FAIRDataPoint) (in progress)

To Do (please join the project if you want to contribute!):
* CoronaWhy API http://api.apps.coronawhy.org (FastAPI with Swagger)
* Elasticsearch http://es.apps.coronawhy.org
* SPARQL http://sparql.apps.coronawhy.org (Virtuoso as a service)
* INDRA http://indra.apps.coronawhy.org (INDRA REST API https://indra.readthedocs.io/en/latest/rest_api.html)
* Grlc http://grlc.apps.coronawhy.org (SPARQL queries into RESTful APIs convertor)
* Doccano http://doccano.apps.coronawhy.org
* Jupyter http://jupyter.apps.coronawhy.org (look for token in the logs)
* OCR Tesseract http://ocr.apps.coronawhy.org (OCR as a service)
* Portainer http://portainer.apps.coronawhy.org
* Kibana http://kibana.apps.coronawhy.org

BeFAIR is using Traefik load balancer and proxy service. Please define traefikhost in the configuration of your deployment (see deploys folder) to start enabled services.  

For example, if you will put the following subdomain (labs.coronawhy.org) in .env file
```
traefikhost=labs.coronawhy.org
```
the services will be available on airflow.labs.coronawhy.org, superset.labs.coronawhy.org and so on.

# Installation and deployment

You need Docker and Docker Compose before you'll be able to run BeFAIR:
```
sudo apt install make unzip docker-compose
```
add current user to group 'docker'
```
sudo adduser $USER docker
```

create new shell with new 'docker' group applied
```
newgrp docker
```

If you see the message: "ERROR: Network traefik declared as external, but could not be found", please create the network manually using `docker network create traefik` and try again.

After Docker is installed you can run BeFAIR:
```
git clone https://github.com/CoronaWhy/befair
cd befair
cd deploys/localhost 
make up
```

# Citation for the academic use

Please cite this work as follows:

Tykhonov V., Polishko A., Kiulian, A., Komar M. (2020). CoronaWhy: Building a Distributed, Credible and Scalable Research and Data Infrastructure for Open Science. Zenodo. http://doi.org/10.5281/zenodo.3922257

# License

The content of this project itself is licensed under the Creative Commons Attribution 3.0 Unported license, and the underlying source code used to format and display that content is licensed under the MIT license.

