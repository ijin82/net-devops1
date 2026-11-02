locals {

  # базовое имя ВМок для примера
  vm_web_base_name = "web-"

  vm_base_metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${file("~/.ssh/vagrant.pub")}"
  }


  # Квоты я почти все увеличил, чтобы всё помещалось в одну зону
  # про RAM 32GB квоту в одной зоне поддержка пока думает
  #
  #
  # МОИ КВОТЫ
  # ВМ: общее кол-во: 12
  # Диски: общее кол-во: 32шт, размер каждого не менее 5ГБ
  # Диски HDD: на зону ОБЪЕМ: 20Гб
  # Диски SSD: на зону ОБЪЕМ: 10Гб
  # vCPU: всего: 6шт, на зону: 2шт (core_fraction=20 * cores=2 дают 0.4 vCPU), на каждую виртуалку не меньше cores=2
  # RAM: всего: 48ГБ, на зону: 16ГБ

# Сказано сделать переменную - делаю переменную 
#  
#   vm_resources = {
#     cores           = 2
#     memory          = 2
#     core_fraction   = 20
#     hdd_size        = 5
#     hdd_type        = "network-hdd"
#     hdd_block_size  = 4096
#     preemptible     = true
#     nat             = true
#     zone            = "ru-central1-e"
#   }


# Сказано сделать переменную - делаю переменную 
#
#   vm_main_replica_resources = [
#     {
#       name                = "main"
#       cores               = 2
#       memory              = 4
#       core_fraction       = 20
#       hdd_size            = 5
#       hdd_type            = "network-hdd"
#       hdd_block_size      = 4096
#       preemptible         = true
#       nat                 = true
#       zone                = "ru-central1-e"
#     },
#     {
#       name                = "replica"
#       cores               = 2
#       memory              = 2
#       core_fraction       = 20
#       hdd_size            = 5
#       hdd_type            = "network-hdd"
#       hdd_block_size      = 4096
#       preemptible         = true
#       nat                 = true
#       zone                = "ru-central1-e"
#     }
#   ]

# Все перенес в переменные 

  # ВМ с тремя дополнительными дисками
#   vm_3disks_resources = {
#     name            = "vm_3disks"
#     cores           = 2
#     memory          = 2
#     core_fraction   = 20
#     hdd_size        = 5
#     hdd_type        = "network-hdd"
#     hdd_block_size  = 4096
#     preemptible     = true
#     nat             = true
#     zone            = "ru-central1-e"
#   }

#   disk_resources = {
#     type     = "network-hdd"
#     zone     = "ru-central1-e"
#     size     = 1
#   }


  # Задание 7
  vpc = {
    "network_id" = "enp7i560tb28nageq0cc"
    "subnet_ids" = [
      "e9b0le401619ngf4h68n",
      "e2lbar6u8b2ftd7f5hia",
      "b0ca48coorjjq93u36pl",
      "fl8ner8rjsio6rcpcf0h",
    ]
    "subnet_zones" = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-c",
      "ru-central1-d",
    ]
  }

  # муки мученические, вложенные тринарные операторы с циклами
  vpc_cleaned = {
    for k, v in local.vpc : k => (
      (k == "subnet_ids" || k == "subnet_zones")
      ? [for elem_index, str_value in v : str_value if elem_index != 2]
      : v
    )
  }
}