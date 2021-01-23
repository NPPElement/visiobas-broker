#!/bin/sh

# Разворачиваем базу данных
mysql -uroot -p${MYSQL_ROOT_PASSWORD} < /opt/init.sql

# Заполняем начальные данные
mysql -uroot -p${MYSQL_ROOT_PASSWORD} < /opt/insert.sql

# Устанавливаем пароли для admin
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_ADMIN_PASSWORD\") where \`login\`='admin';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_ADMIN_PASSWORD\") where \`login\`='admin';"

# Устанавливаем пароли для user
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_USER_PASSWORD\") where \`login\`='user';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_USER_PASSWORD\") where \`login\`='user';"

# Устанавливаем пароли для gateway
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_GATEWAY_PASSWORD\") where \`login\`='gateway';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_GATEWAY_PASSWORD\") where \`login\`='gateway';"