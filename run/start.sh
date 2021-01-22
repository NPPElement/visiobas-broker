#!/bin/bash
export COMPOSE_HTTP_TIMEOUT=200

# Это только для отладки
cd /opt/services
sudo docker-compose down
sudo git pull

cd /opt/services/conf/visiodesk/welcome-content/
sudo git pull

cd /opt/services
#sudo docker-compose build --no-cache
sudo docker-compose up -d --force-recreate

# Visiodesk запущен
echo ' '
echo '************************************'
echo '   Visiodesk обновлен и запущен!!!  '
echo '                                    '
echo 'Откройте web интерфейс по адресу:   '
echo 'http://yousite/ или https://yousite/'
echo '************************************'
echo ' '