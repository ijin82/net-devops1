# Домашнее задание к занятию 4 «Оркестрация группой Docker контейнеров на примере Docker Compose»

## Задача 1

```bash
docker pull nginx:1.29.0
#...
docker login
#...
docker build -t ijin82/custom-nginx:1.0.0 .
docker push ijin82/custom-nginx:1.0.0
```

## Задача 2

```bash
# чистим все неудачно запущенные контейнеры
docker rm -f $(docker ps -aq --filter "ancestor=ijin82/custom-nginx:1.0.0")

# запускаем в соотв-ии с требованиями
docker run -d -p 8080:80 --name rogozhinilia-custom-nginx-t2 ijin82/custom-nginx:1.0.0

# останавливаем созданный
docker stop rogozhinilia-custom-nginx-t2

# переименовываем контейнер
#$ docker help rename
#Usage:  docker rename CONTAINER NEW_NAME
docker rename rogozhinilia-custom-nginx-t2 custom-nginx-t2

# стартую контейнер снова, потому что останавливал 
# (а можно было не останавливать, как выяснилось - работающий тоже можно переименовать)
docker start custom-nginx-t2

# выполнил команду, проверился курлом
$ date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html
15-09-2026 19:15:09.632277452 EET
CONTAINER ID   IMAGE                       COMMAND                  CREATED         STATUS                 PORTS                         
            NAMES
7462214842be   ijin82/custom-nginx:1.0.0   "/docker-entrypoint.…"   9 minutes ago   Up 48 seconds          0.0.0.0:8080->80/tcp, [::]:808
0->80/tcp   custom-nginx-t2
dea7138439a4   jellyfin/jellyfin:latest    "/jellyfin/jellyfin"     5 months ago    Up 8 hours (healthy)                                 
            jellyfin
2026/09/15 17:14:21 [notice] 1#1: start worker process 39
PGh0bWw+Cgo8aGVhZD4KICAgIEhleSwgTmV0b2xvZ3kKPC9oZWFkPgoKPGJvZHk+CiAgICA8aDE+
SSB3aWxsIGJlIERldk9wcyBFbmdpbmVlciE8L2gxPgo8L2JvZHk+Cgo8L2h0bWw+
ijin@tatuin ~/Work/net-devops1/05-virt-03-docker-intro
$ curl http://127.0.0.1:8080/
<html>

<head>
    Hey, Netology
</head>

<body>
    <h1>I will be DevOps Engineer!</h1>
</body>

# повторил, добавил скриншот 
# 05-virt-03-docker-intro/Screenshots/Curl check after base64 2026-09-15 19-20-31.png
```

## Задача 3

