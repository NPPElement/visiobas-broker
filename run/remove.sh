#!/bin/bash
# Скрипт полностью удалит визиодеск и все файлы и данные (бекапы визуализации и карты не удаляются)

# Остановим и обновим контейнеры
cd /opt/services
sudo docker-compose down

# Delete all containers
sudo docker ps -a -q | xargs -n 1 -I {} sudo docker rm -f {}

#Remove all unused images, not just dangling ones

sudo docker image prune -a -f

#If deleting or stopping the container is hopeless

sudo systemctl daemon-reload
sudo systemctl restart docker

sudo rm -R /opt/services/conf
sudo rm -R /opt/services/log
sudo rm -R /opt/services/run
sudo rm -R /opt/services/data
sudo rm -R /opt/services/.env
sudo rm -R /opt/services/.gitignore
sudo rm -R /opt/services/docker-compose.yml
sudo rm -R /opt/services/template-env
sudo rm -R /opt/services/LICENSE
sudo rm -R /opt/services/.git
sudo rm -R /opt/services/home/configuration

# Visiodesk удален
echo ' '
echo '************************************'
echo '       Visiodesk удален !!!         '
echo '                                    '
echo '************************************'
echo ' '