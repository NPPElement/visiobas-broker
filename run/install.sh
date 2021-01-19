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

VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
DESTINATION=/usr/bin/docker-compose

sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION

sudo chmod 755 $DESTINATION
docker-compose --version

# Установка клиента visiodesk в директорию /opt/services/conf/visiodesk/
cd /opt/services/conf/visiodesk/
git clone https://github.com/NPPElement/visiodesk-client.git welcome-content

# Установка шлюза visiobas в директорию /opt/services/conf/gateway/
cd /opt
git clone https://github.com/NPPElement/visiobas-gateway.git temp
sudo cp -R /opt/temp/gateway /opt/services/conf/
sudo rm -R /opt/temp/

# Создадим файл с начальными паролями к приложениям
sudo cd /opt/services/
sudo cp -f template-env .env
sudo rm -R template-env

# Запускаем сервер  
cd /opt/services/run
sh start.sh

# Visiodesk установлен
echo ' '
echo '************************************'
echo '     Visiodesk установлен!!!'
echo 'Откройте web интерфейс по адресу:   '
echo 'http://yousite/ или https://yousite/'
echo '************************************'
echo ' '