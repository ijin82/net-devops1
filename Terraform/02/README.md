# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).

### Задание 0 + решение

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). 
Этот функционал понадобится к следующей лекции.  

**Готово**  

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
------

### Задание 1 + решение
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.
Убедитесь что ваша версия **Terraform** ~>1.12.0

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.

**Скриншоты:**  
  Terraform/02/Screenshots/Service account 2026-10-22 11-55-10.png  
  Terraform/02/Screenshots/Key File 2026-10-22 12-00-01.png  

5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.

**Вижу ошибки:**  
```bash
ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ terraform init
Initializing the backend...

╷
│ Error: Unsupported Terraform Core version
│ 
│   on providers.tf line 7, in terraform:
│    7:   required_version = "~>1.12.0"
│ 
│ This configuration does not support Terraform version 1.16.5. To proceed, either choose another supported Terraform version or update
│ this version constraint. Version constraints are normally set for good reason, so updating the constraint may lead to other errors or
│ unexpected behavior.
╵

ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ terraform version
Terraform v1.16.5
on linux_amd64
```

Исправил версию terraform `Terraform/02/src/providers.tf:7`  
на `required_version = "~>1.16.0"`  

Теперь `terraform init` успешно выполниля. Валидирую.

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ terraform validate
╷
│ Error: Invalid function argument
│ 
│   on providers.tf line 15, in provider "yandex":
│   15:   service_account_key_file = file("~/.authorized_key.json")
│     ├────────────────
│     │ while calling file(path)
│ 
│ Invalid value for "path" parameter: no file exists at "~/.authorized_key.json"; this function works only with files that are
│ distributed as part of the configuration source code, so if this file will be created by a resource in this configuration you must
│ instead obtain this result from an attribute of that resource.
╵
```

Перенршу ключ как задумано `Terraform/02/src/providers.tf:15` в строке `service_account_key_file = file("~/.authorized_key.json")`  

Сам перенос (у меня в папке `Terraform/02/src` сейчас ключ): `mv key.json ~/.authorized_key.json`  

Сделующая итерация:  

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ terraform validate
Success! The configuration is valid.
```

Хм. Кажется ошибки кончились?  

Переделал ключ, мой просрочился  
```bash
ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ yc iam service-account list

You are going to be authenticated via subject-id 'aje7rh6gorf7bijgvm4h'.
Authentication web site will be opened.
After your successful authentication, you will be redirected to cloud console.

Press 'enter' to continue...
+----------------------+----------------+-------------+---------------------+-----------------------+
|          ID          |      NAME      |   LABELS    |     CREATED AT      | LAST AUTHENTICATED AT |
+----------------------+----------------+-------------+---------------------+-----------------------+
| ajekqd5108l5p2rv5lt2 | terraform-ijin | netology=my | 2026-10-06 10:08:29 | 2026-10-07 18:40:00   |
+----------------------+----------------+-------------+---------------------+-----------------------+

There is a new yc version '1.41.0' available. Current version: '1.38.0'.
But yc seems to be installed as a standalone binary, thus self-update is not available.
Please reinstall yc following the instructions on the page https://yandex.cloud/ru/docs/cli/quickstart#install
See release notes at https://yandex.cloud/ru/docs/cli/release-notes

ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ yc iam key create --service-account-id ajekqd5108l5p2rv5lt2 --output ~/.authorized_key.json 
id: aje5g0ulpgqvbhk1atuk
service_account_id: ajekqd5108l5p2rv5lt2
created_at: "2026-10-22T10:31:04.649378295Z"
key_algorithm: RSA_2048
```

Прогоняю план, вижу запрос идентификатора облака и фолдера, получаю идентификаторы и ввожу их  

```bash
ijin@tatuin ~/Downloads
$ yc resource-manager cloud list
+----------------------+------------------------------+----------------------+--------+
|          ID          |             NAME             |   ORGANIZATION ID    | LABELS |
+----------------------+------------------------------+----------------------+--------+
| b1gv6aetkp611h2im18u | src-user-cloud-captain-buran | bpf3b94j5t4qlhi8kl7k |        |
+----------------------+------------------------------+----------------------+--------+

ijin@tatuin ~/Downloads
$ yc resource-manager folder list
+----------------------+-----------+--------+--------+
|          ID          |   NAME    | LABELS | STATUS |
+----------------------+-----------+--------+--------+
| b1gl6j5lv636j3ekvebc | ijin-main |        | ACTIVE |
+----------------------+-----------+--------+--------+

ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ terraform plan
var.cloud_id
  https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id

  Enter a value: b1gv6aetkp611h2im18u

var.folder_id
  https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id

  Enter a value: b1gl6j5lv636j3ekvebc


  ## ...
  ## ...

  # yandex_vpc_subnet.develop will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "develop"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```

План сработал нормально, но переменные (id облака и каталога ) при повторном запуске спрашивает снова. Пока ничего не делаю с этим, потому что в задании не вижу что надо пока.

