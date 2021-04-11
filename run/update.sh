#!/bin/bash
# Скрипт полностью пересобирает контейнеры и обновляет все (данные не пропадут)
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

# Остановим и обновим контейнеры
cd /opt/services
sudo docker-compose down
sudo git pull

# Обновим клиента
cd /opt/services/home/visiodesk
sudo git pull

# Соберем и запустим контейнеры 
cd /opt/services
sudo docker-compose build
sudo docker-compose up -d --force-recreate --remove-orphans

echo -n 'visiodesk запускается '; (sleep 40) & spinner $!
echo ' '

#docker-compose exec maxscale maxctrl list servers

# Установка сертификата
sudo docker exec -it visiodesk sh /opt/jboss/wildfly/standalone/configuration/ssl.sh
sudo docker restart visiodesk

# Visiodesk запущен
echo ' '
echo '************************************'
echo '   Visiodesk обновлен и запущен!!!  '
echo '                                    '
echo 'Откройте web интерфейс по адресу:   '
echo 'http://yousite/ или https://yousite/'
echo '************************************'
echo ' '
