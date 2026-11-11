# Домашнее задание к занятию «Продвинутые методы работы с Terraform»

### Цели задания

1. Научиться использовать модули.
2. Отработать операции state.
3. Закрепить пройденный материал.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**04/src**](https://github.com/netology-code/ter-homeworks/tree/main/04/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.12.0
Пишем красивый код, хардкод значения не допустимы!
------

### Задание 1
  
1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания с помощью двух вызовов remote-модуля -> двух ВМ, относящихся к разным проектам(marketing и analytics) используйте labels для обозначения принадлежности.  В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://oneuptime.com/blog/post/2026-03-02-how-to-use-cloud-init-with-terraform-for-ubuntu-provisioning/view). Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.
3. Добавьте в файл cloud-init.yml установку nginx.
4. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```, скриншот консоли ВМ yandex cloud с их метками. Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.marketing_vm
------
В случае использования MacOS вы получите ошибку "Incompatible provider version" . В этом случае скачайте remote модуль локально и поправьте в нем версию template провайдера на более старую.
------

**Решение:**  
Скриншоты:  
`Terraform/04/Screenshots/Task1 - module.marketing 2026-11-10 19-35-53.png`  
`Terraform/04/Screenshots/Task1 - nginx installed 2026-11-10 19-32-49.png`  
`Terraform/04/Screenshots/Task1 - VMs created 2026-11-10 19-33-20.png`  

<details>
  <summary>Вывод консоли terraform</summary>

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ ssh-add ~/.ssh/vagrant
Identity added: /home/ijin/.ssh/vagrant (ijin@tatuin)
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ ssh ubuntu@84.201.159.93
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-216-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Tue Nov 10 17:31:31 UTC 2026

  System load:  1.58              Processes:             116
  Usage of /:   16.6% of 9.04GB   Users logged in:       0
  Memory usage: 28%               IPv4 address for eth0: 10.0.1.16
  Swap usage:   0%


Expanded Security Maintenance for Infrastructure is not enabled.

0 updates can be applied immediately.

171 additional security updates can be applied with ESM Infra.
Learn more about enabling ESM Infra service for Ubuntu 20.04 at
https://ubuntu.com/20-04

New release '22.04.5 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Tue Nov 10 17:32:08 2026 from 188.128.41.89
ubuntu@analytics-slot-0:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
ubuntu@analytics-slot-0:~$ logout
Connection to 84.201.159.93 closed.
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform console
> module.marketing
{
  "all" = [
    {
      "allow_recreate" = tobool(null)
      "allow_stopping_for_update" = true
      "boot_disk" = tolist([
        {
          "auto_delete" = true
          "device_name" = "fhmj8079jdlma4aprsf9"
          "disk_id" = "fhmj8079jdlma4aprsf9"
          "initialize_params" = tolist([
            {
              "block_size" = 4096
              "description" = ""
              "image_id" = "fd84np9sg3hrgaoisfnj"
              "kms_key_id" = ""
              "name" = ""
              "size" = 10
              "snapshot_id" = ""
              "type" = "network-hdd"
            },
          ])
          "mode" = "READ_WRITE"
        },
      ])
      "created_at" = "2026-11-10T17:30:04Z"
      "description" = "TODO: description; {{terraform yyy managed}}"
      "filesystem" = toset([])
      "folder_id" = "b1gl6j5lv636j3ekvebc"
      "fqdn" = "marketing-slot-0.ru-central1.internal"
      "gpu_cluster_id" = ""
      "hardware_generation" = tolist([
        {
          "generation2_features" = tolist([])
          "legacy_features" = tolist([
            {
              "pci_topology" = "PCI_TOPOLOGY_V2"
            },
          ])
        },
      ])
      "hostname" = "marketing-slot-0"
      "id" = "fhmai482ppbgq6n83ds6"
      "labels" = tomap({
        "owner" = "i.ivanov"
        "project" = "accounting"
      })
      "local_disk" = tolist([])
      "maintenance_grace_period" = ""
      "maintenance_policy" = tostring(null)
      "metadata" = tomap({
        "serial-port-enable" = "1"
        "user-data" = <<-EOT
        #cloud-config
        users:
          - name: ubuntu
            groups: sudo
            shell: /bin/bash
            sudo: ["ALL=(ALL) NOPASSWD:ALL"]
            ssh_authorized_keys:
              - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin
        package_update: true
        package_upgrade: false
        packages:
          - vim
          - nginx
          - mc
          - curl
          - wget
        EOT
      })
      "metadata_options" = tolist([
        {
          "aws_v1_http_endpoint" = 1
          "aws_v1_http_token" = 2
          "aws_v2_http_endpoint" = 1
          "aws_v2_http_token" = 1
          "gce_http_endpoint" = 1
          "gce_http_token" = 1
        },
      ])
      "name" = "marketing-slot-0"
      "network_acceleration_type" = "standard"
      "network_interface" = tolist([
        {
          "dns_record" = tolist([])
          "index" = 0
          "ip_address" = "10.0.1.8"
          "ipv4" = true
          "ipv6" = false
          "ipv6_address" = ""
          "ipv6_dns_record" = tolist([])
          "mac_address" = "d0:0d:a9:11:02:ce"
          "nat" = true
          "nat_dns_record" = tolist([])
          "nat_ip_address" = "51.250.73.137"
          "nat_ip_version" = "IPV4"
          "security_group_ids" = toset(null) /* of string */
          "subnet_id" = "e9b8rjk6lpa69vsao0ht"
        },
      ])
      "placement_policy" = tolist([
        {
          "host_affinity_rules" = tolist([])
          "placement_group_id" = ""
          "placement_group_partition" = 0
        },
      ])
      "platform_id" = "standard-v1"
      "reserved_instance_pool_id" = ""
      "resources" = tolist([
        {
          "core_fraction" = 5
          "cores" = 2
          "gpus" = 0
          "memory" = 1
        },
      ])
      "scheduling_policy" = tolist([
        {
          "preemptible" = true
        },
      ])
      "secondary_disk" = toset([])
      "service_account_id" = ""
      "status" = "running"
      "timeouts" = null /* object */
      "zone" = "ru-central1-a"
    },
  ]
  "external_ip_address" = [
    "51.250.73.137",
  ]
  "fqdn" = [
    "marketing-slot-0.ru-central1.internal",
  ]
  "internal_ip_address" = [
    "10.0.1.8",
  ]
  "labels" = [
    tomap({
      "owner" = "i.ivanov"
      "project" = "accounting"
    }),
  ]
  "network_interface" = [
    tolist([
      {
        "dns_record" = tolist([])
        "index" = 0
        "ip_address" = "10.0.1.8"
        "ipv4" = true
        "ipv6" = false
        "ipv6_address" = ""
        "ipv6_dns_record" = tolist([])
        "mac_address" = "d0:0d:a9:11:02:ce"
        "nat" = true
        "nat_dns_record" = tolist([])
        "nat_ip_address" = "51.250.73.137"
        "nat_ip_version" = "IPV4"
        "security_group_ids" = toset(null) /* of string */
        "subnet_id" = "e9b8rjk6lpa69vsao0ht"
      },
    ]),
  ]
}
> module.analytics
{
  "all" = [
    {
      "allow_recreate" = tobool(null)
      "allow_stopping_for_update" = true
      "boot_disk" = tolist([
        {
          "auto_delete" = true
          "device_name" = "fhmerhjgtdu6jsg6a7sp"
          "disk_id" = "fhmerhjgtdu6jsg6a7sp"
          "initialize_params" = tolist([
            {
              "block_size" = 4096
              "description" = ""
              "image_id" = "fd84np9sg3hrgaoisfnj"
              "kms_key_id" = ""
              "name" = ""
              "size" = 10
              "snapshot_id" = ""
              "type" = "network-hdd"
            },
          ])
          "mode" = "READ_WRITE"
        },
      ])
      "created_at" = "2026-11-10T17:30:04Z"
      "description" = "TODO: description; {{terraform yyy managed}}"
      "filesystem" = toset([])
      "folder_id" = "b1gl6j5lv636j3ekvebc"
      "fqdn" = "analytics-slot-0.ru-central1.internal"
      "gpu_cluster_id" = ""
      "hardware_generation" = tolist([
        {
          "generation2_features" = tolist([])
          "legacy_features" = tolist([
            {
              "pci_topology" = "PCI_TOPOLOGY_V2"
            },
          ])
        },
      ])
      "hostname" = "analytics-slot-0"
      "id" = "fhmomsogr584o97684ro"
      "labels" = tomap({
        "a" = "b"
        "c" = "d"
        "e" = "f"
        "env" = "analytics"
        "g" = "h"
        "project" = "undefined"
        "q" = "w"
      })
      "local_disk" = tolist([])
      "maintenance_grace_period" = ""
      "maintenance_policy" = tostring(null)
      "metadata" = tomap({
        "serial-port-enable" = "1"
        "user-data" = <<-EOT
        #cloud-config
        users:
          - name: ubuntu
            groups: sudo
            shell: /bin/bash
            sudo: ["ALL=(ALL) NOPASSWD:ALL"]
            ssh_authorized_keys:
              - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin
        package_update: true
        package_upgrade: false
        packages:
          - vim
          - nginx
          - mc
          - curl
          - wget
        EOT
      })
      "metadata_options" = tolist([
        {
          "aws_v1_http_endpoint" = 1
          "aws_v1_http_token" = 2
          "aws_v2_http_endpoint" = 1
          "aws_v2_http_token" = 1
          "gce_http_endpoint" = 1
          "gce_http_token" = 1
        },
      ])
      "name" = "analytics-slot-0"
      "network_acceleration_type" = "standard"
      "network_interface" = tolist([
        {
          "dns_record" = tolist([])
          "index" = 0
          "ip_address" = "10.0.1.16"
          "ipv4" = true
          "ipv6" = false
          "ipv6_address" = ""
          "ipv6_dns_record" = tolist([])
          "mac_address" = "d0:0d:18:b7:31:0d"
          "nat" = true
          "nat_dns_record" = tolist([])
          "nat_ip_address" = "84.201.159.93"
          "nat_ip_version" = "IPV4"
          "security_group_ids" = toset(null) /* of string */
          "subnet_id" = "e9b8rjk6lpa69vsao0ht"
        },
      ])
      "placement_policy" = tolist([
        {
          "host_affinity_rules" = tolist([])
          "placement_group_id" = ""
          "placement_group_partition" = 0
        },
      ])
      "platform_id" = "standard-v1"
      "reserved_instance_pool_id" = ""
      "resources" = tolist([
        {
          "core_fraction" = 5
          "cores" = 2
          "gpus" = 0
          "memory" = 1
        },
      ])
      "scheduling_policy" = tolist([
        {
          "preemptible" = true
        },
      ])
      "secondary_disk" = toset([])
      "service_account_id" = ""
      "status" = "running"
      "timeouts" = null /* object */
      "zone" = "ru-central1-a"
    },
  ]
  "external_ip_address" = [
    "84.201.159.93",
  ]
  "fqdn" = [
    "analytics-slot-0.ru-central1.internal",
  ]
  "internal_ip_address" = [
    "10.0.1.16",
  ]
  "labels" = [
    tomap({
      "a" = "b"
      "c" = "d"
      "e" = "f"
      "env" = "analytics"
      "g" = "h"
      "project" = "undefined"
      "q" = "w"
    }),
  ]
  "network_interface" = [
    tolist([
      {
        "dns_record" = tolist([])
        "index" = 0
        "ip_address" = "10.0.1.16"
        "ipv4" = true
        "ipv6" = false
        "ipv6_address" = ""
        "ipv6_dns_record" = tolist([])
        "mac_address" = "d0:0d:18:b7:31:0d"
        "nat" = true
        "nat_dns_record" = tolist([])
        "nat_ip_address" = "84.201.159.93"
        "nat_ip_version" = "IPV4"
        "security_group_ids" = toset(null) /* of string */
        "subnet_id" = "e9b8rjk6lpa69vsao0ht"
      },
    ]),
  ]
}
> ^C
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
```

</details>

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля, например: ```ru-central1-a```.  
2. Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.
3. Модуль должен возвращать в root module с помощью output информацию о yandex_vpc_subnet. Пришлите скриншот информации из terraform console о своем модуле. Пример: > module.vpc_dev  
4. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.
5. Сгенерируйте документацию к модулю с помощью terraform-docs.
 
Пример вызова

```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```

**Решение:**  
Код: `./module_one`  
Скриншоты:  
`Terraform/04/Screenshots/Task2 - module output 2026-11-11 12-49-25.png`  
`Terraform/04/Screenshots/Task2 - network ID YC 2026-11-11 12-50-45.png`  
`Terraform/04/Screenshots/Task2 - subnet ID YC 2026-11-11 12-51-15.png`  
`Terraform/04/Screenshots/Task2 - VM1 subnet 2026-11-11 12-51-59.png`  
`Terraform/04/Screenshots/Task2 - VM2 subnet  2026-11-11 12-52-25.png`  
Документация:  
Поставил terraform-docs: `go install github.com/terraform-docs/terraform-docs@latest`

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform-docs --version
terraform-docs version v0.24.0 linux/amd64
```

Сгенерировал документацию:  

```bash
terraform-docs markdown --output-file README.md --output-mode inject .
```

Сгенерированная документация тут: `Terraform/04/src/module_one/README.md`

### Задание 3
1. Выведите список ресурсов в стейте.

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state list
data.template_file.cloudinit
module.analytics.data.yandex_compute_image.my_image
module.analytics.yandex_compute_instance.vm[0]
module.marketing.data.yandex_compute_image.my_image
module.marketing.yandex_compute_instance.vm[0]
module.module_one.yandex_vpc_network.network_one
module.module_one.yandex_vpc_subnet.subnetwork_one
```

2. Полностью удалите из стейта модуль vpc.

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state rm module.module_one.yandex_vpc_network.network_one
Removed module.module_one.yandex_vpc_network.network_one
Successfully removed 1 resource instance(s).

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state rm module.module_one.yandex_vpc_subnet.subnetwork_one
Removed module.module_one.yandex_vpc_subnet.subnetwork_one
Successfully removed 1 resource instance(s).

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state list
data.template_file.cloudinit
module.analytics.data.yandex_compute_image.my_image
module.analytics.yandex_compute_instance.vm[0]
module.marketing.data.yandex_compute_image.my_image
module.marketing.yandex_compute_instance.vm[0]
```

3. Полностью удалите из стейта модуль vm.

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state rm module.analytics.data.yandex_compute_image.my_image module.analytics.yandex_compute_instance.vm[0] module.marketing.data.yandex_compute_image.my_image module.marketing.yandex_compute_instance.vm[0]
Removed module.analytics.data.yandex_compute_image.my_image
Removed module.analytics.yandex_compute_instance.vm[0]
Removed module.marketing.data.yandex_compute_image.my_image
Removed module.marketing.yandex_compute_instance.vm[0]
Successfully removed 4 resource instance(s).

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state list
data.template_file.cloudinit
```

4. Импортируйте всё обратно. Проверьте terraform plan. Значимых(!!) изменений быть не должно.
Приложите список выполненных команд и скриншоты процессы.  

Получаем идентификаторы:  

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ yc vpc network list
+----------------------+------------------+
|          ID          |       NAME       |
+----------------------+------------------+
| enp40k72n4s51vosvblq | prod-one-network |
| enpo3crs5rplj6revi7l | default          |
+----------------------+------------------+

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ yc vpc subnet list
+----------------------+-----------------------+----------------------+----------------+---------------+-----------------+
|          ID          |         NAME          |      NETWORK ID      | ROUTE TABLE ID |     ZONE      |      RANGE      |
+----------------------+-----------------------+----------------------+----------------+---------------+-----------------+
| ajccgh13ogjch23uhsiq | default-ru-central1-e | enpo3crs5rplj6revi7l |                | ru-central1-e | [10.131.0.0/24] |
| e2l6ctki7qeev90ustih | default-ru-central1-b | enpo3crs5rplj6revi7l |                | ru-central1-b | [10.129.0.0/24] |
| e9bhctbm0ll6u0e5356a | prod-one-subnetwork   | enp40k72n4s51vosvblq |                | ru-central1-a | [10.0.1.0/24]   |
| e9bucnd2o6qtgltlsjhv | default-ru-central1-a | enpo3crs5rplj6revi7l |                | ru-central1-a | [10.128.0.0/24] |
| fl8vc7230aibhuvqincn | default-ru-central1-d | enpo3crs5rplj6revi7l |                | ru-central1-d | [10.130.0.0/24] |
+----------------------+-----------------------+----------------------+----------------+---------------+-----------------+

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ yc vpc compute instance list
ERROR: execute command: Unknown command 'compute instance list'
See 'yc vpc -h' for help and examples.
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ yc compute instance list
+----------------------+------------------+---------------+---------+----------------+-------------+
|          ID          |       NAME       |    ZONE ID    | STATUS  |  EXTERNAL IP   | INTERNAL IP |
+----------------------+------------------+---------------+---------+----------------+-------------+
| fhmdrcgfgnvq99i34ufv | analytics-slot-0 | ru-central1-a | RUNNING | 84.201.172.117 | 10.0.1.34   |
| fhmlogp84o5gupm3t03t | marketing-slot-0 | ru-central1-a | RUNNING | 51.250.75.156  | 10.0.1.33   |
+----------------------+------------------+---------------+---------+----------------+-------------+

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ yc compute image list
+----+------+--------+-------------+--------+
| ID | NAME | FAMILY | PRODUCT IDS | STATUS |
+----+------+--------+-------------+--------+
+----+------+--------+-------------+--------+
```

Имиджей нет почему-то..  
Импорт ресурсов с идентификаторами:  

```bash

# Удалял в 1 итерации:
# Removed module.module_one.yandex_vpc_network.network_one
# Removed module.module_one.yandex_vpc_subnet.subnetwork_one

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform import module.module_one.yandex_vpc_network.network_one enp40k72n4s51vosvblq
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=561ec0ca826db627107409222f0cafa0e1ab04b9a6ec63debe36524c27813752]
module.module_one.yandex_vpc_network.network_one: Importing from ID "enp40k72n4s51vosvblq"...
module.analytics.data.yandex_compute_image.my_image: Reading...
module.marketing.data.yandex_compute_image.my_image: Reading...
module.module_one.yandex_vpc_network.network_one: Import prepared!
  Prepared yandex_vpc_network for import
