# BeFAIR
BeFAIR (Be Findable, Accessible, Interoperable, Reusable) Open Science Framework.

BeFAIR is a Common Distributed Research Infrastructure where users can add and run any tools and components by themselves using Debian's way of managing services.
All selected services should be available on a selected subdomain name and could be easily integrated together with Dataverse, BeFAIR data repository.

The infrastructure was designed as out-of-the-box solution that research community can install with one command just as normal Operating System. The roadmap includes releases containing Open Data available for the different sciences, however COVID-19 Data Hub is our current priority.

# Available services

At the moment we have a number of services integrated in BeFAIR:
* traefik
* postgresql
* SOLR
* Dataverse 
* Semantic Gateway
* Apache Airflow
* Apache Superset (in progress) 

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

