resource "yandex_vpc_network" "terraform-network" {
  name = "terraform-network"
}

resource "yandex_vpc_subnet" "terraform-network-central1-a" {
  name = "terraform-network-ru-central1-a"
  network_id = yandex_vpc_network.terraform-network.id
  v4_cidr_blocks = ["10.132.0.0/24"]
  zone = "ru-central1-a"
}

resource "yandex_vpc_subnet" "terraform-network-central1-b" {
  name = "terraform-network-ru-central1-b"
  network_id = yandex_vpc_network.terraform-network.id
  v4_cidr_blocks = ["10.133.0.0/24"]
  zone = "ru-central1-b"
}
