# использование git-based модулей (задача 1)
# resource "yandex_vpc_network" "develop" {
#   name = var.vpc_name
# }
# resource "yandex_vpc_subnet" "develop" {
#   name           = var.vpc_name
#   zone           = var.default_zone
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr
# }

# использование локального модуля (задача 2)
module "module_one" {
  source         = "./module_one"
  env_name       = "prod"
  zone           = "ru-central1-a"
  cidr           = ["10.0.1.0/24"]
}

module "marketing" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "marketing" 

  # было
  # network_id     = yandex_vpc_network.develop.id
  # стало
  network_id     = module.module_one.subnetwork_id

  subnet_zones   = ["ru-central1-a","ru-central1-d"]
  
  # было
  # subnet_ids     = [yandex_vpc_subnet.develop.id]
  # стало
  subnet_ids     = [module.module_one.subnetwork_id]

  instance_name  = "slot"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner= "i.ivanov",
    project = "accounting"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered # Для демонстрации №3
    serial-port-enable = 1
  }

}

module "analytics" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "analytics"

  # было
  # network_id     = yandex_vpc_network.develop.id
  # стало
  network_id     = module.module_one.subnetwork_id

  subnet_zones   = ["ru-central1-a"]
  
  # было
  # subnet_ids     = [yandex_vpc_subnet.develop.id]
  # стало
  subnet_ids     = [module.module_one.subnetwork_id]
  
  instance_name  = "slot"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.cloudinit.rendered # Для демонстрации №3
    serial-port-enable = 1
  }

}

# Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  vars = {
    ssh_key_my_vagrant = var.ssh_key_my_vagrant
  }

  template = file("./cloud-init.yml")
}

