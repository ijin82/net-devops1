# Домашнее задание к занятию «Введение в Terraform»

### Цели задания

1. Установить и настроить Terrafrom.
2. Научиться использовать готовый код.

------

### Чек-лист готовности к домашнему заданию

1. Скачайте и установите **Terraform** версии >=1.12.0 . Приложите скриншот вывода команды ```terraform --version```.  
  Готово, скриншот:  
  `Terraform/01/Screenshots/Terraform Version 2026-10-05 14-22-41.png`  
2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.  
  Готово, скриншот тот же (скопировал в этот репозиторий задание, потому что здесь все сдаю, если будет нужно - переложу файлы позже).  
3. Убедитесь, что в вашей ОС установлен docker.
  Да, установлен, ОК  
  ```bash
  ijin@tatuin 🏠 ~
  $ docker --version
  Docker version 29.2.1, build a5c7197
  ijin@tatuin 🏠 ~
  $ docker compose version
  Docker Compose version 5.0.2
  ```
------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Репозиторий с ссылкой на зеркало для установки и настройки Terraform: [ссылка](https://github.com/netology-code/devops-materials).
2. Установка docker: [ссылка](https://docs.docker.com/engine/install/ubuntu/).  
  Ок, принято, все нужное есть.
------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте.  
  Готово, но пришлось скопировать `.terraformrc -> ~/.terraformrc` чтобы использовать установку с зеркала  
  Скриншоты:  
  `Terraform/01/Screenshots/TF Install provider issue 1 2026-10-05 14-35-40.png`  
  `Terraform/01/Screenshots/TF Install provider issue 2 2026-10-05 14-35-56.png`  
2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)  
  Как я понял - этой файл `personal.auto.tfvars` (`*.auto.tfvars` — то же, что и `terraform.tfvars` только `terraform.tfvars` **НЕ загрузится** автоматически в отличие от `*.auto.tfvars`, секреты могут быть и там и там)  
  Если выполнить принудительно `terraform apply -var-file=terraform.tfvars` то переменные из `terraform.tfvars` имеют приоритет над переменными использованными в `*.auto.tfvars` то есть в этом случае при выполнении сценария тераформ будут использованы переменные из `terraform.tfvars` если их названия были перекрыты в `*.auto.tfvars`, остальное будет взято из `*.auto.tfvars`
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.  
  Путь до ключа:  

  ```text
  resources[0].instances[0].attributes.result = "taCXqSOO9W8CwCsy"
  ```

  Скриншот: `Terraform/01/Screenshots/Random password key 2026-10-05 18-01-01.png`  

4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.   
  Ошибки:  
  ```text
  ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform validate
╷
│ Error: Missing name for resource
│ 
│   on main.tf line 25, in resource "docker_image":
│   25: resource "docker_image" {
│ 
│ All resource blocks must have 2 labels (type, name).
╵
## ^^ Здесь НЕ указано ИМЯ ресурса, нам подсказывают что все блоки ресурсов ДОЛЖНЫ
## именть label и название (name), которое не указано в примере, исправлю так:
## resource "docker_image" "nginx"{
╷
│ Error: Invalid resource name
│ 
│   on main.tf line 30, in resource "docker_container" "1nginx":
│   30: resource "docker_container" "1nginx" {
│ 
│ A name must start with a letter or underscore and may contain only letters, digits, underscores, and dashes.

## ^^ Здесь наружено правило именование, не может название начинаться с цифры - может только с буквы или 
## знака подчеркивания, исправлю так: 
## resource "docker_container" "nginx"
  ```
  Новая итерация:  
  ```text
  ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform validate
╷
│ Error: Reference to undeclared resource
│ 
│   on main.tf line 32, in resource "docker_container" "nginx":
│   32:   name  = "example_${random_password.random_string_FAKE.resulT}"
│ 
│ A managed resource "random_password" "random_string_FAKE" has not been declared in the root module.
╵

## ^^ Здесь нам говорят что ресурс с путем поиска "random_password" "random_string_FAKE"
## не определен в главном модуле, исправлю так (потому что name указан просто random_string, а не random_string_FAKE):
## "random_password" "random_string" 
  ```
  Новая итерация:
  ```text
  ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform validate
╷
│ Error: Unsupported attribute
│ 
│   on main.tf line 32, in resource "docker_container" "nginx":
│   32:   name  = "example_${random_password.random_string.resulT}"
│ 
│ This object has no argument, nested block, or exported attribute named "resulT". Did you mean "result"?
╵

## ^^ Здесь нам говорят что у объекта нет аргумента или внутреннего блока или экспортируемого аттрибута
## с именем "resulT" и подсказывают что мы видимо должны были сослаться на "result" то есть имена и метки
## чувствительны к регистру, на это стоит образать внимание. Исправлю так:
## name  = "example_${random_password.random_string.result}"
  ```
  Контрольная итерация:  
  ```bash
  ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform validate
Success! The configuration is valid.
  ```

5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.  
  Исправленный код:  

  ```terraform
  terraform {
    required_providers {
      docker = {
        source  = "kreuzwerker/docker"
      }
    }
    required_version = "~>1.16.0" 
    /*
      Многострочный комментарий.
      Требуемая версия terraform
    */
  }
  provider "docker" {}
  
  # однострочный комментарий
  
  resource "random_password" "random_string" {
    length      = 16
    special     = false
    min_upper   = 1
    min_lower   = 1
    min_numeric = 1
  }
  
  resource "docker_image" "nginx"{
    name         = "nginx:latest"
    keep_locally = true
  }
  
  resource "docker_container" "nginx" {
    image = docker_image.nginx.image_id
    name  = "example_${random_password.random_string.result}"
  
    ports {
      internal = 80
      external = 9090
    }
  }
  ```

  Выполняем `terraform apply` и смотрим `docker ps`  
  ```bash
  ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform apply
random_password.random_string: Refreshing state... [id=none]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # docker_container.nginx will be created

  # ...
  # ...

  ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS                 PORTS                  NAMES
0a98ec83a61d   e9567a94eddc               "/docker-entrypoint.…"   5 minutes ago   Up 5 minutes           0.0.0.0:9090->80/tcp   example_taCXqSOO9W8CwCsy
dea7138439a4   jellyfin/jellyfin:latest   "/jellyfin/jellyfin"     6 months ago    Up 9 hours (healthy)                          jellyfin
  ```

6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.  
```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform apply -auto-approve
docker_image.nginx: Refreshing state... [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]
random_password.random_string: Refreshing state... [id=none]
docker_container.nginx: Refreshing state... [id=0a98ec83a61db069bc4f399d1b690cc70f0aa68e7edf4068968d5f3d92eb629b]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # docker_container.nginx must be replaced
-/+ resource "docker_container" "nginx" {
      + bridge                                      = (known after apply)
      ~ command                                     = [
          - "nginx",
          - "-g",
          - "daemon off;",
        ] -> (known after apply)
      + container_logs                              = (known after apply)
      - cpu_shares                                  = 0 -> null
      - device_cgroup_rules                         = [] -> null
      - dns                                         = [] -> null
      - dns_opts                                    = [] -> null
      - dns_search                                  = [] -> null
      ~ entrypoint                                  = [
          - "/docker-entrypoint.sh",
        ] -> (known after apply)
      ~ env                                         = [] -> (known after apply)
      + exit_code                                   = (known after apply)
      - group_add                                   = [] -> null
      ~ hostname                                    = "0a98ec83a61d" -> (known after apply)
      ~ id                                          = "0a98ec83a61db069bc4f399d1b690cc70f0aa68e7edf4068968d5f3d92eb629b" -> (known after apply)
      ~ init                                        = false -> (known after apply)
      ~ ipc_mode                                    = "private" -> (known after apply)
      ~ log_driver                                  = "journald" -> (known after apply)
      - log_opts                                    = {} -> null
      - max_retry_count                             = 0 -> null
      - memory                                      = 0 -> null
      - memory_swap                                 = 0 -> null
      # Warning: this attribute value will no longer be marked as sensitive
      # after applying this change.
      ~ name                                        = (sensitive value) # forces replacement
      ~ network_data                                = [
          - {
              - gateway                   = "172.17.0.1"
              - global_ipv6_prefix_length = 0
              - ip_address                = "172.17.0.3"
              - ip_prefix_length          = 16
              - mac_address               = "72:65:29:0e:83:c8"
              - network_name              = "bridge"
                # (2 unchanged attributes hidden)
            },
        ] -> (known after apply)
      ~ platform                                    = "linux" -> (known after apply)
      - privileged                                  = false -> null
      - publish_all_ports                           = false -> null
      ~ runtime                                     = "docker-runc" -> (known after apply)
      ~ security_opts                               = [] -> (known after apply)
      ~ shm_size                                    = 64 -> (known after apply)
      ~ stop_signal                                 = "SIGQUIT" -> (known after apply)
      ~ stop_timeout                                = 0 -> (known after apply)
      - storage_opts                                = {} -> null
      - sysctls                                     = {} -> null
      - tmpfs                                       = {} -> null
        # (21 unchanged attributes hidden)

      ~ healthcheck (known after apply)

      ~ labels (known after apply)

        # (1 unchanged block hidden)
    }

Plan: 1 to add, 0 to change, 1 to destroy.
docker_container.nginx: Destroying... [id=0a98ec83a61db069bc4f399d1b690cc70f0aa68e7edf4068968d5f3d92eb629b]
docker_container.nginx: Destruction complete after 1s
docker_container.nginx: Creating...
docker_container.nginx: Creation complete after 0s [id=85658a12c837acf4049117f555fdd1a3dc60aff712cba5aee61d5930fd2dcd2a]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED         STATUS                 PORTS                  NAMES
85658a12c837   e9567a94eddc               "/docker-entrypoint.…"   9 seconds ago   Up 8 seconds           0.0.0.0:9090->80/tcp   hello_wold
dea7138439a4   jellyfin/jellyfin:latest   "/jellyfin/jellyfin"     6 months ago    Up 9 hours (healthy)                          jellyfin
```

**Объясните своими словами, в чём может быть опасность применения ключа -auto-approve**  
Я предполагаю что опасность в том, что так нам не предложит apply проверить изменения которые он запланировал и мы потеряем эту дополнительную проверку перед применением изменений которые могут оказаться критичными для системы, могут вызвать ошибку.  
**-- Гуллю ответ --**  
**Пропустишь удаление важных ресурсов.** Terraform может показать в плане «destroy» для базы данных, балансировщика или бакета с данными, а ты этого не увидишь. С флагом изменения применятся мгновенно — и ресурс исчезнет. Учитывая твой опыт с MySQL в Docker и резервными копиями: потеря БД без возможности быстрого восстановления — это критично.  
**Не заметишь неожиданные изменения.** Иногда из-за правки одной переменной меняется тип инстанса, группа безопасности, подсеть или IAM-политика. В обычном режиме ты видишь план и сразу замечаешь «ой, тут меняется security group». С -auto-approve изменения применяются «вслепую».  
**Ошибки в конфигурации сработают сразу.** Если в коде ошибка, которая приводит к некорректному созданию ресурса или его удалению, Terraform всё равно попытается это сделать. В CI/CD это может «уронить» среду и вызвать простой.  
**Риск при параллельных запусках.** Если два человека (или два пайплайна) одновременно меняют состояние, а бэкенд не имеет блокировки или она не сработала, можно получить рассинхронизацию и непредсказуемые изменения.  
**Проблемы с правами и аудитом.** В крупных средах изменения должны проходить ревью и иметь явное подтверждение ответственного. -auto-approve убирает этот слой контроля, усложняя разбор инцидентов.  

**ВЫВОД:** не пользоваться флагом `-auto-approve`, без осмысленной необходимости, не иметь такой привычки вовсе, во избежание аварий связанных с отсутствием самопроверки перед запуском изменений.

8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 
```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform destroy
docker_image.nginx: Refreshing state... [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]
random_password.random_string: Refreshing state... [id=none]
docker_container.nginx: Refreshing state... [id=85658a12c837acf4049117f555fdd1a3dc60aff712cba5aee61d5930fd2dcd2a]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  - destroy

Terraform will perform the following actions:

  # docker_container.nginx will be destroyed
  - resource "docker_container" "nginx" {
      - attach                                      = false -> null
      - command                                     = [
          - "nginx",
          - "-g",
          - "daemon off;",
        ] -> null
      - container_read_refresh_timeout_milliseconds = 15000 -> null
      - cpu_shares                                  = 0 -> null
      - device_cgroup_rules                         = [] -> null
      - dns                                         = [] -> null
      - dns_opts                                    = [] -> null
      - dns_search                                  = [] -> null
      - entrypoint                                  = [
          - "/docker-entrypoint.sh",
        ] -> null
      - env                                         = [] -> null
      - group_add                                   = [] -> null
      - hostname                                    = "85658a12c837" -> null
      - id                                          = "85658a12c837acf4049117f555fdd1a3dc60aff712cba5aee61d5930fd2dcd2a" -> null
      - image                                       = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6" -> null
      - init                                        = false -> null
      - ipc_mode                                    = "private" -> null
      - log_driver                                  = "journald" -> null
      - log_opts                                    = {} -> null
      - logs                                        = false -> null
      - max_retry_count                             = 0 -> null
      - memory                                      = 0 -> null
      - memory_reservation                          = 0 -> null
      - memory_swap                                 = 0 -> null
      - must_run                                    = true -> null
      - name                                        = "hello_wold" -> null
      - network_data                                = [
          - {
              - gateway                   = "172.17.0.1"
              - global_ipv6_prefix_length = 0
              - ip_address                = "172.17.0.2"
              - ip_prefix_length          = 16
              - mac_address               = "b6:e3:07:b7:25:63"
              - network_name              = "bridge"
                # (2 unchanged attributes hidden)
            },
        ] -> null
      - network_mode                                = "bridge" -> null
      - platform                                    = "linux" -> null
      - privileged                                  = false -> null
      - publish_all_ports                           = false -> null
      - read_only                                   = false -> null
      - remove_volumes                              = true -> null
      - restart                                     = "no" -> null
      - rm                                          = false -> null
      - runtime                                     = "docker-runc" -> null
      - security_opts                               = [] -> null
      - shm_size                                    = 64 -> null
      - start                                       = true -> null
      - stdin_open                                  = false -> null
      - stop_signal                                 = "SIGQUIT" -> null
      - stop_timeout                                = 0 -> null
      - storage_opts                                = {} -> null
      - sysctls                                     = {} -> null
      - tmpfs                                       = {} -> null
      - tty                                         = false -> null
      - wait                                        = false -> null
      - wait_timeout                                = 60 -> null
        # (6 unchanged attributes hidden)

      - ports {
          - external = 9090 -> null
          - internal = 80 -> null
          - ip       = "0.0.0.0" -> null
          - protocol = "tcp" -> null
        }
    }

  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id           = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest" -> null
      - image_id     = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6" -> null
      - keep_locally = true -> null
      - name         = "nginx:latest" -> null
      - repo_digest  = "nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2" -> null
    }

  # random_password.random_string will be destroyed
  - resource "random_password" "random_string" {
      - bcrypt_hash = (sensitive value) -> null
      - id          = "none" -> null
      - length      = 16 -> null
      - lower       = true -> null
      - min_lower   = 1 -> null
      - min_numeric = 1 -> null
      - min_special = 0 -> null
      - min_upper   = 1 -> null
      - number      = true -> null
      - numeric     = true -> null
      - result      = (sensitive value) -> null
      - special     = false -> null
      - upper       = true -> null
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

random_password.random_string: Destroying... [id=none]
random_password.random_string: Destruction complete after 0s
docker_container.nginx: Destroying... [id=85658a12c837acf4049117f555fdd1a3dc60aff712cba5aee61d5930fd2dcd2a]
docker_container.nginx: Destruction complete after 0s
docker_image.nginx: Destroying... [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]
docker_image.nginx: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.

ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ docker ps
CONTAINER ID   IMAGE                      COMMAND                CREATED        STATUS                 PORTS     NAMES
dea7138439a4   jellyfin/jellyfin:latest   "/jellyfin/jellyfin"   6 months ago   Up 9 hours (healthy)             jellyfin

ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ docker image ls | grep nginx
WARNING: This output is designed for human readability. For machine-readable output, please use --format.
ijin82/custom-nginx:1.0.0                                   5a388b811cda        192MB             0B        
nginx:1.29.0                                                7a073be66c4c        192MB             0B        
nginx:alpine                                                1b595815db66         69MB             0B   U    
nginx:latest                                                e9567a94eddc        162MB             0B   U 
```

Содержимое `terraform.tfstate`  

```json
{
  "version": 4,
  "terraform_version": "1.16.5",
  "serial": 11,
  "lineage": "c0e6966b-6582-a4f2-a532-01ef336201df",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

9. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://library.tf/providers/kreuzwerker/docker/latest).  (ищите в классификаторе resource docker_image )  

В документации [тут](https://library.tf/providers/kreuzwerker/docker/latest/docs/resources/image) говорится
что:

```text
force_remove (Boolean) If true, then the image is removed forcibly when the resource is destroyed.
keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
```

При этом при destroy мы видели что:

```text
  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id           = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest" -> null
      - image_id     = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6" -> null
      - keep_locally = true -> null
      - name         = "nginx:latest" -> null
      - repo_digest  = "nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2" -> null
    }
