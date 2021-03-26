#!/bin/sh


# этот файл должен быть тут wf_periodic.service (/etc/systemd/system/wf_periodic.service)
# или в другом месте, но тогда в файле wf_periodic.service
# исправить путь к этому файлу
# Так же указать актуальный URL в строке после do


while true
do
    /usr/bin/wget -O /dev/null  http://visiodesk.net/vdesk/external/task/push  >/dev/null 2>&1
    /bin/sleep 2
done
