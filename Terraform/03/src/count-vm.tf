# VM creation with count usage

resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "${local.vm_web_base_name}${count.index + 1}"
  hostname        = "${local.vm_web_base_name}${count.index + 1}"
  platform_id = var.platform_id
  zone            = var.default_zone
  resources {
    cores         = var.vm_resources_web.cores
    memory        = var.vm_resources_web.memory
    core_fraction = var.vm_resources_web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = var.vm_resources_web.hdd_type
      size = var.vm_resources_web.hdd_size
      block_size = var.vm_resources_web.hdd_block_size
    }
  }

  scheduling_policy {
    preemptible = var.vm_resources_web.preemptible
  }

  # идентификатор созданной подсети -> yandex_vpc_subnet.develop.id
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm_resources_web.nat

    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = local.vm_base_metadata
}