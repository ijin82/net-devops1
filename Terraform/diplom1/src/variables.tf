# basic variables

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "internal_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "internal_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "cidr for internal ingress connections"
}

variable "vpc_name" {
  type        = string
  default     = "wm"
  description = "VPC network"
}

variable "subnet_name" {
  type        = string
  default     = "wm"
  description = "Subnet name with external access"
}

variable "subnet_internal_name" {
  type        = string
  default     = "wm_internal"
  description = "Subnet name with internal only access"
}

variable "app_db_name" {
  description = "MySQL application database name"
  type        = string
  default     = "wm_app"
}

variable "app_db_user" {
  description = "MySQL application database user name"
  type        = string
  default     = "wm_app_user"
}

# ssh ключ

variable "ssh_key_wm" {
  description = "Public SSH key for WM project"
  type        = string
}

# Имена сущностей

variable "server_name_app" {
  description = "Sever name for application"
  type        = string
  default     = "wm_app"
}

variable "server_name_db" {
  description = "Sever name for database"
  type        = string
  default     = "wm_db"
}

variable "server_name_redis" {
  description = "Sever name for redis"
  type        = string
  default     = "wm_redis"
}

# Свойства ВМ

variable "platform_id" {
    type        = string
    default     = "standard-v3"
    description = "VM platform ID"
}

variable "compute_image" {
    type        = string
    default     = "ubuntu-2404-lts"
    description = "VM compute image"
}

variable vm_app_resources {
  type = object({
    hostname=string
    cores=number, 
    memory=number, 
    core_fraction=number,
    hdd_size=number,
    hdd_type=string,
    hdd_block_size=number,
    preemptible=bool,
    nat=bool,
  })

  default = {
    hostname        = "app"
    cores           = 2
    memory          = 2
    core_fraction   = 20
    hdd_size        = 10
    hdd_type        = "network-hdd"
    hdd_block_size  = 4096
    preemptible     = true  # на проде должно быть false конечно, иначе выключится
    nat             = true
  }

  description = "Application VM resources"
}

variable vm_redis_resources {
  type = object({
    hostname=string
    cores=number, 
    memory=number, 
    core_fraction=number,
    hdd_size=number,
    hdd_type=string,
    hdd_block_size=number,
    preemptible=bool,
    nat=bool,
  })

  default = {
    hostname        = "redis"
    cores           = 2
    memory          = 2
    core_fraction   = 20
    hdd_size        = 10
    hdd_type        = "network-hdd"
    hdd_block_size  = 4096
    preemptible     = true  # на проде должно быть false конечно, иначе выключится
    nat             = false
  }

  description = "Redis VM resources"
}

# security groups 
# для внутреннего доступа

variable "security_group_internal" {
  description = "secrules internal ingress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий SSH"
      v4_cidr_blocks = ["10.0.1.0/24"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий MySQL"
      v4_cidr_blocks = ["10.0.1.0/24"]
      port           = 3306
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий Redis"
      v4_cidr_blocks = ["10.0.1.0/24"]
      port           = 6379
    },
  ]
}

# security groups 
# для внешнего доступа

variable "security_group_ingress" {
  description = "secrules ingress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    {
      protocol       = "TCP"
      description    = "разрешить входящий SSH"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 22
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий  HTTP"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 80
    },
    {
      protocol       = "TCP"
      description    = "разрешить входящий HTTPS"
      v4_cidr_blocks = ["0.0.0.0/0"]
      port           = 443
    },
  ]
}

# security groups 
# для исходящего траффика

variable "security_group_egress" {
  description = "secrules egress"
  type = list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  }))
  default = [
    { 
      protocol       = "TCP"
      description    = "разрешить весь исходящий трафик"
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = 0
      to_port        = 65365
    }
  ]
}

# cloud-init для Redis

data "template_file" "cloudinit_redis" {
  vars = {
    ssh_key_wm = var.ssh_key_wm
    redis_password = random_password.redis.result
  }

  template = file("./cloud-init-redis.yml")
}

# Container Registry

variable "registry_id" {
  description = "Yandex Container Registry ID"
  type        = string
}

variable "image_tag_app" {
  description = "Tag of application image in Container Registry"
  type        = string
  default     = "1.0.0"
}

variable "image_tag_web" {
  description = "Tag of web image in Container Registry"
  type        = string
  default     = "1.0.1"
}
