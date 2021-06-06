#!/bin/bash

set -e
set -x

createRandPas(){
        echo $(apg -a 1 -n 1 -m 8 -m 8 -M NCL)
}

export -f createRandPas

cd /opt/services/
cp template-env{,.orig}

if [ $# -eq 0 ]
then
    echo "VISIODESK_HOSTNAME=visiodesk.net" > template-env
else
    echo "VISIODESK_HOSTNAME=$1" > template-env
fi

echo "" >> template-env
echo "RABBITMQ_USERNAME=admin" >> template-env
echo "RABBITMQ_PASSWORD=$(createRandPas)" >> template-env
echo "RABBITMQ_VHOST=/" >> template-env
echo "RABBITMQ_MESSAGE_USERNAME=user" >> template-env
echo "RABBITMQ_MESSAGE_USER_PASSWORD=$(createRandPas)" >> template-env
echo "" >> template-env
echo "MYSQL_ROOT_USER=root" >> template-env
echo "MYSQL_ROOT_PASSWORD=$(createRandPas)" >> template-env
echo "MYSQL_USER=admin" >> template-env
echo "MYSQL_PASSWORD=$(createRandPas)" >> template-env
echo "REPLICATION_PASSWORD=$(createRandPas)" >> template-env
echo "" >> template-env
echo "WEBDAV_ROOT_LOGIN=admin" >> template-env
echo "WEBDAV_ROOT_PASSWORD=$(createRandPas)" >> template-env
echo "" >> template-env
echo "WILDFLY_USERNAME=admin" >> template-env
echo "WILDFLY_PASSWORD=$(createRandPas)" >> template-env
echo "WILDFLY_NAME=wildfly" >> template-env
echo "" >> template-env
echo "VISIODESK_ADMIN_PASSWORD=$(createRandPas)" >> template-env
echo "VISIODESK_USER_PASSWORD=$(createRandPas)" >> template-env
echo "VISIODESK_GATEWAY_PASSWORD=$(createRandPas)" >> template-env
echo "" >> template-env
echo "DOCKER_CLOUD9_HOSTNAME=/manager/cloud9/" >> template-env
echo "DOCKER_CLOUD9_USERNAME=admin" >> template-env
echo "DOCKER_CLOUD9_PASSWORD=$(createRandPas)" >> template-env
echo "" >> template-env
echo "DOCKER_LETSENCRYPT_EMAIL=admin@visiodesk.net" >> template-env
echo "" >> template-env
echo "MQTT_USERNAME=user" >> template-env
echo "MQTT_PASSWORD=$(createRandPas)" >> template-env
echo "" >> template-env
echo "POSTGRES_PASSWORD=$(createRandPas)" >> template-env
echo "POSTGRES_HOSTNAME=postgres" >> template-env
echo "PGADMIN_DEFAULT_PASSWORD=$(createRandPas)" >> template-env
