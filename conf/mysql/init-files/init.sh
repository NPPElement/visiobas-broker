#!/bin/sh

# Разворачиваем базу данных
sleep 5
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/init.sql

# Заполняем начальные данные
sleep 5
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/insert.sql

# Устанавливаем пароли
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD 
update `auth`.`user` set `password`=md5('$VISIODESK_ADMIN_PASSWORD') where `login`='admin';
update `vdesk`.`user` set `pass_hash`=md5('$VISIODESK_ADMIN_PASSWORD') where `login`='admin';
exit;