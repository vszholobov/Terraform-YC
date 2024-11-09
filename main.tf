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
  service_account_key_file = "/Users/vszholobov/Desktop/yandex-cloud/vszholobov-terraform-key.json" # service-account
  folder_id = "b1guq3aif7jnbi3gfdg9" # terraform folder
}
