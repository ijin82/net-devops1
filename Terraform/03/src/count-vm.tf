# VM creation with count usage

resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "${local.vm_web_base_name}${count.index + 1}"
  platform_id = var.platform_id
  zone            = var.default_zone
  resources {
    cores         = local.vm_resources.cores
    memory        = local.vm_resources.memory
    core_fraction = local.vm_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = local.vm_resources.hdd_type
      size = local.vm_resources.hdd_size
      block_size = local.vm_resources.hdd_block_size
    }
  }

  scheduling_policy {
    preemptible = local.vm_resources.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = local.vm_resources.nat

    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = local.vm_base_metadata
}