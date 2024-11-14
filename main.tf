terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "vszholobov-terraform-state-storage"
    region = "ru-central1-a"
    key    = "terraform-state/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # необходимая опция при описании бэкенда для Terraform версии 1.6.1 и старше.
    skip_s3_checksum            = true # необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}

provider "yandex" {
  folder_id = local.folder_id
  cloud_id = local.cloud_id
}

variable "ssh_key" {
  type = string
  sensitive = true
}

locals {
  compute_base_image_id = "fd8s6jrcg1vicej7v6ib" # image with nginx built by packer
  folder_id = "b1gnu9b6p56oc5bvj3ji" # terraform folder
  cloud_id = "b1gejt95t76oqne38ffb" # terraform cloud
  ssh_key = var.ssh_key
}
