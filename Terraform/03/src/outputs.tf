locals {
  result_vms = concat(
      # разворачиваем мапы в листы
      yandex_compute_instance.web, # при использовании "count" Это уже лист!!
      values(yandex_compute_instance.main_replica), # при использовании "foreach" - это map - приводим мап к листу
      # [yandex_compute_instance.vm_3disks] # приводим один объект к листу
    )
}


output "vm_full_db" {
    value = [
        for m in local.result_vms : {
            name = m.name
            id = m.id
            fqdn = m.fqdn
        }
    ]
}
