output "cvm_public_ip" {
  description = "The public IP of the K3S CVM instance"
  value = module.cvm_k3s.public_ip
}
