terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

terraform {
  backend "cos" {
    region = "ap-hongkong"
    bucket = "tfstate-geektime-aiops-1258064038"
    prefix = "lessons/module2/demo3"
    key    = "terraform.tfstate"
    encrypt = true
  }
}

# Configure the TencentCloud Provider
provider "tencentcloud" {}
