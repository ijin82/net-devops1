# Итоговая работа «Виртуализация и контейнеризация» и «Облачная инфраструктура. Terraform».

## Задание 1

**Развертывание инфраструктуры в Yandex Cloud.**

- Создайте Virtual Private Cloud (VPC). + сделано
- Создайте подсети. + одна для ВМ с внешними подключениями и одна для тех у кого внутренние подключения
- Создайте виртуальные машины (VM):
  - Настройте группы безопасности (порты 22, 80, 443). + настроено
  - Привяжите группу безопасности к VM. + сделано
  - Опишите создание БД MySQL в Yandex Cloud. + сделано, через yandex_mdb_mysql_cluster
  - Опишите создание Container Registry +

  Репозиторий с демонстрационным приложением: [https://github.com/ijin82/laravel-demo-app](https://github.com/ijin82/laravel-demo-app)

  ```bash
  # Создали реестр
  ijin@tatuin 🛠️ git:master ~/Work/net-devops1/Terraform/diplom1/src
  $ yc container registry create --name wm1
  done (31s)
  id: crptgi2fo8ar5p0pguff
  folder_id: b1gl6j5lv636j3ekvebc
  name: wm1
  status: ACTIVE
  created_at: "2026-11-24T05:41:20.678Z"

  # Configure docker to use Yandex Cloud credential helper
  ijin@tatuin 🛠️ git:master ~/Work/net-devops1/Terraform/diplom1/src
  $ yc container registry configure-docker
  docker configured to use yc --profile "default" for authenticating "cr.yandex" container registries
  Credential helper is configured in '/home/ijin/.docker/config.json'

  # тегируем контейнер приложения
  ijin@tatuin 🛠️ git:main ~/Work/demo-laravel-app
  $ docker tag wired-mind/php:latest   cr.yandex/crptgi2fo8ar5p0pguff/wired-mind-app:1.0.0

  # тегируем контейнер с nginx
  ijin@tatuin 🛠️ git:main ~/Work/demo-laravel-app
  $ docker tag wired-mind/nginx:latest cr.yandex/crptgi2fo8ar5p0pguff/wired-mind-web:1.0.0

  # отправляем в реестр контейнер приложения
  ijin@tatuin 🛠️ git:main ~/Work/demo-laravel-app
  $ docker push cr.yandex/crptgi2fo8ar5p0pguff/wired-mind-app:1.0.0
  The push refers to repository [cr.yandex/crptgi2fo8ar5p0pguff/wired-mind-app]
  cc563f743bc4: Pushed 
  a314abad252d: Pushed 
  ...
  75f1d9657d88: Pushed 
  1.0.0: digest: sha256:9910ad539578bf95f6234ccd6b52a99da9765a83d15770fbb16cec365dd55ef6 size: 4073

  # отправляем в реестр контейнер с nginx
  ijin@tatuin 🛠️ git:main ~/Work/demo-laravel-app
  $ docker push cr.yandex/crptgi2fo8ar5p0pguff/wired-mind-web:1.0.0
  The push refers to repository [cr.yandex/crptgi2fo8ar5p0pguff/wired-mind-web]
  ae5a34206d0c: Pushed 
  5415bd25abf6: Pushed 
  ...
  29df493baa13: Pushed 
  1.0.0: digest: sha256:00b4840f337a2d48c11dd04578db78d1d10d229fdd1cd08782bf3c9878f3d865 size: 2611

  # разрешаем для всех pull 
  ijin@tatuin 🛠️ git:main ~/Work/demo-laravel-app
  $ yc container registry add-access-binding "crptgi2fo8ar5p0pguff" \
    --role container-registry.images.puller \
    --subject system:allUsers
  done (4s)
  ```

### Решение (1)

- Всего будет 1 сервис (MySQL cluster) + настроенная виртуальная машина для приложения + виртуальная машина для редиса + образ приложения в registry
- Для mysql надо сервисному аккаунту добавить роли в каталоге: managed-mysql.admin


**REM:** пробовал использовать redis managed но отказался потому что прямо долго ставится (больше 15 мин и падает).

**REM2:** Кластера ставятся очень долго, каждый тест отнимает по 20-30 мин. Нужно ещё несколько часов чтобы закончить.  

**REM3:** Дикость в том что некоторые IP адреса которые выдаёт Яндекс - сразу же заблокированы на моей стороне и работают только через vpn.

## Задание 2

Используя user-data (cloud-init), установите Docker и Docker Compose (см. Задания 5 модуля «Виртуализация и контейнеризация»).

### Решение (2)

Сделано

## Задание 3

Опишите Docker файл (см. Задания 5 «Виртуализация и контейнеризация») c web-приложением и сохраните контейнер в Container Registry.

### Решение (3)

В демонстрационном репозитории:  
`docker-compose.yml`  
`docker/nginx/Dockerfile`  
`docker/php/Dockerfile`  

## Задание 4

Завяжите работу приложения в контейнере на БД в Yandex Cloud.

### Решение (4)

Заработало, подключено к managed MySQL.

## Задание 5*

Положите пароли от БД в LockBox и настройте интеграцию с Terraform так, чтобы пароль для БД брался из LockBox.

### Решение (5)

Пока нет
