variable "vm_web_yandex_compute_image" {
    type        = string
    default     = "ubuntu-2004-lts"
    description = "yandex_compute_image"
}

variable "yandex_compute_instance_zone" {
    type        = map
    default     = {web = "ru-central1-e", db = "ru-central1-d"}
    description = "VM name"
}

variable "vm_web_yandex_compute_instance_name" {
    type        = map
    default     = {web = "netology-develop-platform-web", db = "netology-develop-platform-db"}
    description = "VM name"
}

variable "vm_web_yandex_compute_instance_platform_id" {
    type        = string
    default     = "standard-v3"
    description = "VM platform ID"
}

variable "vm_web_yandex_compute_instance_cores" {
    type        = map
    default     = {web = 2, db = 2}
    description = "Number of cores"
}

variable "vm_web_yandex_compute_instance_memory" {
    type        = map
    default     = {web = 1, db = 1}
    description = "Memory value in GB"
}

variable "vm_web_yandex_compute_instance_core_fraction" {
    type        = map
    default     = {web = 20, db = 50}
    description = "Core fraction (20,50,100)"
}

variable "vm_web_yandex_compute_instance_preemptible" {
    type        = bool
    default     = true
    description = "preemptible or not (automatical switch off enabled)"
}

variable "vm_web_yandex_compute_instance_nat" {
    type        = bool
    default     = false
    description = "NAT enabled or not"
}

variable "vm_web_yandex_compute_instance_serial_port_enable" {
    type        = number
    default     = 1
    description = "Serial port enabled or not (1 or 0)"
}

## пример набора изменяемых переменных под ВМ
## так в main.tf будут ссылки на переменные вида 
## var.vm_web_setup.cores
## var.vm_web_setup.memory
## var.vm_web_setup.core_fraction
## var.vm_db_setup.cores
## var.vm_db_setup.memory
## var.vm_db_setup.core_fraction

# web
variable vm_web_setup {
    type        = map
    default     = {cores = 2, memory = 1, core_fraction = 20}
    description = "Cores number (2, 3, 5, NN), memory in GB (1, 2, NN), core fraction (20,50,100)"
}
# db
variable vm_db_setup {
    type        = map
    default     = {cores = 2, memory = 1, core_fraction = 20}
    description = "Cores number (2, 3, 5, NN), memory in GB (1, 2, NN), core fraction (20,50,100)"
}