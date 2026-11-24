# сеть
resource "yandex_vpc_network" "wm" {
  name = var.vpc_name
}

# nat gateway для Redis 
resource "yandex_vpc_gateway" "wm_nat_gateway" {
  folder_id      = var.folder_id
  name           = "wm-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  folder_id   = var.folder_id
  name        = "wm-route-table"
  network_id  = yandex_vpc_network.wm.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.wm_nat_gateway.id
  }
}

# подсеть для внешнего доступа
resource "yandex_vpc_subnet" "wm" {
  name           = var.subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.wm.id
  v4_cidr_blocks = var.default_cidr
}

# подсеть для внутреннего доступа с гейтвеем наружу
resource "yandex_vpc_subnet" "wm_internal" {
  name           = var.subnet_internal_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.wm.id
  v4_cidr_blocks = var.internal_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

# группа безопасности для серверов с внешним доступом
resource "yandex_vpc_security_group" "wm-external" {
  name       = "wm_external"
  network_id = yandex_vpc_network.wm.id
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}

# группа безопасности для серверов с внутренним доступом
resource "yandex_vpc_security_group" "wm-internal" {
  name       = "wm_internal"
  network_id = yandex_vpc_network.wm.id
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.security_group_internal
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = var.internal_cidrs
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}

# MySQL - создаем cluster
#resource "yandex_mdb_mysql_cluster" "cluster" {
#  name        = var.server_name_db
#  environment = "PRODUCTION"
#  network_id  = yandex_vpc_network.wm.id
#  version     = "8.0"
#  security_group_ids = [yandex_vpc_security_group.wm-internal.id]
#
#  resources {
#    resource_preset_id = "c4a-c2-m4"
#    disk_type_id       = "network-ssd"
#    disk_size          = 10
#  }
#
#
#  host {
#    zone             = var.default_zone
#    subnet_id        = yandex_vpc_subnet.wm.id
#    assign_public_ip = false
#  }
#
#  mysql_config = {
#    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
#    max_connections               = 50
#    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
#  }
#
#  # по-хорошему надо включить в продакшене для защиты от случайного удаления
#  deletion_protection = false
#}

# MySQL - настраиваем базу данных
#resource "yandex_mdb_mysql_database" "db" {
#  cluster_id = yandex_mdb_mysql_cluster.cluster.id
#  name       = var.app_db_name
#}
#
## MySQL - настраиваем пользователя БД
#resource "yandex_mdb_mysql_user" "app_user" {
#  cluster_id = yandex_mdb_mysql_cluster.cluster.id
#  name       = var.app_db_user
#  password   = random_password.db.result
#
#  permission {
#    database_name = yandex_mdb_mysql_database.db.name
#    roles         = ["ALL"]
#  }
#}

# Образ из которого будет собрана ВМ приложения и Redis

data "yandex_compute_image" "ubuntu" {
  family = var.compute_image
}

# Redis VM - редис для кеширования
resource "yandex_compute_instance" "redis" {

#   depends_on = [ yandex_mdb_mysql_database.db ]
  name            = var.server_name_redis
  platform_id     = var.platform_id
  zone            = var.default_zone
  hostname        = var.vm_redis_resources.hostname

  resources {
    cores         = var.vm_redis_resources.cores
    memory        = var.vm_redis_resources.memory
    core_fraction = var.vm_redis_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = var.vm_redis_resources.hdd_type
      size = var.vm_redis_resources.hdd_size
      block_size = var.vm_redis_resources.hdd_block_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_redis_resources.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.wm_internal.id
    nat = var.vm_redis_resources.nat

    security_group_ids = [
      yandex_vpc_security_group.wm-internal.id
    ]
  }

  metadata = {
    user-data          = data.template_file.cloudinit_redis.rendered
    serial-port-enable = 1
  }
}

# Application - само приложение, docker, nginx, git

resource "yandex_compute_instance" "application" {

#   depends_on = [ yandex_mdb_mysql_database.db, yandex_compute_instance.redis ]
  name            = var.server_name_app
  platform_id     = var.platform_id
  zone            = var.default_zone
  hostname        = var.vm_app_resources.hostname

  resources {
    cores         = var.vm_app_resources.cores
    memory        = var.vm_app_resources.memory
    core_fraction = var.vm_app_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = var.vm_app_resources.hdd_type
      size = var.vm_app_resources.hdd_size
      block_size = var.vm_app_resources.hdd_block_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_app_resources.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.wm.id
    nat = var.vm_app_resources.nat

    security_group_ids = [
      yandex_vpc_security_group.wm-external.id
    ]
  }

  metadata = {
    user-data          = data.template_file.cloudinit_app.rendered
    serial-port-enable = 1
  }
}