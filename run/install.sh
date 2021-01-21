#!/bin/bash
# Скрипты для установки, обновления, запуска сервера visiodesk размещены в директории /opt/services/run/
# Данный скрипт устанавливает сервер visiodesk
# Для обновления уже установленного сервера воспользуйтесь update.sh
# Для запуска сервера воспользуйтесь start.sh

# Обновление и подготовка сервера  
sudo apt --assume-yes update
sudo apt --assume-yes upgrade

# Установка необходимых приложений
sudo apt --assume-yes install docker docker.io 
sudo apt --assume-yes install htop mc 
sudo apt --assume-yes install git jq

# Установка docker-compose
DESTINATION=/usr/bin/docker-compose
sudo curl -L https://289122.selcdn.ru/Visiodesk-Cloud/containers/docker-compose-Linux-x86_64 -o $DESTINATION
#VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
#sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
#sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION
docker-compose --version

mkdir /opt/services/conf/containers/
# Сохраним все контейнеры в локальное хранилище
cd /opt/services/conf/containers/
docker save -o containers.tar jwilder/nginx-proxy:latest rabbitmq:3-management portainer/portainer-ce mariadb:10.5 phpmyadmin jboss/wildfly

# Установка контейнеров
cd /opt/services/conf/containers/
# sudo wget -L http://cloud.visiodesk.ru/containers/visiodesk-server.tar

# Установка клиента visiodesk в директорию /opt/services/conf/visiodesk/
cd /opt/services/conf/visiodesk/
git clone https://github.com/NPPElement/visiodesk-client.git welcome-content

# Создаем папки для файлов
mkdir /opt/services/conf/visiodesk/welcome-content/stub
mkdir /opt/services/conf/visiodesk/welcome-content/files
mkdir /opt/services/conf/visiodesk/welcome-content/svg
mkdir /opt/services/conf/visiodesk/welcome-content/svg/tiles

# Установка шлюза visiobas в директорию /opt/services/conf/gateway/
cd /opt
git clone https://github.com/NPPElement/visiobas-gateway.git temp
sudo cp -R /opt/temp/gateway /opt/services/conf/
sudo rm -R /opt/temp/

# Создадим файл с начальными паролями к приложениям
cd /opt/services/
sudo cp -f template-env .env
sudo rm -R template-env

# Установка сертификата
# cd /opt/services/conf/visiodesk/ssl

# Запускаем контейнеры
cd /opt/services
docker load -i /opt/services/conf/containers/visiodesk-server.tar
sudo docker-compose up -d --force-recreate

# Установка сертификата
sudo docker exec -it visiodesk sh /opt/jboss/wildfly/standalone/configuration/ssl.sh
sudo docker restart visiodesk
sleep 10

# Visiodesk установлен
echo ' '
echo '************************************'
echo '     Visiodesk установлен!!!'
echo '                                    '
echo 'Настройка продолжится в фоне до 5мин'
echo 'Откройте web интерфейс по адресу:   '
echo 'http://yousite/ или https://yousite/'
echo '************************************'
echo ' '