terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex",
      version = "0.133.0"
    }
  }
  required_version = "1.9.8"

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

variable "ssh_key" {
  type = string
  sensitive = true
  description = "Public SSH key for connecting to virtual machines"
}

module "terraform" {
  source = "./terraform"
  ssh_key = var.ssh_key
}
