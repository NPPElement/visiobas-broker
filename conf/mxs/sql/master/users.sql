RESET MASTER;

SET GLOBAL max_connections=10000;
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

CREATE USER 'visiobas'@'172.16.16.50' IDENTIFIED BY 'locpa$$';
GRANT ALL ON *.* TO 'visiobas'@'172.16.16.50' WITH GRANT OPTION;

CREATE USER 'backup'@'172.16.16.42' IDENTIFIED BY 'backupa$$';
GRANT SELECT ON *.* TO 'backup'@'172.16.16.42' WITH GRANT OPTION;

CREATE USER 'master'@'172.16.16.6%' IDENTIFIED BY 'masterpa$$';
GRANT ALL ON *.* TO 'master'@'172.16.16.6%' WITH GRANT OPTION;

CREATE USER 'monitor'@'172.16.16.60' IDENTIFIED BY 'monitorpa$$';
GRANT ALL ON *.* TO 'monitor'@'172.16.16.60' WITH GRANT OPTION;

CREATE USER 'read'@'172.16.16.60' IDENTIFIED BY 'readpa$$';
GRANT ALL ON *.* TO 'read'@'172.16.16.60' WITH GRANT OPTION;

CREATE USER 'write'@'172.16.16.60' IDENTIFIED BY 'writepa$$';
GRANT ALL ON *.* TO 'write'@'172.16.16.60' WITH GRANT OPTION;