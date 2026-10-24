# disks creation
# https://yandex.cloud/ru/docs/terraform/resources/compute_disk

resource "yandex_compute_disk" "additional_disks" {
  count    = 3
  name     = "disc-for-vm3disks-${count.index + 1}"
  type     = local.disk_resources.type
  zone     = local.disk_resources.zone
  size     = local.disk_resources.size

  labels = {
    environment = "test-${count.index + 1}"
  }
}

# VM creation 

resource "yandex_compute_instance" "vm_3disks" {

  name        = local.vm_3disks_resources.name
  platform_id = var.platform_id
  zone            = local.vm_3disks_resources.zone

  resources {
    cores         = local.vm_3disks_resources.cores
    memory        = local.vm_3disks_resources.memory
    core_fraction = local.vm_3disks_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = local.vm_3disks_resources.hdd_type
      size = local.vm_3disks_resources.hdd_size
      block_size = local.vm_3disks_resources.hdd_block_size
    }
  }


  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional_disks

    content {
      # должно работать это
      # disk_id = each.value.id

      # но работает это
      disk_id = secondary_disk.value.id
    }
  }

  scheduling_policy {
    preemptible = local.vm_3disks_resources.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = local.vm_3disks_resources.nat

    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = local.vm_base_metadata
}