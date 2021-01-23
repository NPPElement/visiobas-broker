#!/bin/bash
export COMPOSE_HTTP_TIMEOUT=200

spinner()
{
    local pid=$1
    local delay=0.25
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

# Это только для отладки
cd /opt/services
sudo docker-compose down
sudo git pull

cd /opt/services/conf/visiodesk/welcome-content/
sudo git pull

cd /opt/services
#sudo docker-compose build --no-cache
sudo docker-compose up -d --force-recreate

echo -n 'visiodesk запускается '; (sleep 40) & spinner $!
echo ' '

docker-compose exec maxscale maxctrl list servers

# Visiodesk запущен
echo ' '
echo '************************************'
echo '   Visiodesk обновлен и запущен!!!  '
echo '                                    '
echo 'Откройте web интерфейс по адресу:   '
echo 'http://yousite/ или https://yousite/'
echo '************************************'
echo ' '