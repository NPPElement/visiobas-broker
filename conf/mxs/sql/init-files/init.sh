#!/bin/sh

# Разворачиваем базу данных
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/user.sql

# Разворачиваем базу данных
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/init.sql

# Заполняем начальные данные
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD < /opt/insert.sql

# Устанавливаем пароли для admin
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_ADMIN_PASSWORD\") where \`login\`='admin';"
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_ADMIN_PASSWORD\") where \`login\`='admin';"

# Устанавливаем пароли для user
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_USER_PASSWORD\") where \`login\`='user';"
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_USER_PASSWORD\") where \`login\`='user';"

# Устанавливаем пароли для gateway
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_GATEWAY_PASSWORD\") where \`login\`='gateway';"
mysql -u$MYSQL_ROOT_USER -p$MYSQL_ROOT_PASSWORD -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_GATEWAY_PASSWORD\") where \`login\`='gateway';"