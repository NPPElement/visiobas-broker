RESET MASTER;

SET GLOBAL max_connections=1000;
SET GLOBAL gtid_strict_mode=ON;

-- создаем пользователя для доступа к базе данных с visiodesk 
-- и разрешаем доступ с любого хоста в сети 172.16.16.0/24
CREATE USER 'visiobas'@'172.16.16.%' IDENTIFIED BY 'locpa$$';
GRANT ALL PRIVILEGES ON *.* TO 'visiobas'@'172.16.16.%';
GRANT ALL ON *.* TO 'visiobas'@'172.16.16.%' WITH GRANT OPTION;