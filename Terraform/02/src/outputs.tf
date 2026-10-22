
# 1. Объявите в файле outputs.tf **один** output , содержащий: 
# instance_name, external_ip, fqdn 
# для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
# 
# 2. Примените изменения.

# В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.

output "vm_result_web" {
    value = {
        instance_name: yandex_compute_instance.platform.name,
        external_ip: yandex_compute_instance.platform.network_interface[0].ip_address,
        fqdn: yandex_compute_instance.platform.fqdn,
    }
}

output "vm_result_db" {
    value = {
        instance_name: yandex_compute_instance.platform_db.name,
        external_ip: yandex_compute_instance.platform_db.network_interface[0].ip_address,
        fqdn: yandex_compute_instance.platform_db.fqdn,
    }
}

## ЕДИНЫЙ output для списка VM

locals {
  test_vms = [
    yandex_compute_instance.platform,
    yandex_compute_instance.platform_db
  ]
}


output "vm_full_db" {
    value = [
        for m in local.test_vms : {
            instance_name = m.name
            external_ip = m.network_interface[0].ip_address
            fqdn = m.fqdn
        }
    ]
}


# Outputs:
# 
# vm_result_db = {
#   "external_ip" = "10.0.2.33"
#   "fqdn" = "fv4kf6vnf8vjn2fpq260.auto.internal"
#   "instance_name" = "netology-develop-platform-db"
# }
# vm_result_web = {
#   "external_ip" = "10.0.1.20"
#   "fqdn" = "bg0l08lkj9afqd0cdk5d.auto.internal"
#   "instance_name" = "netology-develop-platform-web"
# }