#!/bin/bash
# Скрипты для установки, обновления, запуска сервера visiodesk размещены в директории /opt/services/run/
# Данный скрипт устанавливает сервер visiodesk
# Для обновления уже установленного сервера воспользуйтесь update.sh
# Для запуска сервера воспользуйтесь start.sh

spinner()
{
    local pid=$1
    local delay=1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

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
# cd /opt/services/conf/containers/
# docker save -o containers.tar jwilder/nginx-proxy:latest rabbitmq:3-management portainer/portainer-ce mariadb:10.5 phpmyadmin jboss/wildfly

# Установка контейнеров
cd /opt/services/conf/containers/
# sudo wget -L http://cloud.visiodesk.ru/containers/visiodesk-server.tar

# Установка клиента visiodesk в директорию /opt/services/conf/visiodesk/
cd /opt/services/home/
git clone https://github.com/NPPElement/visiodesk-client.git visiodesk

# Создаем папки для файлов
mkdir /opt/services/home/visiodesk/stub
mkdir /opt/services/home/visiodesk/files

# Для чистой установки
# mkdir /opt/services/home/visiodesk/svg
# mkdir /opt/services/home/visiodesk/svg/tiles

# Для установки с данными
cd /opt/services/home/visiodesk
git clone https://github.com/NPPElement/svg-example.git svg

# Установка шлюза visiobas в директорию /opt/services/conf/gateway/
cd /opt
git clone https://github.com/NPPElement/visiobas-gateway.git temp
sudo cp -R /opt/temp/gateway /opt/services/conf
sudo rm -R /opt/temp

# Создадим файл с начальными паролями к приложениям
cd /opt/services/
sudo cp -f template-env .env
sudo rm -R template-env

# Запускаем контейнеры
cd /opt/services
#docker load -i /opt/services/conf/containers/visiodesk-server.tar
sudo docker-compose up -d --force-recreate

# Сохраним все контейнеры в локальное хранилище
#mkdir /opt/services/data/containers
#docker save -o /opt/services/data/containers/containers-one.tar jwilder/nginx-proxy:latest rabbitmq:3-management portainer/portainer-ce mariadb:10.5 phpmyadmin jboss/wildfly alpine mariadb/maxscale:2.4

# Установка сертификата
sudo docker exec -it visiodesk sh /opt/jboss/wildfly/standalone/configuration/ssl.sh
sudo docker restart visiodesk

echo -n 'visiodesk запускается '; (sleep 40) & spinner $!
echo ' '

docker-compose exec maxscale maxctrl list servers

echo ' '
echo '   Устанавливаем начальные данные'
echo ' '

docker-compose exec master sh -c 'sh /opt/init.sh'

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