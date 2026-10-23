locals {

  # базовое имя ВМок для примера
  base_vm_name = "netology-develop-platform-"

  # имена каждой ВМки с интерполяцией переменной
  vm_names = {
    web: "${local.base_vm_name}web",
    db: "${local.base_vm_name}db"
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

  vms_resources = {
    web = {
        cores=2
        memory=2
        core_fraction=20
        hdd_size=10
        hdd_type="network-hdd"
        hdd_block_size=4096
        preemptible=true
        # nat=false
        nat=true
        zone="ru-central1-e"
    },
    db = {
        cores=2
        memory=4
        core_fraction=50
        hdd_size=10
        hdd_type="network-hdd"
        hdd_block_size=4096
        preemptible=true
        # nat=false
        nat=true
        zone="ru-central1-d"
    }
   }

}