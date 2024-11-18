# CVM public IP
output "public_ip" {
  value = tencentcloud_instance.cvm[0].public_ip
}

output "private_ip" {
  value = tencentcloud_instance.cvm[0].private_ip
}