```

В выводе `destroy` перед подтверждением единственная строка которую я заподозрил, была

```text
- keep_locally = true -> null
```

Но без документации я подумал что image будет скачан в какое-то отдельное локальное хранилище тераформа, с документацией стало ясно что `keep_locally` это флаг который по умотчанию запрещает локальное удаление имиджей, для эксперимента я изменил его значение вот так:

```text
resource "docker_image" "nginx"{
  name         = "nginx:latest"
  # keep_locally = true
  keep_locally = false
}
```

Вызвал `terraform destroy` и все так же в описании будущих действий увидел

```text
  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id           = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest" -> null
      - image_id     = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6" -> null
      - keep_locally = true -> null
      - name         = "nginx:latest" -> null
      - repo_digest  = "nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2" -> null
    }
```

Очевидно дело в том что в `terraform.tfstate` указано

```text
resources[1].instances[0].attributes.keep_locally = true
```

Выполнил `terraform apply`  

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform apply
docker_image.nginx: Refreshing state... [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]
random_password.random_string: Refreshing state... [id=none]
docker_container.nginx: Refreshing state... [id=986ecbc2e035217e738b86f7e6a1570fa32a32b8f42ea986b9c1d2800d027cfa]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  ~ update in-place

Terraform will perform the following actions:

  # docker_image.nginx will be updated in-place
  ~ resource "docker_image" "nginx" {
        id           = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest"
      ~ keep_locally = true -> false
        name         = "nginx:latest"
        # (2 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_image.nginx: Modifying... [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]
docker_image.nginx: Modifications complete after 0s [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

И теперь `terraform destroy` показывает

```text
  # docker_image.nginx will be destroyed
  - resource "docker_image" "nginx" {
      - id           = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest" -> null
      - image_id     = "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6" -> null
      - keep_locally = false -> null
      - name         = "nginx:latest" -> null
      - repo_digest  = "nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2" -> null
    }
