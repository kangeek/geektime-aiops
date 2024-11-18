# CVM public IP
output "k3s_public_ip" {
  value = tencentcloud_instance.k3s[0].public_ip
}
