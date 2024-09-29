data "tencentcloud_user_info" "info" {}

locals {
  app_id = data.tencentcloud_user_info.info.app_id
}

resource "tencentcloud_cos_bucket" "terraform_state" {
  bucket = "tfstate-geektime-aiops-${local.app_id}"
  acl    = "private"
}