```

Все логично. В коде верну флаг keep_locally = true потому что команды его менять кажется нЕбыло.  
Интересно что удалить image все равно не получилось

```
ijin@tatuin ~/Work/net-devops1/Terraform/01/src
$ terraform destroy
random_password.random_string: Refreshing state... [id=none]
docker_image.nginx: Refreshing state... [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]
docker_container.nginx: Refreshing state... [id=986ecbc2e035217e738b86f7e6a1570fa32a32b8f42ea986b9c1d2800d027cfa]

## ...
## ...

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes 

random_password.random_string: Destroying... [id=none]
docker_container.nginx: Destroying... [id=986ecbc2e035217e738b86f7e6a1570fa32a32b8f42ea986b9c1d2800d027cfa]
random_password.random_string: Destruction complete after 0s
docker_container.nginx: Destruction complete after 0s
docker_image.nginx: Destroying... [id=sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest]
╷
│ Error: Unable to remove Docker image: Error response from daemon: conflict: unable to remove repository reference "nginx:latest" (must force) - container 575f34a1b3ef is using its referenced image e9567a94eddc
│ 
│ 
╵
```

И в terraform.tfstate осталось это

```json
{
  "version": 4,
  "terraform_version": "1.16.5",
  "serial": 21,
  "lineage": "c0e6966b-6582-a4f2-a532-01ef336201df",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "docker_image",
      "name": "nginx",
      "provider": "provider[\"registry.terraform.io/kreuzwerker/docker\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "build": [],
            "force_remove": null,
            "id": "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6nginx:latest",
            "image_id": "sha256:e9567a94eddcc1f293d083044d4c988b853fe17c2a462f343704bcb1ea01c9a6",
            "keep_locally": false,
            "name": "nginx:latest",
            "platform": null,
            "pull_triggers": null,
            "repo_digest": "nginx@sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2",
            "timeouts": null,
            "triggers": null
          },
          "sensitive_attributes": [],
          "identity_schema_version": 0,
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjoxMjAwMDAwMDAwMDAwLCJkZWxldGUiOjEyMDAwMDAwMDAwMDAsInVwZGF0ZSI6MTIwMDAwMDAwMDAwMH19"
        }
      ]
    }
  ],
  "check_results": null
}
```

Вернул флаг на место в `main.tf` -> `keep_locally = true` похоже по умолчанию он не true, так как при комментировании обоих флагов `destroy` снова попытался удалить image и не смог. Что стоит по умолчанию из документации не ясно.  

К "правильному" (без ошибок) удалению приведут флаги (закомментированы в примере из `main.tf`):

```text
resource "docker_image" "nginx"{
  name         = "nginx:latest"
  keep_locally = true
  #keep_locally = false
  #force_remove = true
}
```

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.** Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию.  

### Задание 2*

1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!  

  Скопировал из панели YC код сгенерированный для terraform - создание ВМ со всеми (кроме совсем секретных) идентификаторами в контексте моего аккаунта.  
  Из слайда 25 видно как подключить провайдера yandex  
  Спросил ИИшку как получить реквизиты (секретные ключи), оказалось что нужно создать сервисный аккаунт, но ключи которые там показывают в моем случае не нужны, их нужно сделать через yc cli вот так
  
  ```bash
  yc iam service-account list
  yc iam key create --service-account-id <ID> --output key.json
  ```

  После чего сгенерированный json нужно отдать провайдеру, точнее в этом случае это путь до ключевого файла, который я для примера сохранил в personal.auto.tfvars

  ```text
  ## в Terraform/01/star1/main.tf
  variable "yandex_sa_key_file" {
    sensitive = true
  }

  provider "yandex" {
    service_account_key_file = var.yandex_sa_key_file
  }

  ## в Terraform/01/star1/personal.auto.tfvars.example
  yandex_sa_key_file = "key.json"
  ```

  Тут я понял:  

- как хранить секретные ключи локально
- как их произвольно называть
- как их использовать в main.tf (в любых .tf видимо?)

В `Terraform/01/star1/main.tf` в сгенерированном коде либо есть неточности, либо я что-то ещё должен был настроить в панели управления YC

2. Подключитесь к ВМ по ssh и установите стек docker.

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/star1
$ ssh ijin@158.160.73.38
Welcome to Ubuntu 24.04.5 LTS (GNU/Linux 6.8.0-146-generic x86_64)
## ...
## ...
Last login: Tue Oct  6 11:07:57 2026 from 92.101.113.232
ijin@netology-terraform-star1:~$ docker --version
Docker version 29.1.3, build 29.1.3-0ubuntu3~24.04.2
ijin@netology-terraform-star1:~$
```

