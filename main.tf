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
    skip_requesting_account_id  = true # a necessary option when describing the backend for Terraform version 1.6.1 and older.
    skip_s3_checksum            = true # a necessary option when describing the backend for Terraform version 1.6.3 and older.

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