module.module_one.yandex_vpc_network.network_one: Refreshing state... [id=enp40k72n4s51vosvblq]
module.marketing.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.analytics.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform import module.module_one.yandex_vpc_subnet.subnetwork_one e9bhctbm0ll6u0e5356a
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=561ec0ca826db627107409222f0cafa0e1ab04b9a6ec63debe36524c27813752]
module.marketing.data.yandex_compute_image.my_image: Reading...
module.analytics.data.yandex_compute_image.my_image: Reading...
module.module_one.yandex_vpc_subnet.subnetwork_one: Importing from ID "e9bhctbm0ll6u0e5356a"...
module.module_one.yandex_vpc_subnet.subnetwork_one: Import prepared!
  Prepared yandex_vpc_subnet for import
module.module_one.yandex_vpc_subnet.subnetwork_one: Refreshing state... [id=e9bhctbm0ll6u0e5356a]
module.analytics.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.marketing.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.


# Удалял во 2й итерации
# Removed module.analytics.data.yandex_compute_image.my_image
# Removed module.analytics.yandex_compute_instance.vm[0]
# Removed module.marketing.data.yandex_compute_image.my_image
# Removed module.marketing.yandex_compute_instance.vm[0]

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform import module.analytics.yandex_compute_instance.vm[0] fhmdrcgfgnvq99i34ufv
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=561ec0ca826db627107409222f0cafa0e1ab04b9a6ec63debe36524c27813752]
module.marketing.data.yandex_compute_image.my_image: Reading...
module.analytics.data.yandex_compute_image.my_image: Reading...
module.marketing.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.analytics.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.analytics.yandex_compute_instance.vm[0]: Importing from ID "fhmdrcgfgnvq99i34ufv"...
module.analytics.yandex_compute_instance.vm[0]: Import prepared!
  Prepared yandex_compute_instance for import
