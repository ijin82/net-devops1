###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

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

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

# my additional vars

variable "platform_id" {
    type        = string
    default     = "standard-v3"
    description = "VM platform ID"
}

variable "compute_image" {
    type        = string
    default     = "ubuntu-2004-lts"
    description = "VM compute image"
}

variable "vms_ssh_key" {
    type        = string
    default     = "secret string"
    description = "Authorized public key"
}

variable vm_main_replica_resources {
  type = list(object({
    name=string, 
    hostname=string,
    cores=number, 
    memory=number, 
    core_fraction=number,
    hdd_size=number,
    hdd_type=string,
    hdd_block_size=number,
    preemptible=bool,
    nat=bool,
    zone=string
    }))

  default = [{
      name                = "main"
      hostname            = "main"
      cores               = 2
      memory              = 4
      core_fraction       = 20
      hdd_size            = 5
      hdd_type            = "network-hdd"
      hdd_block_size      = 4096
      preemptible         = true
      nat                 = true
      zone                = "ru-central1-d"
    },
    {
      name                = "replica"
      hostname            = "replica"
      cores               = 2
      memory              = 2
      core_fraction       = 20
      hdd_size            = 5
      hdd_type            = "network-hdd"
      hdd_block_size      = 4096
      preemptible         = true
      nat                 = true
      zone                = "ru-central1-d"
    }]

    description = "VM resources in details"
}


variable vm_resources_web {
  type = object({
    cores=number, 
    memory=number, 
    core_fraction=number,
    hdd_size=number,
    hdd_type=string,
    hdd_block_size=number,
    preemptible=bool,
    nat=bool,
    zone=string
  })

  default = {
    cores           = 2
    memory          = 2
    core_fraction   = 20
    hdd_size        = 5
    hdd_type        = "network-hdd"
    hdd_block_size  = 4096
    preemptible     = true
    nat             = true
    zone            = "ru-central1-d"
  }

  description = "Resources for web VM"
}

variable vm_3disks_resources {
  type = object({
    name=string
    hostname=string
    cores=number, 
    memory=number, 
    core_fraction=number,
    hdd_size=number,
    hdd_type=string,
    hdd_block_size=number,
    preemptible=bool,
    nat=bool,
    zone=string
  })

  default = {
    name            = "vm_3disks"
    hostname        = "vm-3disks" # нельзя использовать подчеркивания в hostname!!
    cores           = 2
    memory          = 2
    core_fraction   = 20
    hdd_size        = 5
    hdd_type        = "network-hdd"
    hdd_block_size  = 4096
    preemptible     = true
    nat             = true
    zone            = "ru-central1-d"
  }

  description = "Resources for VM with 3 disks"
}

variable disk_resources {
  type = object({
    type=string
    zone=string
    size=number
  })

  default = {
    type     = "network-hdd"
    zone     = "ru-central1-d"
    size     = 1
  }

  description = "Small sisc resources (for 3 disk exercize)"
}