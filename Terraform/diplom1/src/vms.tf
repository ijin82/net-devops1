# Образ из которого будет собрана ВМ приложения и Redis

data "yandex_compute_image" "ubuntu" {
  family = var.compute_image
}

# Статический публичный IP приложения: нужен для APP_URL в .env
resource "yandex_vpc_address" "app" {
  name = "wm-app-ip"

  external_ipv4_address {
    zone_id = var.default_zone
  }
}

locals {
  registry    = "cr.yandex/${var.registry_id}"
  admin_email = "admin@example.com"

  # Единый источник реквизитов для приложения: IP/пароли MySQL и Redis,
  # ключ Laravel и учетка администратора.
  app_env = {
    APP_NAME            = "Wired Mind"
    APP_ENV             = "production"
    APP_DEBUG           = "false"
    APP_KEY             = "base64:${base64encode(random_password.app_key.result)}"
    APP_URL             = "http://${yandex_vpc_address.app.external_ipv4_address[0].address}"
    APP_LOCALE          = "en"
    APP_FALLBACK_LOCALE = "en"
    LOG_CHANNEL         = "stderr"
    LOG_LEVEL           = "info"
    BCRYPT_ROUNDS       = "12"

    DB_CONNECTION = "mysql"
    DB_HOST       = tolist(yandex_mdb_mysql_cluster.cluster.host)[0].fqdn
    DB_PORT       = "3306"
    DB_DATABASE   = var.app_db_name
    DB_USERNAME   = var.app_db_user
    DB_PASSWORD   = random_password.db.result

    SESSION_DRIVER   = "redis"
    SESSION_LIFETIME = "120"
    CACHE_STORE      = "redis"
    QUEUE_CONNECTION = "sync"

    REDIS_CLIENT   = "predis"
    REDIS_HOST     = yandex_compute_instance.redis.network_interface[0].ip_address
    REDIS_PORT     = "6379"
    REDIS_PASSWORD = random_password.redis.result
    REDIS_DB       = "0"
    REDIS_CACHE_DB = "1"

    ADMIN_EMAIL    = local.admin_email
    ADMIN_PASSWORD = random_password.admin.result
  }

  env_file = join("\n", [for key, value in local.app_env : "${key}=${value}"])
}

# Redis VM - редис для кеширования
resource "yandex_compute_instance" "redis" {

  depends_on = [ yandex_mdb_mysql_database.db ]
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
      image_id    = data.yandex_compute_image.ubuntu.image_id
      type        = var.vm_redis_resources.hdd_type
      size        = var.vm_redis_resources.hdd_size
      block_size  = var.vm_redis_resources.hdd_block_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_redis_resources.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.wm_internal.id
    nat       = var.vm_redis_resources.nat

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

  depends_on = [
    yandex_mdb_mysql_database.db,
    yandex_mdb_mysql_user.app_user,
    yandex_compute_instance.redis,
  ]

  name        = var.server_name_app
  platform_id = var.platform_id
  zone        = var.default_zone
  hostname    = var.vm_app_resources.hostname

  resources {
    cores         = var.vm_app_resources.cores
    memory        = var.vm_app_resources.memory
    core_fraction = var.vm_app_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id   = data.yandex_compute_image.ubuntu.image_id
      type       = var.vm_app_resources.hdd_type
      size       = var.vm_app_resources.hdd_size
      block_size = var.vm_app_resources.hdd_block_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_app_resources.preemptible
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.wm.id
    nat            = var.vm_app_resources.nat
    nat_ip_address = yandex_vpc_address.app.external_ipv4_address[0].address

    security_group_ids = [
      yandex_vpc_security_group.wm-external.id
    ]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init-app.yml.tftpl", {
      ssh_key_wm = var.ssh_key_wm
      env_file   = local.env_file
      app_image  = "${local.registry}/wired-mind-app:${var.image_tag_app}"
      web_image  = "${local.registry}/wired-mind-web:${var.image_tag_web}"
      db_host    = tolist(yandex_mdb_mysql_cluster.cluster.host)[0].fqdn
    })
    serial-port-enable = 1
  }
}