module.analytics.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmdrcgfgnvq99i34ufv]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform import module.marketing.yandex_compute_instance.vm[0] fhmlogp84o5gupm3t03t
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=561ec0ca826db627107409222f0cafa0e1ab04b9a6ec63debe36524c27813752]
module.analytics.data.yandex_compute_image.my_image: Reading...
module.marketing.data.yandex_compute_image.my_image: Reading...
module.analytics.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.marketing.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.marketing.yandex_compute_instance.vm[0]: Importing from ID "fhmlogp84o5gupm3t03t"...
module.marketing.yandex_compute_instance.vm[0]: Import prepared!
  Prepared yandex_compute_instance for import
module.marketing.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmlogp84o5gupm3t03t]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

# А вот если бы у меня небыло списка удаленных ресурсов как бы я вычислял чего 
# мне не хватает и кто есть кто в куче ресурсов на площадке???? 
# То есть я бы смотрел в код и (если бы были) переменные с которыми он был выполнен
# то мог бы вычислить каких ресурсов не хватает
# Ответ: смотреть terraform plan на предмет ресурсов которые система будет пытаться создать.

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state list
data.template_file.cloudinit
module.analytics.data.yandex_compute_image.my_image
module.analytics.yandex_compute_instance.vm[0]
module.marketing.data.yandex_compute_image.my_image
module.marketing.yandex_compute_instance.vm[0]
module.module_one.yandex_vpc_network.network_one
module.module_one.yandex_vpc_subnet.subnetwork_one

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform plan
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=561ec0ca826db627107409222f0cafa0e1ab04b9a6ec63debe36524c27813752]
module.marketing.data.yandex_compute_image.my_image: Reading...
module.analytics.data.yandex_compute_image.my_image: Reading...
module.module_one.yandex_vpc_network.network_one: Refreshing state... [id=enp40k72n4s51vosvblq]
module.analytics.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.marketing.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.module_one.yandex_vpc_subnet.subnetwork_one: Refreshing state... [id=e9bhctbm0ll6u0e5356a]
module.marketing.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmlogp84o5gupm3t03t]
module.analytics.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmdrcgfgnvq99i34ufv]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.analytics.yandex_compute_instance.vm[0] will be updated in-place
  ~ resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
        id                        = "fhmdrcgfgnvq99i34ufv"
        name                      = "analytics-slot-0"
        # (16 unchanged attributes hidden)

        # (6 unchanged blocks hidden)
    }

  # module.marketing.yandex_compute_instance.vm[0] will be updated in-place
  ~ resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
        id                        = "fhmlogp84o5gupm3t03t"
        name                      = "marketing-slot-0"
        # (16 unchanged attributes hidden)

        # (6 unchanged blocks hidden)
    }