Обновил `yc` зачем-то yandex поменял путь, ок  
```bash
ijin@tatuin 🏠 ~
$ yc --version
Yandex Cloud CLI 1.41.0 linux/amd64
ijin@tatuin 🏠 ~
$ which yc
/home/ijin/yandex-cloud/bin/yc
```

При выполнении `terraform apply` вижу ошибку

```bash
Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 4s [id=enpcqh2qv9vldb480ss7]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_subnet.develop: Creation complete after 2s [id=e9bleuns2akhj4211h5d]
yandex_compute_instance.platform: Creating...
╷
│ Error: Error while requesting API to create instance: x-request-id = 7e8d9900-3049-4dc9-b481-c11fb09d098d x-server-trace-id = 299d17df6324d205:89021489a47c2d3a:1cc1bb41de02c3ab:1 x-client-trace-id = c8368e5a-c31c-46b9-88a1-d4b1791ade4e rpc error: code = FailedPrecondition desc = Platform "standart-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
╵
```

То есть платформы с таким `platform_id` нет, ищем документацию `https://yandex.cloud/ru/docs/compute/concepts/vm-platforms` в которой смотрим какие платформы есть. Такой платформы больше нет. Выбираем ту что подходит сейчас - `standard-v3` - Intel Ice Lake.  

Повторяю `terraform apply` вижу ошибку  

```bash
╷
│ Error: Error while requesting API to create instance: x-request-id = 2b926b4c-0da9-4785-960e-97a52e8da41e x-server-trace-id = 27c06a9ac9893efa:82c3fefdcb937704:226ec9bb6395b534:1 x-client-trace-id = 0da4d738-1a98-489a-92a7-cbc7d32f68aa rpc error: code = InvalidArgument desc = the specified core fraction is not available on platform "standard-v3"; allowed core fractions: 20, 50, 100
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
╵
```

Изменяю `core_fraction = 20` в файле `main.tf:21`.  
Получаю СНОВА ошибку  

```bash
╷│ Error: Error while requesting API to create instance: x-request-id = 4366b3c2-95b8-4579-b247-96895d194a1b x-server-trace-id = d45f1725e91665d5:281d0f2a87faa4b4:1aec894e8abd84cf:1 x-client-trace-id = 35d81646-e0ba-4f68-a06c-6f330eeb6d85 rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v3"; allowed core number: 2, 4
```

Меняю число ядер на 2 в том же файле. `cores = 2`

В этот момент устал вводить переменные и создал файл `Terraform/02/src/personal.auto.tfvars` с переменными (чтобы руками не вводить больше)

```text
cloud_id = "secret"
folder_id = "secret"
```

Запускаю `terraform apply` с 2-мя ядрами, вижу снова ошибку

```bash
yandex_compute_instance.platform: Creating...
╷
│ Error: Error while requesting API to create instance: x-request-id = 2a855f71-c199-46e2-9037-b1769397647f x-server-trace-id = cbb3f89cb252f1f4:76399f14b1915ef2:c381288dabf6710e:1 x-client-trace-id = 69ee4431-6a61-43be-ae1e-42d0b91f48c6 rpc error: code = ResourceExhausted desc = Resource allocation is restricted
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
╵
```

Добавляю переменную в `personal.auto.tfvars` и пробую другую зону

```text
cloud_id = "secret"
folder_id = "secret"

# помечена как новая зона в интерфейсе YC,
# я пробовал "a" и "b" - ошибки одинаковые, нельзя создать ресурс, 
# в "e" зоне все сработало
default_zone = "ru-central1-e" 


# добавил публичный ключ для установки внутрь VM
vms_ssh_root_key = "ssh-ed25519 secret ijin@tatuin"
```

6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.;  

Сделано:  
```bash
ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ ssh ubuntu@93.77.163.156
The authenticity of host '93.77.163.156 (93.77.163.156)' can't be established.
ED25519 key fingerprint is SHA256:49WLlHq4inq8TMCrzMt67I40zQAS7aGUMzfu5cXGMn0.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '93.77.163.156' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-216-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Oct 22 12:03:15 UTC 2026

  System load:  0.47              Processes:             111
  Usage of /:   38.3% of 4.20GB   Users logged in:       0
  Memory usage: 19%               IPv4 address for eth0: 10.0.1.29
  Swap usage:   0%

 * Ubuntu 20.04 LTS Focal Fossa has reached its end of standard support
   on 31 May 2025.

   For more details see:
   https://ubuntu.com/20-04

Expanded Security Maintenance for Infrastructure is not enabled.

0 updates can be applied immediately.

135 additional security updates can be applied with ESM Infra.
Learn more about enabling ESM Infra service for Ubuntu 20.04 at
https://ubuntu.com/20-04


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@bg01633ld67je9vtcqvc:~$ curl ifconfig.me
93.77.163.156
```

8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.