```bash
# (1) как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
docker logs -f custom-nginx-t2
# в этом случае Ctrl + C не вызывает остановку контейнера.. потому что это логи(!)

# $ docker help | grep input
# attach      Attach local standard input, output, and error streams to a running container
# $ docker help attach
# (2) Usage:  docker attach [OPTIONS] CONTAINER

docker attach custom-nginx-t2

# (3) Ctrl + C - останавливает контейнер, потому что , как я понял, мы подключились 
# к основному процессу контейнера и вручную прервали этот процесс, докер это увидел 
# и контейнер завершил свою работу

# (4) Перезапустите контейнер
docker start custom-nginx-t2

# (5) Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
$ docker exec -it custom-nginx-t2 bash
root@58a492f70755:/# ls -la
total 76
drwxr-xr-x   1 root root 4096 Sep 15 19:41 .
drwxr-xr-x   1 root root 4096 Sep 15 19:41 ..
-rwxr-xr-x   1 root root    0 Sep 15 19:41 .dockerenv
lrwxrwxrwx   1 root root    7 Aug 11  2025 bin -> usr/bin
drwxr-xr-x   2 root root 4096 May  9  2025 boot
drwxr-xr-x   5 root root  340 Sep 15 19:54 dev
drwxr-xr-x   1 root root 4096 Aug 12  2025 docker-entrypoint.d
-rwxr-xr-x   1 root root 1620 Aug 12  2025 docker-entrypoint.sh
drwxr-xr-x   1 root root 4096 Sep 15 19:41 etc
drwxr-xr-x   2 root root 4096 May  9  2025 home
lrwxrwxrwx   1 root root    7 Aug 11  2025 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Aug 11  2025 lib64 -> usr/lib64
drwxr-xr-x   2 root root 4096 Aug 11  2025 media
drwxr-xr-x   2 root root 4096 Aug 11  2025 mnt
drwxr-xr-x   2 root root 4096 Aug 11  2025 opt
dr-xr-xr-x 648 root root    0 Sep 15 19:54 proc
drwx------   2 root root 4096 Aug 11  2025 root
drwxr-xr-x   1 root root 4096 Sep 15 19:54 run
lrwxrwxrwx   1 root root    8 Aug 11  2025 sbin -> usr/sbin
drwxr-xr-x   2 root root 4096 Aug 11  2025 srv
dr-xr-xr-x  13 root root    0 Sep 15 19:54 sys
drwxrwxrwt   2 root root 4096 Aug 11  2025 tmp
drwxr-xr-x   1 root root 4096 Aug 11  2025 usr
drwxr-xr-x   1 root root 4096 Aug 11  2025 var


# (6) Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
root@58a492f70755:/# apt-get install vim
#...

# (7) Отредактируйте файл "/etc/nginx/conf.d/default.conf", 
# заменив порт "listen 80" на "listen 81".
root@58a492f70755:/# cat /etc/nginx/conf.d/default.conf
server {
    listen 81 default_server;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ =404;
    }
}

# (8) Запомните(!) и выполните команду nginx -s reload, а затем внутри 
# контейнера curl http://127.0.0.1:80 ; curl http://127.0.0.1:81.
root@58a492f70755:/# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@58a492f70755:/# nginx -s reload
2026/09/15 19:58:48 [notice] 303#303: signal process started
root@58a492f70755:/# curl http://127.0.0.1:80
curl: (7) Failed to connect to 127.0.0.1 port 80 after 0 ms: Couldn\'t connect to server
root@58a492f70755:/# curl http://127.0.0.1:81
<html>

<head>
    Hey, Netology
</head>

<body>
    <h1>I will be DevOps Engineer!</h1>
</body>

# (9) Выйдите из контейнера, набрав в консоли exit или Ctrl-D.
# (10) Проверьте вывод команд: ss -tlpn | grep 127.0.0.1:8080 , 
# docker port custom-nginx-t2, curl http://127.0.0.1:8080. 

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ ss -tlpn | grep 127.0.0.1:8080 
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker port custom-nginx-t2
80/tcp -> 0.0.0.0:8080
80/tcp -> [::]:8080
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ curl http://127.0.0.1:8080
curl: (56) Recv failure: Connection reset by peer
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker-ps
CONTAINER ID   NAMES             IMAGE                       STATUS
58a492f70755   custom-nginx-t2   ijin82/custom-nginx:1.0.0   Up 6 minutes
53f4e7604efa   jellyfin          jellyfin/jellyfin:latest    Up 39 minutes (healthy)
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro

# Кратко объясните суть возникшей проблемы.

# Мы nginx порт, на котором nginx слушает подключения - сменили на другой,
# но сделали это так что докер про это ничего не знает, а поскольку мы запускали 
# контейнер как 8080:80 (host_port:container_port) то привязали локальный 8080 
# на 80й порт контейнера, где должен был быть nginx, которому мы сменили порт на 81й
# и теперь там никто не отвечает на 80м.
# Любопытно что ss (аналог netstat?) показывает бинд на 0.0.0.0 а не на 127.0.0.1
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ ss -tlpn | grep 127.0.0.1:8080 
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ ss -tlpn | grep 8080 
LISTEN 0      4096              0.0.0.0:8080       0.0.0.0:*                                          
LISTEN 0      4096                 [::]:8080          [::]:*  

# (11) то дополнительное, необязательное задание. Попробуйте самостоятельно исправить
# конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте 
# конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. 
# Пример источника https://www.baeldung.com/linux/assign-port-docker-container
# ..1) просто сменить бинд легко, и стартовать снова, но ведь имя не изменится..
#    ... This is the simplest and most straightforward approach, but it doesn’t suit all situations.
# ..2) Остановить, коммитом сделать новый image чтобы сохранить слои и стартовать с новым портом

$ docker stop custom-nginx-t2
custom-nginx-t2

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker commit custom-nginx-t2 custom-nginx-t2-81
sha256:c5d08ed3e5a6f70996f08340a9fcb810ea2b9f843ccb08a183e32032e391ba0d

jin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker image ls | grep -i custom-nginx
WARNING: This output is designed for human readability. For machine-readable output, please use --format.
custom-nginx-t2-81:latest              c5d08ed3e5a6        253MB             0B   U    
ijin82/custom-nginx:1.0.0              5a388b811cda        192MB             0B   U 

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker-ps
CONTAINER ID   NAMES             IMAGE                       STATUS
58a492f70755   custom-nginx-t2   ijin82/custom-nginx:1.0.0   Exited (0) 32 seconds ago
53f4e7604efa   jellyfin          jellyfin/jellyfin:latest    Up 56 minutes (healthy)

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker run -p 8080:81 custom-nginx-t2-81 custom-nginx-t2-81port
/docker-entrypoint.sh: 47: exec: custom-nginx-t2-81port: not found

## (РЕШЕНО)
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker run -d -p 8080:81 --name custom-nginx-t2-port81 custom-nginx-t2-81
642c661e4eda003df47d5db55d5d9ebe118c701c139fdb739221c9b3a31e776c


# (12) Удалите запущенный контейнер "custom-nginx-t2", 
# не останавливая его.(воспользуйтесь --help или google)
ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker-ps
CONTAINER ID   NAMES                    IMAGE                       STATUS
642c661e4eda   custom-nginx-t2-port81   custom-nginx-t2-81          Up 4 minutes
b00a1e71013e   great_poincare           custom-nginx-t2-81          Exited (127) 5 minutes ago
58a492f70755   custom-nginx-t2          ijin82/custom-nginx:1.0.0   Exited (0) 6 minutes ago
53f4e7604efa   jellyfin                 jellyfin/jellyfin:latest    Up About an hour (healthy)

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker rm custom-nginx-t2-port81
Error response from daemon: cannot remove container "custom-nginx-t2-port81": container is running: stop the container bef
ore removing or force remove

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker rm custom-nginx-t2-port81 -f
custom-nginx-t2-port81

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker rm custom-nginx-t2 -f
custom-nginx-t2

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker rm great_poincare -f
great_poincare

ijin@alt ~/Work/net-devops1/05-virt-03-docker-intro
$ docker-ps
CONTAINER ID   NAMES      IMAGE                      STATUS
53f4e7604efa   jellyfin   jellyfin/jellyfin:latest   Up About an hour (healthy)

```

