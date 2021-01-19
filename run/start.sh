#!/bin/bash
export COMPOSE_HTTP_TIMEOUT=200

# Это только для отладки
cd /opt/services
sudo docker-compose down
sudo git pull

sudo docker-compose build --no-cache
sudo docker-compose up -d --force-recreate