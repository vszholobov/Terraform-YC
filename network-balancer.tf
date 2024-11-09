resource "yandex_lb_network_load_balancer" "terraform-network-balancer" {
  name = "terraform-network-balancer"

  listener {
    name = "http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name = "https"
    port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.terraform-lb-group.id

    healthcheck {
      name = "http"
      interval = 5
      unhealthy_threshold = 2
      healthy_threshold = 2
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

resource "yandex_lb_target_group" "terraform-lb-group" {
  name = "terraform-lb-group"

  target {
    subnet_id = yandex_vpc_subnet.terraform-network-central1-a.id
    address = yandex_compute_instance.terraform-vm-ru-central-a.network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.terraform-network-central1-b.id
    address = yandex_compute_instance.terraform-vm-ru-central-b.network_interface[0].ip_address
  }
}

output "load_balancer_ip" {
  value = yandex_lb_network_load_balancer.terraform-network-balancer.listener.*.external_address_spec
}
