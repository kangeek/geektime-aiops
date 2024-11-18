terraform {
  required_version = "> 0.13.0"
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "1.81.128"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}

provider "tencentcloud" {
  region = "ap-hongkong"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig.yaml"
  }
}

provider "null" {}