Готово, докер уже установлен через cloud-init

3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
  Это оказалось не сложно, просто нужно указать контекст в провайдере  
  Это написано прямо на главной странице [мануала](https://library.tf/providers/kreuzwerker/docker/latest)  
  `context (String) The name of the Docker context to use. Can also be set via DOCKER_CONTEXT environment variable. Overrides the host if set.`

  ```text
  provider "docker" {
    context = "vm-star1"
  }
  ```

  Но проблема в том что все сразу сделать не получится, надо как-то получить IP адрес созданной виртуалки и следующим шагом выполнить создание локального контекста, затем установку и настройку MySQL. Это возможно все сделать тераформом, используя "Двухфазный apply" (как я понял это частичное выполнение сценария тераформа), так рассказала ИИ, и выглядит это так примерно
  
  ```bash
  # Фаза 1: создаём ВМ и docker-контекст (docker-ресурсы пока пропускаются)
  terraform apply -target=null_resource.docker_context
  
  # Фаза 2: через готовый контекст ставим mysql:8 на ВМ
  terraform apply
  ```

  `main.tf` блок с контекстом докера

  ```text
  # Создаёт/обновляет docker-контекст на твоей станции после появления ВМ
  resource "null_resource" "docker_context" {
    # если IP изменится (ВМ пересоздали) — контекст пересоздастся
    triggers = {
      address = yandex_compute_instance.netology-terraform-star1.network_interface[0].nat_ip_address
    }
  
    provisioner "local-exec" {
      command = <<-EOT
        docker context inspect yc-vm >/dev/null 2>&1 && docker context rm -f yc-vm
        docker context create yc-vm --docker "host=ssh://ijin@${self.triggers.address}"
      EOT
    }
  
    depends_on = [yandex_compute_instance.netology-terraform-star1]
  }
  ```

  Написано что это должно сработать и это нормальная практика, но я так делать не буду, потому что это явно не мое творчество будет. Я создам просто второй шаг который с уже готовым контекстом отработает с докером - в этом варианте мне уже знаний должно хватить (по докеру + основная задача в этой домашке уже использовала докер).


4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```

Создал контекст с именем под `main.tf`
```bash
docker context create vm-star1 --docker 'host=ssh://ijin@46.243.210.210'
ijin@tatuin ~/Work/net-devops1/Terraform/01/star1
$ docker context ls
NAME        DESCRIPTION                               DOCKER ENDPOINT               ERROR
default *   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock   
vm-star1                                              ssh://ijin@46.243.210.210     
wm                                                    ssh://ijin82@wired-mind.ru  

# тут пришлось зайти вручную на хост чтобы выполнить что-то в контексте

ijin@tatuin ~/Work/net-devops1/Terraform/01/star1
$ docker --context=vm-star1 image ls 
IMAGE   ID             DISK USAGE   CONTENT SIZE   EXTRA
```

Ок, заработало. Файл:  
`Terraform/01/star1_step2/main.tf`  

Выполняем

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/star1_step2
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

# ...
# ...

docker_image.my1_mysql: Creating...
random_password.mysql_passwords["user"]: Creating...
random_password.mysql_passwords["root"]: Creating...
random_password.mysql_passwords["user"]: Creation complete after 0s [id=none]
random_password.mysql_passwords["root"]: Creation complete after 0s [id=none]
docker_image.my1_mysql: Still creating... [00m10s elapsed]
docker_image.my1_mysql: Still creating... [00m20s elapsed]
docker_image.my1_mysql: Creation complete after 23s [id=sha256:6ea90827b1100f8f2ae306a539f86d2c264a26ed435a2a9f75551dd5c3aeb242mysql:8]
docker_container.my1_mysql: Creating...
docker_container.my1_mysql: Creation complete after 3s [id=f2851921ff28e025433d3cb89d6c5edcfef3033d6811300d36c568f45427a0df]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

6. Зайдите на вашу ВМ , подключитесь к контейнеру и проверьте наличие секретных env-переменных с помощью команды ```env```. Запишите ваш финальный код в репозиторий.  

Заходим, проверяем
```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/star1_step2
$ docker --context=vm-star1 container ls
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                               NAMES
f2851921ff28   6ea90827b110   "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

ijin@tatuin ~/Work/net-devops1/Terraform/01/star1_step2
$ docker --context=vm-star1 exec -it mysql env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=f2851921ff28
TERM=xterm
MYSQL_ROOT_HOST=%
MYSQL_DATABASE=wordpress
MYSQL_ROOT_PASSWORD=GnJ7rQwxdst6FJ4k
MYSQL_USER=wordpress
MYSQL_PASSWORD=OYfUjP49EDfwU2Rr
GOSU_VERSION=1.19
MYSQL_MAJOR=8.4
MYSQL_VERSION=8.4.11-1.el9
MYSQL_SHELL_VERSION=8.4.10-1.el9
HOME=/root
```

Скриншоты:  
`Terraform/01/Screenshots/ENV Check 1 2026-10-06 18-25-16.png`  
`Terraform/01/Screenshots/ENV Check 2 2026-10-06 18-25-54.png`  

### Задание 3*
1. Установите [opentofu](https://opentofu.org/)(fork terraform с лицензией Mozilla Public License, version 2.0) любой версии
2. Попробуйте выполнить тот же код с помощью ```tofu apply```, а не terraform apply.  

  Установил
```bash
ijin@tatuin 🛠️  git:master ~/Work/net-devops1
$ tofu --version
OpenTofu v1.13.1
on linux_amd64
```

  Инициализация
```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/star2_tofu
$ tofu init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of kreuzwerker/docker...
- Finding latest version of hashicorp/random...
╷
│ Error: Failed to resolve provider packages
│ 
│ Could not resolve provider hashicorp/random: could not connect to registry.opentofu.org: failed to request discovery document: 403
│ Forbidden
╵

╷
│ Error: Failed to resolve provider packages
│ 
│ Could not resolve provider kreuzwerker/docker: could not connect to registry.opentofu.org: failed to request discovery document: 403
│ Forbidden
╵

## Исправлено натрибуквы

ijin@tatuin ~/Work/net-devops1/Terraform/01/star2_tofu
$ tofu init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of kreuzwerker/docker...
- Finding latest version of hashicorp/random...
- Installing hashicorp/random v3.9.1...
- Installing kreuzwerker/docker v4.6.0...
- Installed hashicorp/random v3.9.1 (signed, key ID 0C0AF313E5FD9F80)
- Installed kreuzwerker/docker v4.6.0 (signed, key ID 0DCE698927DAF8EC)

Providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://opentofu.org/docs/cli/plugins/signing/

OpenTofu has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that OpenTofu can guarantee to make the same selections by default when
you run "tofu init" in the future.

OpenTofu has been successfully initialized!

You may now begin working with OpenTofu. Try running "tofu plan" to see
any changes that are required for your infrastructure. All OpenTofu commands
should now work.

If you ever set or change modules or backend configuration for OpenTofu,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

План говорит что все совместимо!!

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/star2_tofu
$ tofu plan

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

OpenTofu will perform the following actions:

  # docker_container.my1_mysql will be created
  + resource "docker_container" "my1_mysql" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (sensitive value)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + memory_reservation                          = 0
      + must_run                                    = true
      + name                                        = "mysql"
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + platform                                    = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 3306
          + internal = 3306
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.my1_mysql will be created
  + resource "docker_image" "my1_mysql" {
      + id          = (known after apply)
      + image_id    = (known after apply)
      + name        = "mysql:8"
      + repo_digest = (known after apply)
    }

  # random_password.mysql_passwords["root"] will be created
  + resource "random_password" "mysql_passwords" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = false
      + upper       = true
    }

  # random_password.mysql_passwords["user"] will be created
  + resource "random_password" "mysql_passwords" {
      + bcrypt_hash = (sensitive value)
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 1
      + min_numeric = 1
      + min_special = 0
      + min_upper   = 1
      + number      = true
      + numeric     = true
      + result      = (sensitive value)
      + special     = false
      + upper       = true
    }

