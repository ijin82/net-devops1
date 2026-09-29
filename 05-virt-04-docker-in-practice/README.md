# Домашнее задание к занятию 5. «Практическое применение Docker»

## Задача 0

- Убедитесь что у вас НЕ(!) установлен docker-compose, для этого получите следующую ошибку от команды docker-compose --version  

  Ок, все в порядке, docker-compose в системе давно нет.  

  ```bash
  ijin@tatuin 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker compose version
  Docker Compose version 5.0.2
  ```

- Убедитесь что у вас УСТАНОВЛЕН docker compose(без тире) версии не менее v2.24.X, для это выполните команду docker compose version  

  Да, все ок.

## Задача 1

- Сделайте в своем GitHub пространстве fork репозитория.  
  
  Есть форк, [https://github.com/ijin82/shvirtd-example-python](https://github.com/ijin82/shvirtd-example-python)

- Создайте файл `Dockerfile.python` на основе существующего `Dockerfile`:
  - Используйте базовый образ python:3.12-slim
  - Обязательно используйте конструкцию COPY . . в Dockerfile

  См. Dockerfile.python в форке тренировочного
  - Создайте .dockerignore файл для исключения ненужных файлов

  Вот зачем нужен этот файл:
  ```text
  Ускоряет билд за счёт меньшего контекста.
  При docker build вся папка (контекст) сначала упаковывается в tar‑архив и отправляется демону Docker. Если там .git, node_modules, venv, логи, тесты — это десятки/сотни мегабайт лишнего. На ALT Linux с не самым быстрым диском это реально заметно.
  
  Не ломает кэш слоёв.
  Если в контекст попадает папка с временными файлами, которые постоянно меняются (например, __pycache__, логи), Docker может считать, что контекст изменился, и сбрасывать кэш даже тогда, когда ты трогал только main.py.
  
  Делает образ меньше.
  Всё, что в контексте и не исключено, потенциально может быть скопировано в образ (если в Dockerfile есть COPY . . или копирование подпапок). .dockerignore гарантирует, что этого не случится.
  
  Безопасность.
  Ты не хочешь случайно скопировать .env, ключи, конфиги IDE, историю команд и т. п. в образ, который потом может уехать в реестр или на чужую ВМ в Yandex Cloud.
  
  Чистота для CI/CD и Swarm.
  В пайплайнах важен размер контекста и предсказуемость. Меньше мусора — меньше шансов на странные баги и лишние слои.
  ```
  - Используйте CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"] для запуска
  - Протестируйте корректность сборки 2.1 Используйте multistage сборку вместо single stage.
- (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker, с помощью venv. (Mysql БД можно запустить в docker run).

  ```bash
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ python3 -m venv venv
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ ll
  total 108K
  drwxr-xr-x 6 ijin ijin 4,0K Sep 29 10:53 ./
  drwxr-xr-x 8 ijin ijin 4,0K Sep 23 15:49 ../
  drwxr-xr-x 7 ijin ijin 4,0K Sep 29 10:50 .git/
  drwxr-xr-x 3 ijin ijin 4,0K Sep 23 15:49 haproxy/
  drwxr-xr-x 3 ijin ijin 4,0K Sep 23 15:49 nginx/
  drwxr-xr-x 5 ijin ijin 4,0K Sep 29 10:53 venv/
  -rw-r--r-- 1 ijin ijin 2,6K Sep 28 23:53 compose.yaml
  -rw-r--r-- 1 ijin ijin  241 Sep 23 15:49 Dockerfile
  -rw-r--r-- 1 ijin ijin 1002 Sep 28 17:34 Dockerfile.python
  -rw-r--r-- 1 ijin ijin  546 Sep 28 17:03 .dockerignore
  -rw-r--r-- 1 ijin ijin  126 Sep 28 23:51 .env
  -rw-r--r-- 1 ijin ijin 1,1K Sep 23 15:49 LICENSE
  -rw-r--r-- 1 ijin ijin 7,1K Sep 29 10:17 main.py
  -rw-r--r-- 1 ijin ijin  567 Sep 23 15:49 proxy.yaml
  -rw-r--r-- 1 ijin ijin 4,0K Sep 23 15:49 README.md
  -rw-r--r-- 1 ijin ijin   73 Sep 23 15:49 requirements.txt
  -rw-r--r-- 1 ijin ijin  39K Sep 23 15:49 schema.pdf
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ . venv/bin/activate
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ pip -i requirements.txt 
  
  Usage:   
    pip <command> [options]
  
  no such option: -i
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ pip install -r requirements.txt 
  Collecting fastapi==0.104.1 (from -r requirements.txt (line 1))
    Downloading fastapi-0.104.1-py3-none-any.whl.metadata (24 kB)
  Collecting uvicorn==0.24.0 (from uvicorn[standard]==0.24.0->-r requirements.txt (line 2))
    Downloading uvicorn-0.24.0-py3-none-any.whl.metadata (6.4 kB)
  Collecting mysql-connector-python==8.2.0 (from -r requirements.txt (line 3))
    Downloading mysql_connector_python-8.2.0-cp312-cp312-manylinux_2_17_x86_64.whl.metadata (2.1 kB)
  Collecting anyio<4.0.0,>=3.7.1 (from fastapi==0.104.1->-r requirements.txt (line 1))
    Downloading anyio-3.7.1-py3-none-any.whl.metadata (4.7 kB)
  Collecting pydantic!=1.8,!=1.8.1,!=2.0.0,!=2.0.1,!=2.1.0,<3.0.0,>=1.7.4 (from fastapi==0.104.1->-r requirements.txt (line 1))
    Downloading pydantic-2.13.5-py3-none-any.whl.metadata (110 kB)
  Collecting starlette<0.28.0,>=0.27.0 (from fastapi==0.104.1->-r requirements.txt (line 1))
    Downloading starlette-0.27.0-py3-none-any.whl.metadata (5.8 kB)
  Collecting typing-extensions>=4.8.0 (from fastapi==0.104.1->-r requirements.txt (line 1))
    Downloading typing_extensions-4.16.0-py3-none-any.whl.metadata (3.3 kB)
  Collecting click>=7.0 (from uvicorn==0.24.0->uvicorn[standard]==0.24.0->-r requirements.txt (line 2))
  
  # .....
  
  Downloading typing_inspection-0.4.4-py3-none-any.whl (14 kB)
  Installing collected packages: websockets, uvloop, typing-extensions, sniffio, pyyaml, python-dotenv, protobuf, idna, httptools, h11, click, annotated-types, uvicorn, typing-inspection, pydantic-core, mysql-connector-python, anyio, watchfiles, starlette, pydantic, fastapi
  Successfully installed annotated-types-0.8.0 anyio-3.7.1 click-8.5.0 fastapi-0.104.1 h11-0.16.0 httptools-0.8.0 idna-3.20 mysql-connector-python-8.2.0 protobuf-4.21.12 pydantic-2.13.5 pydantic-core-2.46.5 python-dotenv-1.2.3 pyyaml-6.0.3 sniffio-1.3.1 starlette-0.27.0 typing-extensions-4.16.0 typing-inspection-0.4.4 uvicorn-0.24.0 uvloop-0.22.1 watchfiles-1.3.0 websockets-17.1
  
  [notice] A new release of pip is available: 25.0.1 -> 26.2.1
  [notice] To update, run: pip install --upgrade pip
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2

  # Запускаем MySQL контейнер отдельно
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker run -d \
    --name db \
    --restart always \
    --env-file .env \
    -v db_data:/var/lib/mysql \
    -p 3306:3306 \
    mysql:8 --mysql-native-password=ON --authentication-policy=mysql_native_password
  69ce6e94b68fcae6764060fa01e7ba3eef7bdc6380620f824ef196e015103bfb
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker-ps
  CONTAINER ID   NAMES                                 IMAGE                      STATUS
  69ce6e94b68f   db                                    mysql:8                    Up 2 seconds
  66396683718a   net-devops1-docker2-web-1             net-devops1-docker2-web    Exited (0) 42 minutes ago
  30c3314c3890   net-devops1-docker2-db-1              mysql:8                    Exited (137) 42 minutes ago
  575f34a1b3ef   net-devops1-docker2-ingress-proxy-1   nginx:latest               Exited (0) 42 minutes ago
  42b6f03b426c   net-devops1-docker2-reverse-proxy-1   haproxy:2.4                Exited (0) 42 minutes ago
  dea7138439a4   jellyfin                              jellyfin/jellyfin:latest   Up 21 hours (healthy)
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2

  # Проблема с доступом

  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ uvicorn main:app --host 0.0.0.0 --port 5000 --reload
  INFO:     Will watch for changes in these directories: ['/home/ijin/Work/net-devops1-docker2']
  INFO:     Uvicorn running on http://0.0.0.0:5000 (Press CTRL+C to quit)
  INFO:     Started reloader process [1142721] using WatchFiles
  INFO:     Started server process [1142727]
  INFO:     Waiting for application startup.
  Приложение запускается...
  Ошибка при создании таблицы: 1045 (28000): Access denied for user 'app'@'172.17.0.1' (using password: YES)
  БД недоступна при старте. Таблица будет создана при первом запросе.
  INFO:     Application startup complete.
  ^CINFO:     Shutting down
  INFO:     Waiting for application shutdown.
  Приложение останавливается.
  INFO:     Application shutdown complete.
  INFO:     Finished server process [1142727]
  INFO:     Stopping reloader process [1142721]
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2

  # очистили БД и volume убрали

  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker stop db && docker rm db
  db
  db
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker volume rm db_data
  db_data
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2

  # запустили бд так

  docker run -d --name db \
    --restart always \
    -e MYSQL_ROOT_PASSWORD=YtReWq4321 -e MYSQL_DATABASE=virtd -e MYSQL_USER=app \
    -e MYSQL_PASSWORD=QwErTy1234 -e TABLE_NAME=my_requests -v db_data:/var/lib/mysql \
    -p 3306:3306 mysql:8 --mysql-native-password=ON --authentication-policy=mysql_native_password

  # переменные окружения для приложения
  (venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ export DB_HOST='127.0.0.1'
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ export DB_USER='app'  
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ export DB_PASSWORD='QwErTy1234'
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ export DB_NAME='virtd'
  ((venv) ) ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2

  # запустили приложение

  $ uvicorn main:app --host 0.0.0.0 --port 8090 --reload
  INFO:     Will watch for changes in these directories: ['/home/ijin/Work/net-devops1-docker2']
  INFO:     Uvicorn running on http://0.0.0.0:8090 (Press CTRL+C to quit)
  INFO:     Started reloader process [1172247] using WatchFiles
  INFO:     Started server process [1172250]
  INFO:     Waiting for application startup.
  Приложение запускается...
  Соединение с БД установлено и таблица 'requests' готова к работе.
  INFO:     Application startup complete.
  INFO:     127.0.0.1:45268 - "GET / HTTP/1.1" 200 OK
  INFO:     127.0.0.1:45268 - "GET / HTTP/1.1" 200 OK
  ^CINFO:     Shutting down
  INFO:     Waiting for application shutdown.
  Приложение останавливается.

  # Ответ http://127.0.0.1:8090
  # "TIME: 2026-09-29 11:22:03, IP: похоже, что вы направляете запрос в неверный порт(например curl http://127.0.0.1:5000). 
  # Правильное выполнение задания - отправить запрос в порт 8090."
  #
  # Тут как я понимаю чтобы вернуть нормальное поведение, надо либо поднимать его за прокси, 
  # либо в коде нужны правки, например переменная env которая отключит ветку с проверкой final_ip
  ```
- (Необязательная часть, *) Изучите код приложения и добавьте управление названием таблицы через ENV переменную.  

  Добавил в .env `TABLE_NAME` и подправил код, чтобы эту переменную использовать если она есть (f-строки)

> 💡
> ВНИМАНИЕ!  
> !!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 5 файлов: Dockerfile.python, compose.yaml, .gitignore, .dockerignore,bash-скрипт. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!

  Хорошо, понятно.

## Задача 2 (*)

  1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)  
  
  Ок, создал

  ```bash
  ijin@tatuin 🛠️  git:master ~/Work/net-devops1
  $ yc container registry create --name test
  done (1s)
  id: crp53ig029naies8v2ql
  folder_id: b1gl6j5lv636j3ekvebc
  name: test
  status: ACTIVE
  created_at: "2026-09-28T14:40:18.505Z
  ```

  2. Настройте аутентификацию вашего локального docker в yandex container registry.

  ```bash
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ yc container registry configure-docker
  docker configured to use yc --profile "default" for authenticating "cr.yandex" container registries
  Credential helper is configured in '/home/ijin/.docker/config.json'

  # В Yandex Container Registry формат имени такой:
  # cr.yandex/<registry-id>/<image-name>:<tag>
  # тег на образ
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker tag example-shvirtd-app:latest cr.yandex/crp53ig029naies8v2ql/example-shvirtd-app:latest
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  ```

  3. Соберите и залейте в него образ с python приложением из задания №1.

  Собрал, конфиги положил отдельно от кода, чтобы изменения кода не влияли на сборку при
  таких же зависимостях

  ```bash
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker build -t example-shvirtd-app:latest -f Dockerfile.python .
  [+] Building 0.2s (15/15) FINISHED                                                                                        docker:default
   => [internal] load build definition from Dockerfile.python                                                                         0.0s
   => => transferring dockerfile: 1.05kB                                                                                              0.0s
   => [internal] load metadata for docker.io/library/python:3.12-slim                                                                 0.2s
   => [internal] load .dockerignore                                                                                                   0.0s
   => => transferring context: 588B                                                                                                   0.0s
   => [mybuild 1/4] FROM docker.io/library/python:3.12-slim@sha256:f77ac9e44ae96ef2c90b8053ea08c31f8be030f824196b0ae4db6d462c84e51f   0.0s
   => [internal] load build context                                                                                                   0.0s
   => => transferring context: 64B                                                                                                    0.0s
   => CACHED [app 2/7] RUN useradd -m -u 1000 appuser                                                                                 0.0s
   => CACHED [app 3/7] WORKDIR /app                                                                                                   0.0s
   => CACHED [mybuild 2/4] WORKDIR /build                                                                                             0.0s
   => CACHED [mybuild 3/4] COPY requirements.txt .                                                                                    0.0s
   => CACHED [mybuild 4/4] RUN pip install --no-cache-dir -r requirements.txt                                                         0.0s
   => CACHED [app 4/7] COPY --from=mybuild /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages            0.0s
   => CACHED [app 5/7] COPY --from=mybuild /usr/local/bin /usr/local/bin                                                              0.0s
   => CACHED [app 6/7] COPY main.py .                                                                                                 0.0s
   => CACHED [app 7/7] RUN chown -R appuser:appuser /app                                                                              0.0s
   => exporting to image                                                                                                              0.0s
   => => exporting layers                                                                                                             0.0s
   => => writing image sha256:b8c0908eaaf6063ea0a2587defca51db8af6d078a327ece3d3ec1c7fc9dd989c                                        0.0s
   => => naming to docker.io/library/example-shvirtd-app:latest
  ```

  Проверка что ювикорн отвечает из такого образа

  ```bash
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker run --rm example-shvirtd-app:latest sh -c "which uvicorn && python -c 'import fastapi, uvicorn; print(\"OK\")'"
  /usr/local/bin/uvicorn
  OK
  ```

  Пуш образа

  ```bash
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker image list | grep example
  WARNING: This output is designed for human readability. For machine-readable output, please use --format.
  cr.yandex/crp53ig029naies8v2ql/example-shvirtd-app:latest   b8c0908eaaf6        272MB             0B        
  example-shvirtd-app:latest                                  b8c0908eaaf6        272MB             0B        
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker push cr.yandex/crp53ig029naies8v2ql/example-shvirtd-app:latest
  The push refers to repository [cr.yandex/crp53ig029naies8v2ql/example-shvirtd-app]
  ab53b34f0f90: Pushed 
  e176d3aa580c: Pushed 
  ab09de30ecc0: Pushed 
  a5a99735aa4e: Pushed 
  af99724ab267: Pushed 
  708e0f2a636b: Pushed 
  c321a426ca69: Pushed 
  b54011271bdb: Pushed 
  7ca599ccfc97: Pushed 
  a6dc765193a5: Pushed 
  latest: digest: sha256:27219b4dca2dab1e7606814a0eed015b8579ad507f9622f2b16f12cd61607cdc size: 2408
  ijin@tatuin 🐳 🛠️  git:main ~/Work/net-devops1-docker2
  ```

  4. Просканируйте образ на уязвимости.  
  Скриншоты:  
  05-virt-04-docker-in-practice/Screenshots/Scan 1 2026-09-28 18-05-01.png  
  05-virt-04-docker-in-practice/Screenshots/Scan 2 2026-09-28 18-05-27.png  
  05-virt-04-docker-in-practice/Screenshots/Scan 3 2026-09-28 18-05-58.png  

  5. В качестве ответа приложите отчет сканирования.  
  Отчет: 05-virt-04-docker-in-practice/vulnerabilities.csv

## Задача 3
1. Изучите файл "proxy.yaml"  
  ОК
2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".  
  OK
3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web```  
  OK

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!  
  OK

2. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете информационную ошибку --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.  

  Заработало, `compose` ругается что версия указана в proxy.yaml но сказано файлы не менять - я не стал исправлять.
  ```bash
  ijin@tatuin 🏠 ~
  $ curl -L http://127.0.0.1:8090
  "TIME: 2026-09-28 17:33:10, IP: 127.0.0.1"ijin@tatuin 🏠 ~
  $ curl -L http://127.0.0.1:8090
  "TIME: 2026-09-28 17:33:13, IP: 127.0.0.1"ijin@tatuin 🏠 ~
  $ 
```

5. Подключитесь к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию virtd, как это указано в .env)>; show tables; SELECT * from requests LIMIT 10;```. Примечание: таблица в БД создается после первого поступившего запроса к приложению.

OK

6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.  

Скриншоты:  
05-virt-04-docker-in-practice/Screenshots/DB Check 1 2026-09-28 19-40-50.png  
05-virt-04-docker-in-practice/Screenshots/DB Check 2 2026-09-28 19-41-41.png  

## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).  
  OK
2. Подключитесь к Вм по ssh и установите docker.  
  OK  
  Скриншоты:  
  05-virt-04-docker-in-practice/Screenshots/Yandex VM 1 2026-09-28 20-04-17.png  
  05-virt-04-docker-in-practice/Screenshots/Yandex VM 2 2026-09-28 20-04-38.png  
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.  
  Скрипт:
  05-virt-04-docker-in-practice/install-to-opt.sh
  
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy. Трафик должен пройти через цепочки: Пользователь → Internet → Nginx → HAProxy → FastAPI(запись в БД) → HAProxy → Nginx → Internet → Пользователь  
  OK  
5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
  
  ```bash
  # на локальной машине
  
  ijin@tatuin 🏠 ~
  ssh ijin_yc@111.88.151.207

  # на виртуалке (ubuntu 24.04)

  ijin_yc@netology-docker-context-test:~$ sudo apt-get install docker.io
  ijin_yc@netology-docker-context-test:~$ sudo usermod -aG docker ijin_yc
  # реконнект чтобы войти с группой
  ijin_yc@netology-docker-context-test:~$ docker ps                      
  CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

  # на локальной машине создаю контекст и переключаюсь на него

  ijin@tatuin 🏠 ~
  $ docker context ls
  NAME        DESCRIPTION                               DOCKER ENDPOINT               ERROR
  default *   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock   
  ijin@tatuin 🏠 ~
  $ docker context create vm1 --docker "host=ijin_yc@111.88.151.207"
  unable to create docker endpoint config: unable to apply docker endpoint options: unable to parse docker host `ijin_yc@111.88.151.207`
  ijin@tatuin 🏠 ~
  $ docker context create vm1 --docker "host=ssh://ijin_yc@111.88.151.207"
  vm1
  Successfully created context "vm1"
  ijin@tatuin 🏠 ~
  $ docker context ls
  NAME        DESCRIPTION                               DOCKER ENDPOINT                ERROR
  default *   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock    
  vm1                                                   ssh://ijin_yc@111.88.151.207   
  ijin@tatuin 🏠 ~
  $ docker context use vm1
  vm1
  Current context is now "vm1"
  ijin@tatuin 🏠 ~
  $ docker context ls
  NAME      DESCRIPTION                               DOCKER ENDPOINT                ERROR
  default   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock    
  vm1 *
  
  # выполняю команды в удаленном контексте 
  ijin@tatuin 🏠 ~
  $ docker context ls
  NAME      DESCRIPTION                               DOCKER ENDPOINT                ERROR
  default   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock    
  vm1 *                                               ssh://ijin_yc@111.88.151.207   
  ijin@tatuin 🏠 ~
  $ docker ps -a
  CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
  ijin@tatuin 🏠 ~
  $ docker --context=default ps -a
  CONTAINER ID   IMAGE                      COMMAND                  CREATED        STATUS                     PORTS                                                    NAMES
  51033cda08e6   mysql:8                    "docker-entrypoint.s…"   2 hours ago    Up 2 hours                 0.0.0.0:3306->3306/tcp, [::]:3306->3306/tcp, 33060/tcp   db
  66396683718a   net-devops1-docker2-web    "uvicorn main:app --…"   3 hours ago    Exited (0) 3 hours ago                                                              net-devops1-docker2-web-1
  30c3314c3890   mysql:8                    "docker-entrypoint.s…"   3 hours ago    Exited (137) 3 hours ago                                                            net-devops1-docker2-db-1
  575f34a1b3ef   nginx:latest               "/docker-entrypoint.…"   3 hours ago    Exited (0) 3 hours ago                                                              net-devops1-docker2-ingress-proxy-1
  42b6f03b426c   haproxy:2.4                "docker-entrypoint.s…"   3 hours ago    Exited (0) 3 hours ago                                                              net-devops1-docker2-reverse-proxy-1
  dea7138439a4   jellyfin/jellyfin:latest   "/jellyfin/jellyfin"     5 months ago   Up 23 hours (healthy)                                                               jellyfin
  ijin@tatuin 🏠 ~

  # работаю в контексте и переключаюсь
  ijin@tatuin 🏠 ~
  $ docker image ls

  IMAGE          ID             DISK USAGE   CONTENT SIZE   EXTRA

  nginx:latest   abe47724e466        242MB         66.3MB        

  ijin@tatuin 🏠 ~
  $ docker image rm nginx:latest
  Untagged: nginx:latest
  Deleted: sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2
  
  ijin@tatuin 🏠 ~
  $ docker context ls
  NAME      DESCRIPTION                               DOCKER ENDPOINT                ERROR
  default   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock    
  vm1 *                                               ssh://ijin_yc@111.88.151.207   
  
  ijin@tatuin 🏠 ~
  $ docker context use default
  default
  Current context is now "default"
  
  ijin@tatuin 🏠 ~
  $ docker context ls
  NAME        DESCRIPTION                               DOCKER ENDPOINT                ERROR
  default *   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock    
  vm1                                                   ssh://ijin_yc@111.88.151.207   
  
  ijin@tatuin 🏠 ~
  $ docker-ps
  CONTAINER ID   NAMES                                 IMAGE                      STATUS
  51033cda08e6   db                                    mysql:8                    Up 2 hours
  66396683718a   net-devops1-docker2-web-1             net-devops1-docker2-web    Exited (0) 3 hours ago
  30c3314c3890   net-devops1-docker2-db-1              mysql:8                    Exited (137) 3 hours ago
  575f34a1b3ef   net-devops1-docker2-ingress-proxy-1   nginx:latest               Exited (0) 3 hours ago
  42b6f03b426c   net-devops1-docker2-reverse-proxy-1   haproxy:2.4                Exited (0) 3 hours ago
  dea7138439a4   jellyfin                              jellyfin/jellyfin:latest   Up 24 hours (healthy)
  ijin@tatuin 🏠 ~

  # Скриншот: 05-virt-04-docker-in-practice/Screenshots/Docker context usage 2026-09-29 13-24-00.png
  ```


6. Повторите SQL-запрос на сервере и приложите скриншот и ссылку на fork.  
  Ссылка на fork:  
    https://github.com/ijin82/shvirtd-example-python.git  
  Скриншоты (ИП одинаковый!! Не правильно!!):  
    05-virt-04-docker-in-practice/Screenshots/Yandex VM DB 1 - BAD 2026-09-28 20-56-25.png  
    05-virt-04-docker-in-practice/Screenshots/Yandex VM DB 2 - BAD 2026-09-28 20-57-16.png  
    **Да нет, ВСЕ ПРАВИЛЬНО,** просто в начале таблицы куча моих тестов осталась  
    05-virt-04-docker-in-practice/Screenshots/DB CHECK Correct 2026-09-28 21-11-38.png

## Задача 5 (*)
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."  
  Скрипт:  
  05-virt-04-docker-in-practice/backup-db.sh  
2. Протестируйте ручной запуск  
  OK, проблемы с устаревшей аутентификацией  
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!  
  ОК, настройка крона от рута, файл настроек крона (crontab -l):  
  05-virt-04-docker-in-practice/crontab
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"  
  ОК, скриншот:  
  05-virt-04-docker-in-practice/Screenshots/Cron backup files 2026-09-28 21-56-07.png

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .

```bash
docker pull hashicorp/terraform:latest

docker save hashicorp/terraform:latest -o terraform.tar

tar -xf terraform.tar -C /tmp/terraform-extract

# дальше через mc
# Скриншот: 05-virt-04-docker-in-practice/Screenshots/Find terraform 2026-09-28 22-19-50.png
```

### Через dive

Скриншоты:  
  05-virt-04-docker-in-practice/Screenshots/dive 1 2026-09-28 22-28-12.png  
  05-virt-04-docker-in-practice/Screenshots/dive 2 2026-09-28 22-29-52.png  