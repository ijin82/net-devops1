resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl", {
    
    # Исправленные переменные
    webservers = yandex_compute_instance.web # при использовании "count" Это уже лист!!
    databases = values(yandex_compute_instance.main_replica), # при использовании "foreach" - это map - приводим мап к листу
    storage = [yandex_compute_instance.vm_3disks] # приводим один объект к листу
  })

  filename = "${abspath(path.module)}/hosts.ini"
}

# Наши машины: web-1 web-2 main replica vm_3disks 
# ~} - тильда в таком шаблоне означает - не добавлять перевод строки после этой инструкции

# for.ini
resource "local_file" "hosts_for" {
  content =  <<-EOT
%{if length(yandex_compute_instance.web) > 0 ~}
[webservers]
%{for i in yandex_compute_instance.web ~}
%{if length(yandex_compute_instance.web) > 0 ~}
${i["name"]}   ansible_host=${i["network_interface"][0]["ip_address"]} fqdn=${i.fqdn}
%{else ~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i.fqdn}
%{endif ~}
%{endfor ~}
%{endif ~}

%{if length(yandex_compute_instance.main_replica) > 0 ~}
[databases]
%{for i in yandex_compute_instance.main_replica ~}
${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i.fqdn}
%{endfor ~}
%{endif ~}

[storage]
${yandex_compute_instance.vm_3disks.name}   ansible_host=${yandex_compute_instance.vm_3disks.network_interface[0].nat_ip_address} fqdn=${yandex_compute_instance.vm_3disks.fqdn}
EOT

  filename = "${abspath(path.module)}/for.ini"
}

locals {
  # все сервера склеиваем в общий лист
  instances_yaml = concat(
    # разворачиваем мапы в листы
    yandex_compute_instance.web,
    values(yandex_compute_instance.main_replica),
    # приевращаем в мап одну ВМ
    [yandex_compute_instance.vm_3disks]
  )
}

# hosts.yaml
resource "local_file" "hosts_yaml" {
  content =  <<-EOT
all:
  hosts:
%{ for i in local.instances_yaml ~}
    ${i["name"]}:
        ansible_host: ${i["network_interface"][0]["nat_ip_address"]}
        ansible_user: ubuntu
%{ endfor ~}
EOT
  filename = "${abspath(path.module)}/hosts.yaml"
}


# Для задания 8
resource "local_file" "hosts_templatefile_task8" {
  content = templatefile("${path.module}/hosts_task8.tftpl", {
    # все сервера склеиваем в общий лист
    webservers = concat(
      # разворачиваем мапы в листы
      yandex_compute_instance.web, # при использовании "count" Это уже лист!!
      values(yandex_compute_instance.main_replica), # при использовании "foreach" - это map - приводим мап к листу
      [yandex_compute_instance.vm_3disks] # приводим один объект к листу
    )
  })

  filename = "${abspath(path.module)}/hosts_task8.ini"
}