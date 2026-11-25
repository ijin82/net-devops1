# сеть
resource "yandex_vpc_network" "wm" {
  name = var.vpc_name
}

# nat gateway для Redis 
resource "yandex_vpc_gateway" "wm_nat_gateway" {
  folder_id      = var.folder_id
  name           = "wm-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  folder_id   = var.folder_id
  name        = "wm-route-table"
  network_id  = yandex_vpc_network.wm.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.wm_nat_gateway.id
  }
}

# подсеть для внешнего доступа
resource "yandex_vpc_subnet" "wm" {
  name           = var.subnet_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.wm.id
  v4_cidr_blocks = var.default_cidr
}

# подсеть для внутреннего доступа с гейтвеем наружу
resource "yandex_vpc_subnet" "wm_internal" {
  name           = var.subnet_internal_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.wm.id
  v4_cidr_blocks = var.internal_cidr
  route_table_id = yandex_vpc_route_table.rt.id
}

# группа безопасности для серверов с внешним доступом
resource "yandex_vpc_security_group" "wm-external" {
  name       = "wm_external"
  network_id = yandex_vpc_network.wm.id
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = lookup(ingress.value, "v4_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}

# группа безопасности для серверов с внутренним доступом
resource "yandex_vpc_security_group" "wm-internal" {
  name       = "wm_internal"
  network_id = yandex_vpc_network.wm.id
  folder_id  = var.folder_id

  dynamic "ingress" {
    for_each = var.security_group_internal
    content {
      protocol       = lookup(ingress.value, "protocol", null)
      description    = lookup(ingress.value, "description", null)
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = var.internal_cidrs
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = lookup(egress.value, "protocol", null)
      description    = lookup(egress.value, "description", null)
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = lookup(egress.value, "v4_cidr_blocks", null)
    }
  }
}
