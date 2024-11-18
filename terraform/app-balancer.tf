# in browser update page with clearing cookies to actually see different hosts
# or use curl

# yandex_alb_load_balancer.test-ab:
resource "yandex_alb_load_balancer" "terraform-application-balancer" {
  labels             = {}
  name               = "terraform-application-balancer"
  network_id         = yandex_vpc_network.terraform-network.id
  region_id          = "ru-central1"
  security_group_ids = []

  allocation_policy {
    location {
      disable_traffic = false
      subnet_id       = yandex_vpc_subnet.terraform-network-central1-a.id
      zone_id         = "ru-central1-a"
    }
    location {
      disable_traffic = false
      subnet_id       = yandex_vpc_subnet.terraform-network-central1-b.id
      zone_id         = "ru-central1-b"
    }
  }

  listener {
    name = "test-ab"

    endpoint {
      ports = [
        80,
      ]

      address {
        external_ipv4_address {
        }
      }
    }

    http {
      handler {
        allow_http10       = false
        http_router_id     = yandex_alb_http_router.test-ab.id
        rewrite_request_id = false
      }
    }
  }

  log_options {
    disable = false
    log_group_id = yandex_logging_group.terraform-application-balancer-log-group.id
  }
}

resource "yandex_logging_group" "terraform-application-balancer-log-group" {
  name = "terraform-application-balancer-log-group"
}

# yandex_alb_http_router.test-ab:
resource "yandex_alb_http_router" "test-ab" {
  labels     = {}
}

resource "yandex_alb_virtual_host" "terraform-virtual-host" {
  http_router_id = yandex_alb_http_router.test-ab.id
  name           = "terraform-virtual-host"
  authority = []
  route {
    name = "nginx-backends-central-a"
    http_route {
      http_route_action {
        auto_host_rewrite = false
        upgrade_types     = []
        backend_group_id  = yandex_alb_backend_group.terraform-backend-group.id
      }
    }
  }
}

resource "yandex_alb_backend_group" "terraform-backend-group" {
  name       = "terraform-backend-group"
  labels     = {}

  http_backend {
    http2            = false
    name             = "terraform-backend"
    port             = 80
    target_group_ids = [
      yandex_alb_target_group.central1-a.id,
      yandex_alb_target_group.central1-b.id
    ]
    weight           = 1

    healthcheck {
      healthcheck_port        = 80
      healthy_threshold       = 2
      unhealthy_threshold     = 2
      interval                = "5s"
      timeout                 = "1s"
      interval_jitter_percent = 0

      http_healthcheck {
        http2 = false
        path  = "/"
      }
    }

    load_balancing_config {
      locality_aware_routing_percent = 0
      mode                           = "ROUND_ROBIN"
      panic_threshold                = 0
      strict_locality                = false
    }
  }
}


# yandex_alb_target_group.central1-a:
resource "yandex_alb_target_group" "central1-a" {
  labels     = {}
  name       = "central1-a"

  target {
    ip_address           = yandex_compute_instance.terraform-vm-ru-central-a.network_interface.0.ip_address
    private_ipv4_address = false
    subnet_id            = yandex_vpc_subnet.terraform-network-central1-a.id
  }
}

# yandex_alb_target_group.central1-b:
resource "yandex_alb_target_group" "central1-b" {
  labels     = {}
  name       = "central1-b"

  target {
    ip_address           = yandex_compute_instance.terraform-vm-ru-central-b.network_interface.0.ip_address
    private_ipv4_address = false
    subnet_id            = yandex_vpc_subnet.terraform-network-central1-b.id
  }
}
