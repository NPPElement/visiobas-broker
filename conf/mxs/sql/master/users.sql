RESET MASTER;

SET GLOBAL max_connections=1000;
SET GLOBAL gtid_strict_mode=ON;

-- MaxScale проверяет действительность входящих клиентов. 
-- Для этого MaxScale необходимо получить информацию для аутентификации 
-- пользователя из серверных баз данных.

-- CREATE USER 'maxscale'@'%' IDENTIFIED BY 'maxscale_pw';
-- GRANT SELECT ON mysql.user TO 'maxscale'@'%';
-- GRANT SELECT ON mysql.db TO 'maxscale'@'%';
-- GRANT SELECT ON mysql.tables_priv TO 'maxscale'@'%';
-- GRANT SELECT ON mysql.roles_mapping TO 'maxscale'@'%';
-- GRANT SHOW DATABASES ON *.* TO 'maxscale'@'%';

-- создаем пользователя для доступа к базе данных с visiodesk 
-- и разрешаем доступ с любого хоста в сети 172.16.16.0/24

CREATE USER 'visiobas'@'%' IDENTIFIED BY 'locpa$$';
GRANT ALL ON *.* TO 'visiobas'@'%';