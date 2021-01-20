#!/bin/sh

# Разворачиваем базу данных
sleep 5
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/init.sql

# Заполняем начальные данные
sleep 5
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/insert.sql

sleep 5
# Устанавливаем пароли
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update `auth`.`user` set `password`=md5('$VISIODESK_ADMIN_PASSWORD') where `login`='admin';"
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update `vdesk`.`user` set `pass_hash`=md5('$VISIODESK_ADMIN_PASSWORD') where `login`='admin';"