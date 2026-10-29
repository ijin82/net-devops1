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
  name        = var.vm_db_name
  platform_id = var.vm_db_yandex_compute_instance_platform_id
  # нужно обязательно явно указать зону, потому что сначала будет взята зона из
  # provider "yandex" zone 
  # и потом уже будет попытка прицеить к ней подсеть, в этом случае зона ВМ и зона подсети
  # должны совпадать, то есть зона подсети, имеет приоритет ниже чем дефолтная зона провайдера
  # zone        = var.yandex_compute_instance_zone.db
  zone            = var.vm_db_zone


  # нельзя просто сделать resources = var.vms_resources["db"] 
  # terraform не сможет распаковать такой объект сам!!
  # строго назначаем:
  resources {
    cores = var.vms_resources["db"].cores
    memory = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }

  metadata = {
    serial-port-enable = var.vms_metadata["db"].serial-port-enable
    ssh-keys = "${var.vms_metadata["db"].ssh-keys}${var.vms_ssh_root_key}"
  }

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

}

## nat gateway

# data "yandex_vpc_network" "net" {
#   folder_id = var.folder_id
#   name      = "default"
# }

resource "yandex_vpc_subnet" "subnet" {
  folder_id      = var.folder_id
  name           = "my-test-nat-subnetwork"
  v4_cidr_blocks = ["10.20.30.0/24"]
  zone           = var.default_zone
#   network_id     = data.yandex_vpc_network.net.id
  network_id     = yandex_vpc_network.develop.id
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id      = var.folder_id
  name           = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  folder_id      = var.folder_id
  name       = "test-route-table"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