Plan: 0 to add, 2 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform
apply" now.
```

Скриншоты:  
`Terraform/04/Screenshots/Task3 - IDs1 2026-11-11 13-43-41.png`  
`Terraform/04/Screenshots/Task3 - IDs2 2026-11-11 13-43-51.png`  
`Terraform/04/Screenshots/Task3 - import 2026-11-11 13-52-43.png`  

## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


### Задание 4*

1. Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
  
Пример вызова
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```

Предоставьте код, план выполнения, результат из консоли YC.

**Решение:**  
Код: `Terraform/04/src/main.tf:91`
Модуль: `Terraform/04/src/module_two/main.tf`

<details>
  <summary>Вывод terraform plan</summary>

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform plan
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=561ec0ca826db627107409222f0cafa0e1ab04b9a6ec63debe36524c27813752]
module.marketing.data.yandex_compute_image.my_image: Reading...
module.analytics.data.yandex_compute_image.my_image: Reading...
module.analytics.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]
module.marketing.data.yandex_compute_image.my_image: Read complete after 2s [id=fd84np9sg3hrgaoisfnj]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # module.analytics.yandex_compute_instance.vm[0] will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "TODO: description; {{terraform yyy managed}}"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "analytics-slot-0"
      + id                        = (known after apply)
      + labels                    = {
          + "a"       = "b"
          + "c"       = "d"
          + "e"       = "f"
          + "env"     = "analytics"
          + "g"       = "h"
          + "project" = "undefined"
          + "q"       = "w"
        }
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "user-data"          = <<-EOT
                #cloud-config
                users:
                  - name: ubuntu
                    groups: sudo
                    shell: /bin/bash
                    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
                    ssh_authorized_keys:
                      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin
                package_update: true
                package_upgrade: false
                packages:
                  - vim
                  - nginx
                  - mc
                  - curl
                  - wget
            EOT
        }
      + name                      = "analytics-slot-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + reserved_instance_pool_id = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd84np9sg3hrgaoisfnj"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index          = (known after apply)
          + ip_address     = (known after apply)
          + ipv4           = true
          + ipv6           = (known after apply)
          + ipv6_address   = (known after apply)
          + mac_address    = (known after apply)
          + nat            = true
          + nat_ip_address = (known after apply)
          + nat_ip_version = (known after apply)
          + subnet_id      = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # module.marketing.yandex_compute_instance.vm[0] will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "TODO: description; {{terraform yyy managed}}"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hardware_generation       = (known after apply)
      + hostname                  = "marketing-slot-0"
      + id                        = (known after apply)
      + labels                    = {
          + "owner"   = "i.ivanov"
          + "project" = "accounting"
        }
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "user-data"          = <<-EOT
                #cloud-config
                users:
                  - name: ubuntu
                    groups: sudo
                    shell: /bin/bash
                    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
                    ssh_authorized_keys:
                      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin
                package_update: true
                package_upgrade: false
                packages:
                  - vim
                  - nginx
                  - mc
                  - curl
                  - wget
            EOT
        }
      + name                      = "marketing-slot-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + reserved_instance_pool_id = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd84np9sg3hrgaoisfnj"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options (known after apply)

      + network_interface {
          + index          = (known after apply)
          + ip_address     = (known after apply)
          + ipv4           = true
          + ipv6           = (known after apply)
          + ipv6_address   = (known after apply)
          + mac_address    = (known after apply)
          + nat            = true
          + nat_ip_address = (known after apply)
          + nat_ip_version = (known after apply)
          + subnet_id      = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # module.module_one.yandex_vpc_network.network_one will be created
  + resource "yandex_vpc_network" "network_one" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "prod-one-network"
      + subnet_ids                = (known after apply)
    }

  # module.module_one.yandex_vpc_subnet.subnetwork_one will be created
  + resource "yandex_vpc_subnet" "subnetwork_one" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "prod-one-subnetwork"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc_dev.yandex_vpc_network.network_one will be created
  + resource "yandex_vpc_network" "network_one" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "develop-two-network"
      + subnet_ids                = (known after apply)
    }

  # module.vpc_dev.yandex_vpc_subnet.subnetwork_one["ru-central1-a"] will be created
  + resource "yandex_vpc_subnet" "subnetwork_one" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "develop-ru-central1-a-two-subnetwork"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc_prod.yandex_vpc_network.network_one will be created
  + resource "yandex_vpc_network" "network_one" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "production-two-network"
      + subnet_ids                = (known after apply)
    }

  # module.vpc_prod.yandex_vpc_subnet.subnetwork_one["ru-central1-a"] will be created
  + resource "yandex_vpc_subnet" "subnetwork_one" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "production-ru-central1-a-two-subnetwork"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc_prod.yandex_vpc_subnet.subnetwork_one["ru-central1-d"] will be created
  + resource "yandex_vpc_subnet" "subnetwork_one" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "production-ru-central1-d-two-subnetwork"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }

Plan: 9 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform
apply" now.
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ 
```

</details>

Скриншоты:  
`Terraform/04/Screenshots/Task4 - networks 2026-11-11 17-18-35.png`  
`Terraform/04/Screenshots/Task4 - subnetworks 2026-11-11 17-19-00.png`  

### Задание 5*

1. Напишите модуль для создания кластера managed БД Mysql в Yandex Cloud с одним или несколькими(2 по умолчанию) хостами в зависимости от переменной HA=true или HA=false. Используйте ресурс yandex_mdb_mysql_cluster: передайте имя кластера и id сети.
2. Напишите модуль для создания базы данных и пользователя в уже существующем кластере managed БД Mysql. Используйте ресурсы yandex_mdb_mysql_database и yandex_mdb_mysql_user: передайте имя базы данных, имя пользователя и id кластера при вызове модуля.
3. Используя оба модуля, создайте кластер example из одного хоста, а затем добавьте в него БД test и пользователя app. Затем измените переменную и превратите сингл хост в кластер из 2-х серверов.
4. Предоставьте план выполнения и по возможности результат. Сразу же удаляйте созданные ресурсы, так как кластер может стоить очень дорого. Используйте минимальную конфигурацию.

### Задание 6*
1. Используя готовый yandex cloud terraform module и пример его вызова(examples/simple-bucket): https://github.com/terraform-yc-modules/terraform-yc-s3 .
Создайте и не удаляйте для себя s3 бакет размером 1 ГБ(это бесплатно), он пригодится вам в ДЗ к 5 лекции.

**Решение:**  
Код: `Terraform/04/src/main.tf:109`

```bash
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ yc iam access-key create --service-account-name terraform-ijin
access_key:
  id: secret
  service_account_id: secret
  created_at: "2026-11-11T15:56:57.363149299Z"
  key_id: secret
