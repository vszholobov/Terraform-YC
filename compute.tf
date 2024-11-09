resource "yandex_compute_instance" "terraform-vm-ru-central-a" {
  name = "terraform-vm-ru-central-a"
  zone = data.yandex_vpc_subnet.vszholobov-ru-central1-a.zone
  # service_account_id = yandex_iam_service_account.registry-sa.id

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ru-central-a.id
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.vszholobov-ru-central1-a.id
    nat       = true # public ip
  }

  metadata = {
    ssh-keys = file("~/.ssh/id_ed25519.pub")
    user-data = templatefile("${path.module}/meta_user.txt", { ssh-key = file("~/.ssh/id_ed25519.pub")})
  }
}

resource "yandex_compute_instance" "terraform-vm-ru-central-b" {
  name = "terraform-vm-ru-central-b"
  zone = data.yandex_vpc_subnet.vszholobov-ru-central1-b.zone
  # service_account_id = yandex_iam_service_account.registry-sa.id

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ru-central-b.id
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

resource "yandex_compute_disk" "boot-disk-ru-central-a" {
  name     = "terraform-disk-1"
  type     = "network-ssd"
  size     = "20"
  zone = data.yandex_vpc_subnet.vszholobov-ru-central1-a.zone
  image_id = "fd8siuoe8nerg8rrh011" # custom ubuntu 24-04 nginx
}

resource "yandex_compute_disk" "boot-disk-ru-central-b" {
  name     = "terraform-disk-2"
  type     = "network-ssd"
  size     = "20"
  zone = data.yandex_vpc_subnet.vszholobov-ru-central1-b.zone
  image_id = "fd8siuoe8nerg8rrh011" # custom ubuntu 24-04 nginx
}

data "yandex_vpc_subnet" "vszholobov-ru-central1-a" {
  name = "vszholobov-ru-central1-a"
  folder_id = "b1gjkfempsrcghn4r1on"

}

data "yandex_vpc_subnet" "vszholobov-ru-central1-b" {
  name = "vszholobov-ru-central1-b"
  folder_id = "b1gjkfempsrcghn4r1on"
}

output "terraform-vm-ru-central-a" {
  value = yandex_compute_instance.terraform-vm-ru-central-a.network_interface.0.nat_ip_address
}

output "terraform-vm-ru-central-b" {
  value = yandex_compute_instance.terraform-vm-ru-central-b.network_interface.0.nat_ip_address
}

# TODO: создать новую network, чтобы нагляднее было
# data "yandex_vpc_network" "vszholobov" {
#   name = "vszholobov"
#   folder_id = "b1gjkfempsrcghn4r1on"
# }
