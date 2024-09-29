# Kubeconfig
output "kubeconfig" {
  value     = module.k3s.kube_config
  sensitive = true
}

output "kubernetes" {
  value = module.k3s.kubernetes
}
