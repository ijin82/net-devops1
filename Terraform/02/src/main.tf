resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  # может быть по умолчанию так же взята
  #zone           = var.default_zone
#   zone           = var.yandex_compute_instance_zone.web
  zone = local.vms_resources.web.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_vpc_subnet" "develop_zone_d" {
  name           = var.vpc_name_zone_d
  zone           = local.vms_resources.db.zone
  # zone           = var.yandex_compute_instance_zone.db
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_zone_d
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_yandex_compute_image
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_names.web
  platform_id = var.vm_web_yandex_compute_instance_platform_id

  resources {
    cores         = local.vms_resources.web.cores
    memory        = local.vms_resources.web.memory
    core_fraction = local.vms_resources.web.core_fraction
  }

#   resources {
#     cores         = var.vm_web_yandex_compute_instance_cores.web
#     memory        = var.vm_web_yandex_compute_instance_memory.web
#     core_fraction = var.vm_web_yandex_compute_instance_core_fraction.web
#   }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = local.vms_resources.web.hdd_type
      size = local.vms_resources.web.hdd_size
      block_size = local.vms_resources.web.hdd_block_size
    }
  }
  scheduling_policy {
    preemptible = local.vms_resources.web.preemptible
    # preemptible = var.vm_web_yandex_compute_instance_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = local.vms_resources.web.nat
    # nat       = var.vm_web_yandex_compute_instance_nat
  }

  metadata = local.metadata
#   metadata = {
#     serial-port-enable = var.vm_web_yandex_compute_instance_serial_port_enable
#     ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
#   }
}

resource "yandex_compute_instance" "platform_db" {
  name        = local.vm_names.db
  platform_id = var.vm_web_yandex_compute_instance_platform_id
  # нужно обязательно явно указать зону, потому что сначала будет взята зона из
  # provider "yandex" zone 
  # и потом уже будет попытка прицеить к ней подсеть, в этом случае зона ВМ и зона подсети
  # должны совпадать, то есть зона подсети, имеет приоритет ниже чем дефолтная зона провайдера
  # zone        = var.yandex_compute_instance_zone.db
  zone            = local.vms_resources.db.zone
  resources {
    cores         = local.vms_resources.db.cores
    memory        = local.vms_resources.db.memory
    core_fraction = local.vms_resources.db.core_fraction
  }

#   resources {
#     # Переменные скомпонованы по назначению самих переменных
#     #cores         = var.vm_web_yandex_compute_instance_cores.db
#     #memory        = var.vm_web_yandex_compute_instance_memory.db
#     #core_fraction = var.vm_web_yandex_compute_instance_core_fraction.db
    
#     # Переменные скомпонованы по типу ВМ (web / db)
#     cores         = var.vm_db_setup.cores
#     memory        = var.vm_db_setup.memory
#     core_fraction = var.vm_db_setup.core_fraction
#   }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = local.vms_resources.db.hdd_type
      size = local.vms_resources.db.hdd_size
      block_size = local.vms_resources.db.hdd_block_size
    }
  }
  scheduling_policy {
    preemptible = local.vms_resources.db.preemptible
    # preemptible = var.vm_web_yandex_compute_instance_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_zone_d.id
    nat = local.vms_resources.db.nat
    # nat       = var.vm_web_yandex_compute_instance_nat
  }

  metadata = local.metadata
#   metadata = {
#     serial-port-enable = var.vm_web_yandex_compute_instance_serial_port_enable
#     ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
#   }

}
