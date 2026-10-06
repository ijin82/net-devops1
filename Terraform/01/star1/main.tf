terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100.0"
    }
  }
  required_version = "~>1.16.0" 
  /*
    Многострочный комментарий.
    Требуемая версия terraform
  */
}

variable "yandex_sa_key_file" {
  sensitive = true
}

provider "yandex" {
  service_account_key_file = var.yandex_sa_key_file
}

provider "docker" {
  context = "vm-star1"
}

resource "yandex_compute_instance" "netology-terraform-star1" {
  boot_disk {
    initialize_params {
      name       = "disk-ubuntu-24-04-lts-1791280257423"
      type       = "network-hdd"
      size       = 10
      block_size = 4096
      image_id   = "fd8luhgf9o8h5vli509b"
    }
    auto_delete = true
  }
  folder_id          = "b1gl6j5lv636j3ekvebc"
  hostname           = "netology-terraform-star1"
# (!!) сгенерировано в консоли YC и вызывает ошибку
#│ Error: Unsupported argument
#│ 
#│   on main.tf line 41, in resource "yandex_compute_instance" "netology-terraform-star1":
#│   41:   maintenance_policy = "MAINTENANCE_POLICY_UNSPECIFIED"
#│ 
#│ An argument named "maintenance_policy" is not expected here.
#  maintenance_policy = "MAINTENANCE_POLICY_UNSPECIFIED"

## оригинальный код metadata сгенерированный YC панелью
#  metadata = {
#    user-data               = "#cloud-config\ndatasource:\n Ec2:\n  strict_id: false\nssh_pwauth: no\nusers:\n- name: ijin\n  sudo: ALL=(ALL) NOPASSWD:ALL\n  shell: /bin/bash\n  ssh_authorized_keys:\n  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin"
#    ssh-keys                = "ijin:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin"
#    private_ui_created_from = "console"
#  }

# Сделано с помощью ИИ (изменен сгенерированный #cloud-config, добавлены пакеты и команды (огонь!!))
# cloud-init из слайда 10
# мы про него не говорили пока, мне просто было интересно
  metadata = {
    user-data = <<EOF
#cloud-config
datasource:
  Ec2:
    strict_id: false
ssh_pwauth: no
users:
  - name: ijin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin

package_update: true
packages:
  - docker.io
  - docker-compose-plugin

runcmd:
  - systemctl enable --now docker
  - usermod -aG docker ijin
EOF

    ssh-keys = "ijin:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPO/4xISFqSWTA70WFZm32XccKUnkcOtQFyAkremnt7 ijin@tatuin"
  }

  name = "netology-terraform-star1"
  network_interface {
    subnet_id = "e2l6ctki7qeev90ustih"
# (!!) сгенерировано в консоли YC и вызывает ошибку
#    index     = 0
    security_group_ids = [
      "enpg80k98aamk665o863"
    ]
    nat = true
  }
  platform_id = "standard-v3"
  resources {
    memory        = 2
    cores         = 2
    core_fraction = 50
  }
  scheduling_policy {
    preemptible = false
  }
  zone = "ru-central1-b"
}
