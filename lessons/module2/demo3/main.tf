variable "project_id" {
  type    = string
  default = "1323177"
}
variable "key_id" {
  type    = string
  default = "skey-7imncx3r"
}

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
  cpu_core_count    = 2
  memory_size       = 4
  availability_zone = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  exclude_sold_out  = true
}

# Create a web server
resource "tencentcloud_instance" "web" {
  instance_name              = "web server"
  project_id                 = var.project_id
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  image_id                   = data.tencentcloud_images.default.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  key_ids                    = ["${var.key_id}"]
  orderly_security_groups    = [tencentcloud_security_group.default.id]
  count                      = 1
}

# Create security group
resource "tencentcloud_security_group" "default" {
  name        = "web accessibility"
  project_id  = var.project_id
  description = "make it accessible for both production and stage ports"
}

# Create security group rule allow web request
resource "tencentcloud_security_group_rule_set" "web" {
  security_group_id = tencentcloud_security_group.default.id
  ingress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "TCP"
    port        = "80,8080"
    description = "HTTP access"
  }
  ingress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "TCP"
    port        = "22"
    description = "SSH access"
  }
}