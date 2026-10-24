# VM creation with for_each usage

resource "yandex_compute_instance" "main_replica" {

  depends_on = [ yandex_compute_instance.web ]
  
  # в случае если у нас map(object)
  # for_each = local.vm_main_replica_resources

  # в случае если у нас список 
  # мы пробегаемся по списку объектов и формируем ключ 
  # и значение (равное текущему элементу списка)
  # для целевого map который ожидает for_each
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  for_each = { for v in local.vm_main_replica_resources : v.name => v }

  name        = each.value.name
  platform_id = var.platform_id
  zone            = each.value.zone
  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = each.value.hdd_type
      size = each.value.hdd_size
      block_size = each.value.hdd_block_size
    }
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = each.value.nat

    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = local.vm_base_metadata
}