secret: secret

export AWS_ACCESS_KEY_ID="secret"
export AWS_SECRET_ACCESS_KEY="secret"

terraform apply

# ...
# ... 

module.marketing.yandex_compute_instance.vm[0]: Still creating... [00m40s elapsed]
module.marketing.yandex_compute_instance.vm[0]: Creation complete after 41s [id=fhmr2d6v1btvnpmloaq8]

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.
ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state list
data.template_file.cloudinit
module.analytics.data.yandex_compute_image.my_image
module.analytics.yandex_compute_instance.vm[0]
module.marketing.data.yandex_compute_image.my_image
module.marketing.yandex_compute_instance.vm[0]
module.module_one.yandex_vpc_network.network_one
module.module_one.yandex_vpc_subnet.subnetwork_one
module.my_s3_bucket.data.yandex_client_config.client
module.my_s3_bucket.random_string.unique_id
module.my_s3_bucket.yandex_storage_bucket.this
module.vpc_dev.yandex_vpc_network.network_one
module.vpc_dev.yandex_vpc_subnet.subnetwork_one["ru-central1-a"]
module.vpc_prod.yandex_vpc_network.network_one
module.vpc_prod.yandex_vpc_subnet.subnetwork_one["ru-central1-a"]
module.vpc_prod.yandex_vpc_subnet.subnetwork_one["ru-central1-d"]

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state rm module.my_s3_bucket.data.yandex_client_config.client
Removed module.my_s3_bucket.data.yandex_client_config.client
Successfully removed 1 resource instance(s).

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state rm module.my_s3_bucket.random_string.unique_id
Removed module.my_s3_bucket.random_string.unique_id
Successfully removed 1 resource instance(s).

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state rm module.my_s3_bucket.yandex_storage_bucket.this
Removed module.my_s3_bucket.yandex_storage_bucket.this
Successfully removed 1 resource instance(s).

