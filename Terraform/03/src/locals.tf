locals {

  # базовое имя ВМок для примера
  vm_web_base_name = "web-"

  vm_base_metadata = {
    serial-port-enable = 1
    # ssh-keys           = "ubuntu:${vars.vms_ssh_key}"
    ssh-keys           = "ubuntu:${file("~/.ssh/vagrant.pub")}"
  }

  # МОИ КВОТЫ
  # ВМ: общее кол-во: 12
  # Диски: общее кол-во: 32шт, размер каждого не менее 5ГБ
  # Диски HDD: на зону ОБЪЕМ: 20Гб
  # Диски SSD: на зону ОБЪЕМ: 10Гб
  # vCPU: всего: 6шт, на зону: 2шт (core_fraction=20 * cores=2 дают 0.4 vCPU), на каждую виртуалку не меньше cores=2
  # RAM: всего: 48ГБ, на зону: 16ГБ
  
  vm_resources = {
    cores           = 2
    memory          = 2
    core_fraction   = 20
    hdd_size        = 5
    hdd_type        = "network-hdd"
    hdd_block_size  = 4096
    preemptible     = true
    nat             = true
    zone            = "ru-central1-e"
  }

  vm_main_replica_resources = [
    {
      name                = "main"
      cores               = 2
      memory              = 4
      core_fraction       = 20
      hdd_size            = 5
      hdd_type            = "network-hdd"
      hdd_block_size      = 4096
      preemptible         = true
      nat                 = true
      zone                = "ru-central1-e"
    },
    {
      name                = "replica"
      cores               = 2
      memory              = 2
      core_fraction       = 20
      hdd_size            = 5
      hdd_type            = "network-hdd"
      hdd_block_size      = 4096
      preemptible         = true
      nat                 = true
      zone                = "ru-central1-e"
    }
  ]

}