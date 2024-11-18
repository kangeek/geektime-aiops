################################
# backend
################################

terraform {
  backend "cos" {
    region  = "ap-hongkong"
    bucket  = "tfstate-geektime-aiops-1258064038"
    prefix  = "homeworks/week1/yaml_to_infra_redis"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

################################
# 2. Yaml to Infra - redis
################################

module "cvm_k3s" {
  source   = "../modules/cvm"
  cvm_name = "k3s"
}

module "k3s" {
  source     = "../modules/k3s"
  public_ip  = module.cvm_k3s.public_ip
  private_ip = module.cvm_k3s.private_ip
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.k3s.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}

resource "helm_release" "crossplane" {
  depends_on       = [local_sensitive_file.kubeconfig]
  name             = "crossplane"
  repository       = "https://charts.crossplane.io/stable"
  chart            = "crossplane"
  namespace        = "crossplane"
  create_namespace = true
}
