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

# get kubeconfig
locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "geektime-aiops"
    contexts = [{
      context = {
        cluster = "geektime-aiops"
        user : "geektime-aiops"
      }
      name = "geektime-aiops"
    }]
    clusters = [{
      cluster = {
        certificate-authority-data = base64encode(module.k3s.kubernetes.cluster_ca_certificate)
        server                     = module.k3s.kubernetes.api_endpoint
      }
      name = "geektime-aiops"
    }]
    users = [{
      user = {
        client-certificate-data : base64encode(module.k3s.kubernetes.client_certificate)
        client-key-data : base64encode(module.k3s.kubernetes.client_key)
      }
      name : "geektime-aiops"
    }]
  })
}

# write to kubeconfig.yaml file
resource "null_resource" "write_kubeconfig" {
  provisioner "local-exec" {
    command = <<EOT
      terraform output -raw kubeconfig > kubeconfig.yaml
    EOT
  }
}
