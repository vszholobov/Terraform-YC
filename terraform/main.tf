terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  folder_id = local.folder_id
  cloud_id = local.cloud_id
}

variable "ssh_key" {
  type = string
  sensitive = true
  description = "Public SSH key for connecting to virtual machines"
}

locals {
  compute_base_image_id = "fd8s6jrcg1vicej7v6ib" # image with nginx built by packer
  terraform_account_id = "aje9m24r267qloa1ogjh"
  folder_id = "b1gnu9b6p56oc5bvj3ji" # terraform folder yandex cloud id
  cloud_id = "b1gejt95t76oqne38ffb" # terraform cloud yandex cloud id
  ssh_key = var.ssh_key
}