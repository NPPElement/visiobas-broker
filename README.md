#  VISIODESK

Подробнее на сайте visiodesk.ru
Демо на сайте visiodesk.net

ВНИМАНИЕ! Это переходная версия visiodesk 3.0 -> 4.0
файл docker-compose имеет инструкции для установки универсальных сервисов
если вам нужно больше инструментов раскоментируйте нужные сервисы.

Для https необходимы сертификаты на ваш домен
- ./conf/nginx/ssl/rootCA.crt
- ./conf/nginx/ssl/rootCA.key
читайте подробнее conf/nginx/ssl/README.md 

## Setup
Смените пароль пользователя 
```
passwd root
```
Установка брокера visiodesk в директорию /opt/services
```
cd /opt
sudo git clone https://github.com/NPPElement/visiobas-broker.git services
sudo chmod 755 /opt/services
```
Откройте файл template-env и замените пароли 
```
sudo nano /opt/services/template-env
```
Задать автоматическую генерацию паролей можно и через следующий скрипт с указанием IP машины:
```
sudo bash /opt/services/create-rand-pas-env.sh 192.168.122.55
``` 
Перейдите в папку сервисов и запустите скрипт установки
```
cd /opt/services/run
sudo sh install.sh
```
После установки сервиса требуется добавить в RabbitMQ пользователя user с указанием пароля:
```
sudo docker exec -it rabbit1 sh -c 'rabbitmqctl add_user user user_password'
sudo docker exec -it rabbit1 sh -c 'rabbitmqctl add_vhost '/'
sudo docker exec -it rabbit1 sh -c 'rabbitmqctl set_permissions -p '/' user ".*" ".*" ".*"'
```

Если производилась правка template-env, то требуется также произвести правки в следующих файлах:
```
sudo nano home/visiodesk/js/js.settings.js
sudo nano conf/visiodesk/configuration/standalone.xml
```

Система установлена!

## WEB visiodesk
visioDESK - это инструмент управления качеством услуг вашей Компании. Разработано для бизнеса в сфере эксплуатации различных по сложности объектов. Система visioDESK предназначена для помощи компании в обеспечении качественного уровня сервиса. Система даёт возможность управлять инженерным оборудованием и решать проблемы, если они возникают как можно быстрее, обеспечивая постоянную прозрачность и контроль выполнения работ.

Подробнее о системе на visiodesk.ru  в разделе Документация

в адресе вместо visiodesk.net подставьте свой домен или локальный ip адрес
```
http://visiodesk.net/
```

## WEB webdav
webdav - Файловый менеджер для загрузки файлов визуализации, карт и планировок

Логин admin (или тот который был установлен в template-env)
Пароль admin (или тот который был установлен в template-env можно заменить в самом приложении)

в адресе вместо visiodesk.net подставьте свой домен или локальный ip адрес
```
http://visiodesk.net/webdav/
```

## WEB Portainer
Portainer — мощное решение для работы и конфигурирования Docker контейнеров. Представляет из себя Web приложение которое позволяет проводить настройку и манипуляции с контейнерами. В отличие от Kitematic и Shipyard имеет очень богатый функционал, который позволяет проводить очень качественную и полноценную настройку. 

Логин admin
Пароль admin (при первом запуске пароль заменяется)

в адресе вместо visiodesk.net подставьте свой домен или локальный ip адрес
```
http://visiodesk.net/portainer/
```

## WEB RabbitMQ
RabbitMQ - один из самых популярных брокеров сообщений с открытым исходным кодом. Он поддерживает несколько протоколов обмена сообщениями. RabbitMQ может быть развернут в распределенных и федеративных конфигурациях для удовлетворения требований высокого масштаба и высокой доступности.

Логин admin (или тот который был установлен в template-env)
Пароль admin (или тот который был установлен в template-env можно заменить в самом приложении)

в адресе вместо visiodesk.net подставьте свой домен или локальный ip адрес
```
http://visiodesk.net/rabbit/
```

## WEB phpmyadmin
phpMyAdmin - это бесплатный программный инструмент, написанный на PHP , предназначенный для администрирования MySQL через Интернет. phpMyAdmin поддерживает широкий спектр операций с MySQL и MariaDB. Часто используемые операции (управление базами данных, таблицами, столбцами, отношениями, индексами, пользователями, разрешениями и т. Д.) Можно выполнять через пользовательский интерфейс, при этом у вас по-прежнему есть возможность напрямую выполнять любой оператор SQL.

Логин root (или тот который был установлен в template-env)
Пароль admin (или тот который был установлен в template-env можно заменить в самом приложении)

в адресе вместо visiodesk.net подставьте свой домен или локальный ip адрес
```
http://visiodesk.net/phpmyadmin/
```

## MaxScale
MaxScale - это прокси-сервер базы данных с прозрачной балансировкой нагрузки, который расширяет возможности высокой доступности, масштабируемости и безопасности сервера MariaDB, одновременно упрощая разработку приложений, отделяя его от базовой инфраструктуры базы данных.

Чтобы проверить, все ли в порядке, просто выполните следующие команды:
```
docker-compose exec maxscale maxctrl list servers
docker-compose exec maxscale maxctrl list services
docker-compose exec maxscale maxctrl list filters
docker-compose exec maxscale maxctrl list sessions
```
Чтобы получить дополнительную информацию о каждом компоненте, используйте префикс команды "show", например:
```
docker-compose exec maxscale maxctrl list show sessions
```

## Cloud9 ide
Cloud9 ide - это онлайн IDE для редактирования и создания визуализаций и карт, позволяет одновременное редактирование от нескольких пользователей, предлагая несколько курсоров.

```
http://visiodesk.net:9999/
```

## Docker remove
Чтобы полностью удалить Docker:

Шаг 1
```
dpkg -l | grep -i docker
Чтобы определить, какой установленный у вас пакет:
```
Шаг 2
```
sudo apt-get purge -y docker-engine docker docker.io docker-ce  
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce
```  
Приведенные выше команды не будут удалять изображения, контейнеры, тома или созданные пользователем файлы конфигурации на вашем хосте. Если вы хотите удалить все изображения, контейнеры и тома, выполните следующие команды:

```
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
```
Вы полностью удалили Docker из системы.


## License
GNU General Public License v3.0

Вы можете использовать программу с любой целью в том числе коммерчиской;
Вы можете изучать, как программа работает, и её модифицировать (предварительным условием для этого является доступ к исходному коду);
Вы можете распространять копий как исходного, так и исполняемого кода в том числе и с коммерчиской целью;
Вы можете улучшать программу и выпускать улучшений экземпляр в публичный доступ (предварительным условием для этого является доступ к исходному коду).
В общем случае распространитель программы, полученной на условиях GPL, либо программы, основанной на таковой, обязан предоставить получателю возможность получить соответствующий исходный код.

Если Вы хотите получить другие права на данный продукт или у Вас есть предложения для нас, свяжитесь с нами, контакты на  visiodesk.ru
