variable "vm_web_yandex_compute_image" {
    type        = string
    default     = "ubuntu-2004-lts"
    description = "yandex_compute_image"
}

# variable "yandex_compute_instance_zone" {
#     type        = map
#     default     = {web = "ru-central1-e", db = "ru-central1-d"}
#     description = "VM name"
# }

# variable "vm_web_yandex_compute_instance_name" {
#     type        = map
#     default     = {web = "netology-develop-platform-web", db = "netology-develop-platform-db"}
#     description = "VM name"
# }

variable "vm_web_yandex_compute_instance_platform_id" {
    type        = string
    default     = "standard-v3"
    description = "VM platform ID"
}

# variable "vm_web_yandex_compute_instance_cores" {
#     type        = map
#     default     = {web = 2, db = 2}
#     description = "Number of cores"
# }

# variable "vm_web_yandex_compute_instance_memory" {
#     type        = map
#     default     = {web = 1, db = 1}
#     description = "Memory value in GB"
# }

# variable "vm_web_yandex_compute_instance_core_fraction" {
#     type        = map
#     default     = {web = 20, db = 50}
#     description = "Core fraction (20,50,100)"
# }

# variable "vm_web_yandex_compute_instance_preemptible" {
#     type        = bool
#     default     = true
#     description = "preemptible or not (automatical switch off enabled)"
# }

# variable "vm_web_yandex_compute_instance_nat" {
#     type        = bool
#     default     = false
#     description = "NAT enabled or not"
# }

# variable "vm_web_yandex_compute_instance_serial_port_enable" {
#     type        = number
#     default     = 1
#     description = "Serial port enabled or not (1 or 0)"
# }

## пример набора изменяемых переменных по типу ВМ
## так в main.tf будут ссылки на переменные вида 
## var.vm_web_setup.cores
## var.vm_web_setup.memory
## var.vm_web_setup.core_fraction
## var.vm_db_setup.cores
## var.vm_db_setup.memory
## var.vm_db_setup.core_fraction


variable vm_db_yandex_compute_instance_platform_id {
    type        = string
    default     = "standard-v3"
    description = "VM platform ID"
}

variable vm_db_name {
  type        = string
  default     = "netology-develop-platform-db"
  description = "VM name"
}

variable vm_db_zone {
  type        = string
  default     = "ru-central1-d"
  description = "VM zone"
}

# variable vm_db_cores {
#   type        = number
#   default     = 2
#   description = "Cores number (2, 3, 5, NN)"
# }
# 
# variable vm_db_memory {
#   type        = number
#   default     = 2
#   description = "memory in GB (1, 2, NN)"
# }
# 
# variable vm_db_core_fraction {
#   type        = number
#   default     = 20
#   description = "core fraction (20,50,100)"
# }

variable vms_resources {
  type = map(object({cores = number, memory = number, core_fraction = number}))

  default = {
    web = {
      cores = 2,
      memory = 2,
      core_fraction = 20
    }
    db = {
      cores = 2,
      memory = 2,
      core_fraction = 20
    }
  }

  description = "Expected values { cores: 2, memory: 2, core_fraction: 2 }"
}

variable vms_metadata {
  type = map(object({serial-port-enable = number, ssh-keys = string}))

  default = {
    web = {
      serial-port-enable = 1
      ssh-keys           = "ubuntu:"
    }
    db = {
      serial-port-enable = 1
      ssh-keys           = "ubuntu:"
    }
  }

  description = "Expected values { serial-port-enable = 1 ssh-keys = STRING }"
}

variable base_vm_name {
    type = string
    default = "netology-develop-platform-"
    description = "Base VM name (starting with)"
}

variable vm_short_names {
  type = map(string)
  default = {
    web = "web"
    db = "db"
  }
  description = "Short VM names for example"
}


# # web
# variable vm_web_setup {
#     type        = map
#     default     = {cores = 2, memory = 1, core_fraction = 20}
#     description = "Cores number (2, 3, 5, NN), memory in GB (1, 2, NN), core fraction (20,50,100)"
# }
# # db
# variable vm_db_setup {
#     type        = map
#     default     = {cores = 2, memory = 1, core_fraction = 20}
#     description = "Cores number (2, 3, 5, NN), memory in GB (1, 2, NN), core fraction (20,50,100)"
# }