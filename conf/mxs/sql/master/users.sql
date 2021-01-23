RESET MASTER;

SET GLOBAL max_connections=1000;
SET GLOBAL gtid_strict_mode=ON;

CREATE USER 'maxuser'@'127.0.0.1' IDENTIFIED BY 'maxpwd';
CREATE USER 'maxuser'@'%' IDENTIFIED BY 'maxpwd';
GRANT ALL ON *.* TO 'maxuser'@'127.0.0.1' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'maxuser'@'%' WITH GRANT OPTION;


-- создаем пользователя для доступа к базе данных с visiodesk 
-- и разрешаем доступ с любого хоста в сети 172.16.16.0/24
CREATE USER 'visiodesk'@'172.16.16.%' IDENTIFIED BY 'mkfkSbfTl';
GRANT ALL PRIVILEGES ON *.* TO visiodesk@'172.16.16.%';
