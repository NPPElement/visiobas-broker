#!/bin/bash
echo ' '
echo '********************'
echo '  Update visiodesk  '
echo '********************'
echo ' '

export COMPOSE_HTTP_TIMEOUT=200

# Останавливаем сервер
sudo docker-compose down

# Обновляем сервер 
cd /opt/services/
sudo git pull

# Удалим все образы
sudo docker images -a | xargs -n 1 -I {} sudo docker rmi -f {}

# Обновим клиента
cd /opt/services/conf/visiodesk/welcome-content
sudo git pull

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