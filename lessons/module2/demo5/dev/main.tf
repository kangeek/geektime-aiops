terraform {
  backend "cos" {
    region  = "ap-hongkong"
    bucket  = "tfstate-geektime-aiops-1258064038"
    prefix  = "lessons/module2/demo5/dev"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

module "cvm_k3s" {
  source       = "../modules/cvm"
  cvm_name     = "k3s"
  cvm_password = var.cvm_password
  project_id   = var.project_id
}

module "k3s" {
  source       = "../modules/k3s"
  cvm_password = var.cvm_password
  public_ip    = module.cvm_k3s.public_ip
  private_ip   = module.cvm_k3s.private_ip
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.k3s.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}