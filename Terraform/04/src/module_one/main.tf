terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.16"
}

locals {
  
}

# могу использовать var.env_name как опорный slug

resource "yandex_vpc_network" "network_one" {
  name = "${var.env_name}-one-network"
}

resource "yandex_vpc_subnet" "subnetwork_one" {
  name           = "${var.env_name}-one-subnetwork"
  zone           = var.zone
  network_id     = yandex_vpc_network.network_one.id
  v4_cidr_blocks = var.cidr
}
