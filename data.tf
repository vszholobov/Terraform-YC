data "yandex_compute_image" "ubuntu_nginx" {
  image_id = local.compute_base_image_id
}

data "yandex_iam_service_account" "terraform_account" {
  service_account_id = local.terraform_account_id
}
