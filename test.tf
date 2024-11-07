terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-b"
  folder_id = "b1guq3aif7jnbi3gfdg9" # terraform folder
  service_account_key_file = "/Users/vszholobov/Desktop/yandex-cloud/vszholobov-terraform-key.json" # service-account
}


resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.vszholobov-ru-central1-b.id
    nat       = true # public ip
  }

  metadata = {
    ssh-keys = file("~/.ssh/id_ed25519.pub")
    user-data = templatefile("${path.module}/meta_user.txt", { ssh-key = file("~/.ssh/id_ed25519.pub")})
  }
}

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "terraform-disk"
  type     = "network-ssd"
  # zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd83h72fb5urnmt6vkfd" # ubuntu 24-04
}

# data "yandex_vpc_network" "vszholobov" {
#   name = "vszholobov"
#   folder_id = "b1gjkfempsrcghn4r1on"
# }

data "yandex_vpc_subnet" "vszholobov-ru-central1-b" {
  name = "vszholobov-ru-central1-b"
  folder_id = "b1gjkfempsrcghn4r1on"
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}


