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

provider "docker" {
  context = "vm-star1"
}

resource "docker_image" "my1_mysql" {
  name = "mysql:8"
}

# это чувствительные данные, помечены "sensitive" 
# и будут скрыты там где это возможно самим тераформом
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
# random_password.mysql_passwords["root"].result
resource "random_password" "mysql_passwords" {
  for_each = toset(["root", "user"]) # Списком задаем ключи
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_container" "my1_mysql" {
  name  = "mysql"
  image = docker_image.my1_mysql.image_id

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_passwords["root"].result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_passwords["user"].result}",
    "MYSQL_ROOT_HOST=%",
  ]

  ports {
    internal = 3306
    external = 3306
  }
}