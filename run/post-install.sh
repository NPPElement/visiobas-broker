#!/bin/bash
# Скрипт для автоматического создания пользователя RabbitMQ и правки конфигурационных файлов в случае установки пароля не по умолчанию.
set -e
set -x

# Добавление пользователя для работы с RabbitMQ.
source /opt/services/.env
#echo 'rabbitmqctl add_user '$RABBITMQ_MESSAGE_USERNAME' '$RABBITMQ_MESSAGE_USER_PASSWORD''
sudo docker exec -it rabbit1 sh -c 'rabbitmqctl add_user '$RABBITMQ_MESSAGE_USERNAME' '$RABBITMQ_MESSAGE_USER_PASSWORD''
sudo docker exec -it rabbit1 sh -c 'rabbitmqctl add_vhost '$RABBITMQ_VHOST''
sudo docker exec -it rabbit1 sh -c 'rabbitmqctl set_permissions -p '$RABBITMQ_VHOST' '$RABBITMQ_MESSAGE_USERNAME' ".*" ".*" ".*"'

# Заготовка для правки конфигурационного файла.
#conf/visiodesk/configuration/standalone.xml

