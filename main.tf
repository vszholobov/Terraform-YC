terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  backend "local" { path = "./terraform-state/terraform.tfstate" }
}

provider "yandex" {
  service_account_key_file = "/Users/vszholobov/Desktop/yandex-cloud/terraform-terraform-key.json" # service-account
  folder_id = local.folder_id
  cloud_id = local.cloud_id
}

locals {
  compute_base_image_id = "fd8s6jrcg1vicej7v6ib" # image with nginx built by packer
  folder_id = "b1gnu9b6p56oc5bvj3ji" # terraform folder
  cloud_id = "b1gejt95t76oqne38ffb" # terraform cloud
}