Plan: 4 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so OpenTofu can't guarantee to take exactly these actions if you run "tofu
apply" now.
```

Пересоздал контекст, прописал его в `Terraform/01/star2_tofu/main.tf:15`  

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01
$ docker context create vm-star2 --docker 'host=ssh://ijin@51.250.97.150'
vm-star2
Successfully created context "vm-star2"
ijin@tatuin ~/Work/net-devops1/Terraform/01
$ docker context ls
NAME        DESCRIPTION                               DOCKER ENDPOINT               ERROR
default *   Current DOCKER_HOST based configuration   unix:///var/run/docker.sock   
vm-star2                                              ssh://ijin@51.250.97.150      
wm                                                    ssh://ijin82@wired-mind.ru  
```

Тут пришлось вручную войти на ВМ чтобы добавился фингерпринт, потом ssh-add ключ

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/01/star2_tofu
$ ssh ijin@51.250.97.150
The authenticity of host '51.250.97.150 (51.250.97.150)' can't be established.
ED25519 key fingerprint is SHA256:hMqvzRYGQdLDK0JXOKDlJbEo/uEtUaQ1LlJ2YzG/6WY.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.97.150' (ED25519) to the list of known hosts.
ssh: ijin@51.250.97.150: Permission denied (publickey).
```

И все сработало как ожидалось! Видимо случай простой, оказалось совместимо.

```
ijin@tatuin ~/Work/net-devops1/Terraform/01/star2_tofu
$ tofu apply
random_password.mysql_passwords["root"]: Refreshing state... [id=none]
random_password.mysql_passwords["user"]: Refreshing state... [id=none]

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

