# Get availability zones
data "tencentcloud_availability_zones_by_product" "default" {
  product = "cvm"
}

# Get availability images
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "ubuntu"
}

# Get availability instance types
data "tencentcloud_instance_types" "default" {
  cpu_core_count   = 2
  memory_size      = 4
  exclude_sold_out = true
  filter {
    name   = "instance-family"
    values = ["SA5"]
  }
}

# Get my public IPs (with and without network proxy)
locals {
  ip_urls = [
    "https://ifconfig.cc/",   # IP from mainland China
    "https://ifconfig.me/",   # IP from western countries
    "https://ifconfig.tw/", # IP from eastern countries
  ]
}
data "http" "my_ips" {
  for_each = toset(local.ip_urls)
  url      = each.value
  request_headers = {
    "User-Agent" = "curl/7.64.0"
  }
}

# Create security group
resource "tencentcloud_security_group" "cvm" {
  name        = "for ${var.cvm_name}"
  project_id  = var.project_id
  description = "Security group for CVM ${var.cvm_name}"
}

# Create security group rule allow web request
resource "tencentcloud_security_group_rule_set" "cvm" {
  security_group_id = tencentcloud_security_group.cvm.id
  dynamic "ingress" {
    for_each = var.cvm_extra_ingress_rules
    content {
      action             = ingress.value.action
      cidr_block         = ingress.value.cidr_block != "" ? ingress.value.cidr_block : null
      source_security_id = ingress.value.source_security_id != "" ? ingress.value.source_security_id : null
      protocol           = ingress.value.protocol
      port               = ingress.value.port
      description        = ingress.value.description != "" ? ingress.value.description : null
    }
  }
  dynamic "ingress" {
    for_each = data.http.my_ips
    content {
      action      = "ACCEPT"
      cidr_block  = trimspace(ingress.value.response_body)
      protocol    = "TCP"
      port        = var.cvm_ingress_ports_from_me
      description = "Allow SSH access from me"
    }
  }
  egress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "ALL"
    port        = "ALL"
    description = "Allow all egress traffic"
  }
}

# Create the CVM
resource "tencentcloud_instance" "cvm" {
  depends_on                 = [tencentcloud_security_group_rule_set.cvm]
  instance_name              = var.cvm_name
  count                      = 1
  project_id                 = var.project_id
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones[0].name
  image_id                   = data.tencentcloud_images.default.images[0].image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types[0].instance_type
  system_disk_type           = "CLOUD_BSSD"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  key_ids                    = [var.cvm_ssh_key_id]
  instance_charge_type       = "SPOTPAID"
  spot_instance_type         = "ONE-TIME"
  spot_max_price             = "0.1"
  orderly_security_groups    = [tencentcloud_security_group.cvm.id]
}
