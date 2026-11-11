output "network_id" {
  value = yandex_vpc_network.network_one.id
}

output "subnetwork_ids" {
  value = { for key, val in yandex_vpc_subnet.subnetwork_one : key => val.id }
}
