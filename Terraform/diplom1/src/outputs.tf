output "app_url" {
  description = "URL приложения"
  value       = "http://${yandex_vpc_address.app.external_ipv4_address[0].address}"
}

output "app_public_ip" {
  description = "IP-адрес приложения"
  value       = yandex_vpc_address.app.external_ipv4_address[0].address
}

output "admin_password" {
  description = "Пароль администратора"
  value       = random_password.admin.result
  sensitive   = true
}

output "admin_login" {
  description = "Логин администратора"
  value       = local.admin_email
}
