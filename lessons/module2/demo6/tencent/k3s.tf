module "k3s" {
  source  = "xunleii/k3s/module"
  version = "3.4.0"

  depends_on_    = tencentcloud_instance.k3s
  k3s_version    = "latest"
  cluster_domain = "cluster.local"
  cidr = {
    pods     = "10.42.0.0/16"
    services = "10.43.0.0/16"
  }
  drain_timeout        = "30s"
  managed_fields       = ["label", "taint"] // ignore annotations
  k3s_install_env_vars = {}

  global_flags = [
    "--tls-san ${tencentcloud_instance.k3s[0].public_ip}",
    "--write-kubeconfig-mode 644",
    "--disable=traefik",
    "--kube-controller-manager-arg bind-address=0.0.0.0",
    "--kube-proxy-arg metrics-bind-address=0.0.0.0",
    "--kube-scheduler-arg bind-address=0.0.0.0"
  ]

  servers = {
    "k3s" = {
      ip = tencentcloud_instance.k3s[0].private_ip
      connection = {
        timeout  = "60s"
        type     = "ssh"
        host     = tencentcloud_instance.k3s[0].public_ip
        user     = "ubuntu"
        password = var.cvm_password
      }
    }
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.k3s.kube_config
  filename = "${path.module}/kubeconfig.yaml"
}