Ответ:  
 - `preemptible = true` - это актоматически останавливаемая виртуальная машина, которая будет автоматически остановлена в конце дня, для нас, учеников, это может пригодиться на случай забывчиваости. Когда забыли выключить или удалить виртуалку и чтобы сэкономить средства - это поможет, автоматически отключившись в конце дня.
 - `core_fraction=5` - у меня сейчас `core_fraction = 20` это процент физического ядра который приходится на одно виртуальное ядро. То есть гарантированная мощность физического ядра на одно виртуальное ядро. См. документацию [https://yandex.cloud/ru/docs/terraform/resources/compute_instance?ysclid=mvji43dcz232799830](https://yandex.cloud/ru/docs/terraform/resources/compute_instance?ysclid=mvji43dcz232799830) -- `core_fraction` (Number). If provided, specifies baseline performance for a core as a percent.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;  
**Скриншот:** `Terraform/02/Screenshots/VM Created From 2026-10-22 14-14-48.png`
- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;  
**Скриншот:** `Terraform/02/Screenshots/VM Created Console 2026-10-22 14-15-43.png`
- ответы на вопросы.  
**Выписал выше**


### Задание 2

1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf.
3. Проверьте terraform plan. Изменений быть не должно.

**Скриншот** файла с переменными `Terraform/02/Screenshots/auto tfvars 2026-10-22 14-54-38.png`  
План выполняется, всё в порядке.  

### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.  
> Такие именно??? Объявленные в variables.tf или из personal.auto.tfvars НЕ ПОНЯТНО  
>
> Перенес объявление переменных из `variables.tf`

2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с префиксом **vm_db_** в том же файле 
('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"  
Ок, для этого в `main.tf` создал подсеть в зоне d (b зона не доступна для создания ресурсов сегодня)

```text
resource "yandex_vpc_subnet" "develop_zone_d" {
  name           = var.vpc_name_zone_d
  zone           = var.yandex_compute_instance_zone.db
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_zone_d
}
```

и для `platform_db` исправил значения в секции

```text
  # нужно обязательно явно указать зону, потому что сначала будет взята зона из
  # provider "yandex" zone 
  # и потом уже будет попытка прицеить к ней подсеть, в этом случае зона ВМ и зона подсети
  # должны совпадать, то есть зона подсети, имеет приоритет ниже чем дефолтная зона провайдера
  zone        = var.yandex_compute_instance_zone.db

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_zone_d.id
    nat       = var.vm_web_yandex_compute_instance_nat
  }
```

3. Примените изменения.

**Скриншоты:**  
`Terraform/02/Screenshots/VM created 1 2026-10-22 17-21-52.png`  
`Terraform/02/Screenshots/VM Created 2 - zones 2026-10-22 17-22-23.png`  

### Задание 4

1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

Ответ + исправление для обеих вм:

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ terraform output
vm_result_db = {
  "external_ip" = "10.0.2.33"
  "fqdn" = "fv4kf6vnf8vjn2fpq260.auto.internal"
  "instance_name" = "netology-develop-platform-db"
}
vm_result_web = {
  "external_ip" = "10.0.1.20"
  "fqdn" = "bg0l08lkj9afqd0cdk5d.auto.internal"
  "instance_name" = "netology-develop-platform-web"
}
```

Добавил лист с перечислением виртуалок:

```text
locals {
  test_vms = [
    yandex_compute_instance.platform,
    yandex_compute_instance.platform_db
  ]
}
```

Единый output:  

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/02/src
$ terraform output 
vm_full_db = [
  {
    "external_ip" = "10.0.1.20"
    "fqdn" = "bg0l08lkj9afqd0cdk5d.auto.internal"
    "instance_name" = "netology-develop-platform-web"
  },
  {
    "external_ip" = "10.0.2.33"
    "fqdn" = "fv4kf6vnf8vjn2fpq260.auto.internal"
    "instance_name" = "netology-develop-platform-db"
  },
]
vm_result_db = {
  "external_ip" = "10.0.2.33"
  "fqdn" = "fv4kf6vnf8vjn2fpq260.auto.internal"
  "instance_name" = "netology-develop-platform-db"
}
vm_result_web = {
  "external_ip" = "10.0.1.20"
  "fqdn" = "bg0l08lkj9afqd0cdk5d.auto.internal"
  "instance_name" = "netology-develop-platform-web"
}
```

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

**Решение в файле.** Проверил, работает как задумано.

### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
   ```
   пример из terraform.tfvars:
   metadata = {
     serial-port-enable = 1
     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
   }
   ```  
  
5. Найдите и закоментируйте все, более не используемые переменные проекта.
6. Проверьте terraform plan. Изменений быть не должно.

------

## Дополнительное задание (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   
Они помогут глубже разобраться в материале. Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


------
### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list.
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание**: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"

В качестве решения предоставьте необходимые команды и их вывод.

------

### Задание 8*
1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.
------

------

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: ```sudo passwd ubuntu```

### Правила приёма работыДля подключения предварительно через ssh измените пароль пользователя: sudo passwd ubuntu
В качестве результата прикрепите ссылку на MD файл с описанием выполненой работы в вашем репозитории. Так же в репозитории должен присутсвовать ваш финальный код проекта.

**Важно. Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