ijin@tatuin ~/Work/net-devops1/Terraform/04/src
$ terraform state list
data.template_file.cloudinit
module.analytics.data.yandex_compute_image.my_image
module.analytics.yandex_compute_instance.vm[0]
module.marketing.data.yandex_compute_image.my_image
module.marketing.yandex_compute_instance.vm[0]
module.module_one.yandex_vpc_network.network_one
module.module_one.yandex_vpc_subnet.subnetwork_one
module.vpc_dev.yandex_vpc_network.network_one
module.vpc_dev.yandex_vpc_subnet.subnetwork_one["ru-central1-a"]
module.vpc_prod.yandex_vpc_network.network_one
module.vpc_prod.yandex_vpc_subnet.subnetwork_one["ru-central1-a"]
module.vpc_prod.yandex_vpc_subnet.subnetwork_one["ru-central1-d"]
```

Скриншот: `Terraform/04/Screenshots/Task6 - storage 2026-11-11 18-11-45.png`

### Задание 7*

1. Разверните у себя локально vault, используя docker-compose.yml в проекте.
2. Для входа в web-интерфейс и авторизации terraform в vault используйте токен "education".
3. Создайте новый секрет по пути http://127.0.0.1:8200/ui/vault/secrets/secret/create
Path: example  
secret data key: test 
secret data value: congrats!  
4. Считайте этот секрет с помощью terraform и выведите его в output по примеру:
```
provider "vault" {
 address = "http://<IP_ADDRESS>:<PORT_NUMBER>"
 skip_tls_verify = true
 token = "education"
}
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
} 

Можно обратиться не к словарю, а конкретному ключу:
terraform console: >nonsensitive(data.vault_generic_secret.vault_example.data.<имя ключа в секрете>)
```
5. Попробуйте самостоятельно разобраться в документации и записать новый секрет в vault с помощью terraform. 

### Задание 8*
Попробуйте самостоятельно разобраться в документаци и с помощью terraform remote state разделить root модуль на два отдельных root-модуля: создание VPC , создание ВМ . 

### Правила приёма работы

В своём git-репозитории создайте новую ветку terraform-04, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-04.

В качестве результата прикрепите ссылку на ветку terraform-04 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 




