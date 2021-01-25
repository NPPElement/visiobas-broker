#!/bin/bash
echo ' '
echo '********************'
echo ' Удаление visiodesk '
echo '********************'
echo ' '

sudo rm -R /opt/services/conf
sudo rm -R /opt/services/log
sudo rm -R /opt/services/run

# Delete all containers

sudo docker ps -a -q | xargs -n 1 -I {} sudo docker rm -f {}

#Remove all unused images, not just dangling ones

sudo docker image prune -a -f

#If deleting or stopping the container is hopeless

sudo systemctl daemon-reload
sudo systemctl restart docker

echo ' '
echo '********************'
echo '   Completed!!!'
echo '********************'
echo ' '