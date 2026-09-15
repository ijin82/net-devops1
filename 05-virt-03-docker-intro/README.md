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