OpenTofu will perform the following actions:

  # docker_container.my1_mysql will be created
  + resource "docker_container" "my1_mysql" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (sensitive value)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + memory_reservation                          = 0
      + must_run                                    = true
      + name                                        = "mysql"
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + platform                                    = (known after apply)
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels (known after apply)

      + ports {
          + external = 3306
          + internal = 3306
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.my1_mysql will be created
  + resource "docker_image" "my1_mysql" {
      + id          = (known after apply)
      + image_id    = (known after apply)
      + name        = "mysql:8"
      + repo_digest = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  OpenTofu will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_image.my1_mysql: Creating...
docker_image.my1_mysql: Still creating... [10s elapsed]
docker_image.my1_mysql: Still creating... [20s elapsed]
docker_image.my1_mysql: Creation complete after 24s [id=sha256:6ea90827b1100f8f2ae306a539f86d2c264a26ed435a2a9f75551dd5c3aeb242mysql:8]
docker_container.my1_mysql: Creating...
docker_container.my1_mysql: Creation complete after 5s [id=c682465f01ff3646d5c6b79b28854e59e0c5ccfd13b0d655e30468b93a95851b]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
ijin@tatuin ~/Work/net-devops1/Terraform/01/star2_tofu
$ docker --context=vm-star2 exec -it mysql env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=c682465f01ff
TERM=xterm
MYSQL_ROOT_HOST=%
MYSQL_PASSWORD=JVwqid21HanWK41s
MYSQL_DATABASE=wordpress
MYSQL_ROOT_PASSWORD=p1XncKCQeeEmDMf6
MYSQL_USER=wordpress
GOSU_VERSION=1.19
MYSQL_MAJOR=8.4
MYSQL_VERSION=8.4.11-1.el9
MYSQL_SHELL_VERSION=8.4.10-1.el9
HOME=/root
```

Скриншоты:
`Terraform/01/Screenshots/Tofu check 1 2026-10-07 20-31-14.png`  
`Terraform/01/Screenshots/Tofu check 2 2026-10-07 20-31-40.png`  
`Terraform/01/Screenshots/Tofu check 3 2026-10-07 20-32-25.png`  

------

### Правила приёма работы

Домашняя работа оформляется в отдельном GitHub-репозитории в файле README.md.   
Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 