## Задание 4

```bash
# sleep infinity — это команда, которая просто «спит» вечно. Контейнер будет в статусе 
# нужно чтобы у контейнера был главный процесс, иначе контейнер сразу завершит работу
docker run -d --name centos-data -v "$(pwd)":/data centos:centos7.9.2009 sleep infinity
docker run -d --name debian-data -v "$(pwd)":/data debian:trixie-slim sleep infinity

ijin@alt 🏠 ~                                                
$ docker-ps                                                  
CONTAINER ID   NAMES         IMAGE                      STATUS
e4c1652e4d8f   debian-data   debian:trixie-slim         Up 5 seconds
3b3c225e557e   centos-data   centos:centos7.9.2009      Up 42 seconds
53f4e7604efa   jellyfin      jellyfin/jellyfin:latest   Up 2 hours (healthy)

# Подключитесь к первому контейнеру с помощью docker exec и 
# создайте текстовый файл любого содержания в /data
docker exec -it centos-data bash 

[root@3b3c225e557e /]# echo "hello im here" > /data/hello.txt
[root@3b3c225e557e /]# ll /data                              
total 36 
-rw-r--r-- 1 1000 1000   140 Sep 15 19:22 Dockerfile         
-rw-r--r-- 1 1000 1000 13106 Sep 15 21:02 README.md          
drwxr-xr-x 2 1000 1000  4096 Sep 15 19:22 Screenshots        
-rw-r--r-- 1 1000 1000   162 Sep 15 19:22 hello-net.nginx.conf
-rw-r--r-- 1 root root    14 Sep 15 21:03 hello.txt          
-rw-r--r-- 1 1000 1000    94 Sep 15 19:39 index.html

# Добавьте ещё один файл в текущий каталог $(pwd) на хостовой машине.
# -> Создал в VS Code "hello-from-host.txt"

# Подключитесь во второй контейнер и отобразите листинг 
# и содержание файлов в /data контейнера
docker exec -it debian-data bash 
root@e4c1652e4d8f:/# ls /data | grep txt
hello-from-host.txt
hello.txt
root@e4c1652e4d8f:/# cat /data/hello.txt 
hello im here
root@e4c1652e4d8f:/# cat /data/hello-from-host.txt 
hello im txt file from hostroot@e4c1652e4d8f:/#

# Скриншот: 
# 05-virt-03-docker-intro/Screenshots/Debian Centos 2026-09-15 23-10-01.png
```

