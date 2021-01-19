#!/bin/bash
echo ' '
echo '********************'
echo '  Update containers'
echo '********************'
echo ' '

sudo git pull
sudo docker-compose down

export COMPOSE_HTTP_TIMEOUT=200

# Удалим все образы
sudo docker images -a | xargs -n 1 -I {} sudo docker rmi -f {}

# Загрузим образы из архива в среду Docker
cd /opt/services/conf/containers
docker load -i containers.tar

cd /opt/services
sudo docker-compose build --no-cache
sudo docker-compose up -d --force-recreate

echo ' '
echo '********************'
echo '   Completed!!!'
echo '********************'
echo ' '