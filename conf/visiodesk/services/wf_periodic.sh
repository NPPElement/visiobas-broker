#!/bin/sh

# файл wf_periodic.service должен находится тут (/etc/systemd/system/wf_periodic.service)
# путь к данному файлу прописан в файле wf_periodic.service



while true
do
    /usr/bin/wget -O /dev/null  http://127.0.0.1:8080/vdesk/external/task/push  >/dev/null 2>&1
    /bin/sleep 2
done