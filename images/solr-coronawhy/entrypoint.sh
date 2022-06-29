#!/bin/bash
# Fail on any error
#set -e

if [ ! -d /var/solr/data ]; then
    echo "Create /var/solr/data..."
    tar -C / -xvf /tmp/solr-var-init.tar.gz
fi

solr start
echo "Starting Solr...."
if [ ! -d /var/solr/data/collection1 ]; then
    sleep 25;
    solr stop
    unzip -o -qq /tmp/collection1.zip -d /var/solr/data/
    solr start
    echo "Checking Dataverse....";
    sleep 10;
    until curl -sS -f "http://dataverse:8080/robots.txt" -m 2 2>&1 > /dev/null;
    do echo ">>>>>>>> Waiting for Dataverse...."; echo "---- Dataverse is not ready...."; sleep 20; done;
    echo "Dataverse is running...";
    echo "Trying to update scheme...";
    echo "Updating";
    /tmp/updateSchemaMDB.sh -d http://dataverse:8080 -t /var/solr/data//collection1/conf
    sleep 5;
    echo "-----Scheme updated------";
    #rm /tmp/updateSchemaMDB.sh
else
    echo ":) :) :)"
fi

tail -f /dev/null
