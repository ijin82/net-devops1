###cloud vars


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
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_yandex_compute_image" {
    type        = string
    default     = "ubuntu-2004-lts"
    description = "yandex_compute_image"
}


variable "vm_web_yandex_compute_instance_name" {
    type        = string
    default     = "netology-develop-platform-web"
    description = "VM name"
}

variable "vm_web_yandex_compute_instance_platform_id" {
    type        = string
    default     = "standard-v3"
    description = "VM platform ID"
}

variable "vm_web_yandex_compute_instance_cores" {
    type        = number
    default     = 2
    description = "Number of cores"
}

variable "vm_web_yandex_compute_instance_memory" {
    type        = number
    default     = 1
    description = "Memory value in GB"
}

variable "vm_web_yandex_compute_instance_core_fraction" {
    type        = number
    default     = 20
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

