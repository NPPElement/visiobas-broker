#!/bin/sh

sleep 2
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/init.sql
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/insert.sql