#!/bin/bash
echo ' '
echo '********************'
echo '  Build containers'
echo '********************'
echo ' '

cd /opt/services/conf/visiodesk/welcome-content
sudo git pull

cd /opt/services
docker pull jwilder/nginx-proxy:latest
docker pull rabbitmq:3-management
docker pull portainer/portainer-ce
docker pull mariadb:10.5
docker pull phpmyadmin
docker pull jboss/wildfly

cd /opt/services/conf/containers/
docker save -o containers.tar jwilder/nginx-proxy:latest rabbitmq:3-management portainer/portainer-ce mariadb:10.5 phpmyadmin jboss/wildfly

cd /opt/services
sudo git add *
sudo git commit -m 'update'
sudo git pull

echo ' '
echo '********************'
echo '   Completed!!!'
echo '********************'
echo ' '