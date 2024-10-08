resource "helm_release" "argo_cd" {
  depends_on       = [module.k3s, null_resource.write_kubeconfig]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}
