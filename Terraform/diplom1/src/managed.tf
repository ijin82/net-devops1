# MySQL - создаем cluster
resource "yandex_mdb_mysql_cluster" "cluster" {
  name               = var.server_name_db
  environment        = "PRODUCTION"
  network_id         = yandex_vpc_network.wm.id
  version            = "8.0"
  security_group_ids = [yandex_vpc_security_group.wm-internal.id]

  resources {
    resource_preset_id = "c4a-c2-m4"
    disk_type_id       = "network-ssd"
    disk_size          = 10
  }

  host {
    zone             = var.default_zone
    subnet_id        = yandex_vpc_subnet.wm_internal.id
    assign_public_ip = false
  }

  mysql_config = {
    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    max_connections               = 50
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
  }

  # по-хорошему надо включить в продакшене для защиты от случайного удаления
  deletion_protection = false
}

# MySQL - настраиваем базу данных
resource "yandex_mdb_mysql_database" "db" {
  cluster_id = yandex_mdb_mysql_cluster.cluster.id
  name       = var.app_db_name
}

# MySQL - настраиваем пользователя БД
resource "yandex_mdb_mysql_user" "app_user" {
  cluster_id = yandex_mdb_mysql_cluster.cluster.id
  name       = var.app_db_user
  password   = random_password.db.result

  permission {
    database_name = yandex_mdb_mysql_database.db.name
    roles         = ["ALL"]
  }
}