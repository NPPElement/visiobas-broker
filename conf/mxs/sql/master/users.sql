RESET MASTER;

SET GLOBAL max_connections=1000;
SET GLOBAL gtid_strict_mode=ON;

CREATE USER 'maxuser'@'172.16.16.65' IDENTIFIED BY 'maxpwd';
CREATE USER 'maxuser'@'%' IDENTIFIED BY 'maxpwd';
GRANT ALL ON *.* TO 'maxuser'@'172.16.16.65' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'maxuser'@'%' WITH GRANT OPTION;

CREATE DATABASE test;

