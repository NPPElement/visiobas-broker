#!/bin/bash
export COMPOSE_HTTP_TIMEOUT=200

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
#sudo docker-compose down
sudo git pull

# Обновим клиента
cd /opt/services/home/visiodesk
sudo git pull

sudo docker restart visiodesk

echo -n 'visiodesk перезапускается '; (sleep 40) & spinner $!
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