## Задача 5

```bash
# Скриншот:
# 05-virt-03-docker-intro/Screenshots/Task5 Step1 2026-09-15 23-20-41.png
ijin@alt 🏠 ~
$ mkdir -p  /tmp/netology/docker/task5
ijin@alt 🏠 ~
$ cd /tmp/netology/docker/task5
ijin@alt /tmp/netology/docker/task5
$ vim compose.yaml
ijin@alt 🐳 /tmp/netology/docker/task5
$ vim docker-compose.yaml
ijin@alt 🐳 /tmp/netology/docker/task5
$ cat compose.yaml 
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
ijin@alt 🐳 /tmp/netology/docker/task5
$ cat docker-compose.yaml 
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"


$ docker compose up
WARN[0000] Found multiple config files with supported names: /tmp/netology/docker/task5/compose.yaml, /tmp/netology/docker/task5/docker-compose.yaml 
WARN[0000] Using /tmp/netology/docker/task5/compose.yaml 
WARN[0000] /tmp/netology/docker/task5/compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] up 9/9
 ✔ Image portainer/portainer-ce:latest Pulled                                                                         9.1s
 ✔ Container task5-portainer-1         Created                                                                        0.0s
Attaching to portainer-1
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/cmd/portainer/main.go:361 > encryption key file not present | filename=/run/secrets/portainer
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/cmd/portainer/main.go:399 > proceeding without encryption key |
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/database/boltdb/db.go:163 > loading PortainerDB | filename=portainer.db
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/internal/ssl/ssl.go:79 > no cert files found, generating self signed SSL certificates |
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/http/security/setuptoken/setuptoken.go:40 > 
portainer-1  | 
portainer-1  | ==========================
portainer-1  | 
portainer-1  | setup_token=033d2c7d12cb9a365f398ec3231cce2051bb7b14587108727929d8b54e796a50
portainer-1  | 
portainer-1  | Paste it into the setup screen, or send it in the X-Setup-Token header.
portainer-1  | Start with --no-setup-token to disable.
portainer-1  | 
portainer-1  | ========================== |
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/chisel/service.go:229 > generated a new Chisel private key file | private-key=/data/chisel/private-key.pem
portainer-1  | 2026/09/15 21:22:23 server: Reverse tunnelling enabled
portainer-1  | 2026/09/15 21:22:23 server: Fingerprint CUzZ5XINhn7QEtaikf2tIftye8QaBzkurZU+1xNeB98=
portainer-1  | 2026/09/15 21:22:23 server: Listening on http://0.0.0.0:8000
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/cmd/portainer/main.go:707 > starting Portainer | build_number=36 go_version=go1.26.6 image_tag=2.45.0-linux-amd64 nodejs_version=v22.23.2 pnpm_version=10.27.0 version=2.45.0 webpack_version=5.107.2
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/http/server.go:371 > starting HTTPS server | bind_address=:9443
portainer-1  | 2026/09/15 09:22PM INF github.com/portainer/portainer/api/http/server.go:355 > starting HTTP server | bind_address=:9000
portainer-1  | 2026/09/15 09:27PM INF github.com/portainer/portainer/api/adminmonitor/admin_monitor.go:60 > the Portainer instance timed out 

# (1) по выводу ясно что запустился compose.yaml
# Объяснение из шпаргалки в первом абзаце:
# The default path for a Compose file is compose.yaml (preferred) 
# or compose.yml that is placed in the working directory. Compose 
# also supports docker-compose.yaml and docker-compose.yml for 
# backwards compatibility of earlier versions. If both files 
# exist, Compose prefers the canonical compose.yaml.

# То есть поддержка старых имен файлов оставлена для обратной 
# совместимости, но если есть compose.yaml - будет использован он.

# (2) Отредактируйте файл compose.yaml так, чтобы были запущенны 
# оба файла. (подсказка:

ijin@alt 🐳 /tmp/netology/docker/task5
$ vim compose.yaml 
ijin@alt 🐳 /tmp/netology/docker/task5
$ cat compose.yaml 
version: "3"
include:
  - docker-compose.yaml
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

# Теперь видно что запустились оба, registry-1 тоже стартовал

# (3) Выполните в консоли вашей хостовой ОС необходимые команды чтобы 
# залить образ custom-nginx как custom-nginx:latest в запущенное вами, 
# локальное registry. Дополнительная документация: 
# https://distribution.github.io/distribution/about/deploying/

docker build -t custom-nginx:latest .
docker tag custom-nginx:latest localhost:5000/custom-nginx
docker push localhost:5000/custom-nginx

# (4) Откройте страницу "https://127.0.0.1:9000" и произведите 
# начальную настройку portainer.(логин и пароль адмнистратора)
# Скриншот:
# 05-virt-03-docker-intro/Screenshots/Portainer init setup 2 2026-09-15 23-51-31.png

# (5) Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше 
# local окружение. Перейдите на вкладку "stacks" и в "web editor" 
# задеплойте следующий компоуз:

# (6) Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", 
# выберите контейнер с nginx и нажмите на кнопку "inspect". 
# В представлении <> Tree разверните поле "Config" и сделайте 
# скриншот от поля "AppArmorProfile" до "Driver".
# Скриншоты:
# 05-virt-03-docker-intro/Screenshots/Inspect-custom-nginx1 2026-09-15 23-58-25.png
# 05-virt-03-docker-intro/Screenshots/Inspect-custom-nginx2 2026-09-15 23-59-03.png
# 05-virt-03-docker-intro/Screenshots/Inspect-custom-nginx3 2026-09-16 00-00-18.png

# (7) Удалите любой из манифестов компоуза(например compose.yaml). 
# Выполните команду "docker compose up -d". Прочитайте warning, объясните 
# суть предупреждения и выполните предложенное действие. Погасите 
# compose-проект ОДНОЙ(обязательно!!) командой.
ijin@alt 🐳 /tmp/netology/docker/task5
$ ls 
compose.yaml  docker-compose.yaml
ijin@alt 🐳 /tmp/netology/docker/task5
$ mv docker-compose.yaml dcremoved
ijin@alt 🐳 /tmp/netology/docker/task5
$ docker compose up -d
open /tmp/netology/docker/task5/docker-compose.yaml: no such file or directory

# ^^ Значит не нашел файл на который ссылается compose.yaml

ijin@alt 🐳 /tmp/netology/docker/task5
$ docker compose stats
open /tmp/netology/docker/task5/docker-compose.yaml: no such file or directory

ijin@alt 🐳 /tmp/netology/docker/task5
$ ls
compose.yaml  dcremoved

ijin@alt 🐳 /tmp/netology/docker/task5
$ mv dcremoved docker-compose.yaml

ijin@alt 🐳 /tmp/netology/docker/task5
$ ls
compose.yaml  docker-compose.yaml

ijin@alt 🐳 /tmp/netology/docker/task5
$ mv compose.yaml copremoved

ijin@alt /tmp/netology/docker/task5
$ ls
copremoved  docker-compose.yaml

ijin@alt /tmp/netology/docker/task5
$ docker compose up -d
WARN[0000] /tmp/netology/docker/task5/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
WARN[0000] Found orphan containers ([task5-portainer-1]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.

# ^^ Говорит что аттрибут версия устарел и будет проигнорирован, удалите во избежание путаницы
# ^^2 Говорит найден контейнер-сирота (!) для этого проекта, если вы удалили или переименовали
# этот сервис в вашем компоуз-файле, можете запуститься с флагом "удалить сирот" для очистки..

# погасил проект
ijin@alt /tmp/netology/docker/task5
$ docker compose down
WARN[0000] /tmp/netology/docker/task5/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] down 2/2
 ✔ Container task5-registry-1 Removed                                                                                 0.1s
 ✔ Network task5_default      Removed

# Удалаил версию и перезапустился с флагом..
ijin@alt /tmp/netology/docker/task5
$ ls
copremoved  docker-compose.yaml

ijin@alt /tmp/netology/docker/task5
$ cp docker-compose.yaml dcremoved

ijin@alt /tmp/netology/docker/task5
$ ls
copremoved  dcremoved  docker-compose.yaml

ijin@alt /tmp/netology/docker/task5
$ vim docker-compose.yaml 

ijin@alt /tmp/netology/docker/task5
$ cat docker-compose.yaml 
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"

ijin@alt /tmp/netology/docker/task5
$ ls
copremoved  dcremoved  docker-compose.yaml

ijin@alt /tmp/netology/docker/task5
$ docker compose up -d --remove-orphans
[+] up 3/3
 ✔ Network task5_default       Created                                                                                0.0s
 ✔ Container task5-portainer-1 Removed                                                                                0.0s
 ✔ Container task5-registry-1  Created                                                                                0.0s

# Скриншот финальный
# 05-virt-03-docker-intro/Screenshots/Last console screen 2026-09-16 00-15-25.png




```
