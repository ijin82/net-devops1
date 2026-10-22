locals {

  # базовое имя ВМок для примера
  base_vm_name = "netology-develop-platform-"

  # имена каждой ВМки с интерполяцией переменной
  vm_names = {
    web: "${local.base_vm_name}web",
    db: "${local.base_vm_name}db"
  }

}