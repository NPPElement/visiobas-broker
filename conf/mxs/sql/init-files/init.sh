#!/bin/sh

# Разворачиваем базу данных
mysql -uvisiobas -plocpa$$ < /opt/init.sql

# Заполняем начальные данные
mysql -uvisiobas -plocpa$$ < /opt/insert.sql

# Устанавливаем пароли для admin
mysql -uvisiobas -plocpa$$ -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_ADMIN_PASSWORD\") where \`login\`='admin';"
mysql -uvisiobas -plocpa$$ -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_ADMIN_PASSWORD\") where \`login\`='admin';"

# Устанавливаем пароли для user
mysql -uvisiobas -plocpa$$ -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_USER_PASSWORD\") where \`login\`='user';"
mysql -uvisiobas -plocpa$$ -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_USER_PASSWORD\") where \`login\`='user';"

# Устанавливаем пароли для gateway
mysql -uvisiobas -plocpa$$ -e "update \`auth\`.\`user\` set \`password\`=md5(\"$VISIODESK_GATEWAY_PASSWORD\") where \`login\`='gateway';"
mysql -uvisiobas -plocpa$$ -e "update \`vdesk\`.\`user\` set \`pass_hash\`=md5(\"$VISIODESK_GATEWAY_PASSWORD\") where \`login\`='gateway';"