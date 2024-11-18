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

# Create security group
resource "tencentcloud_security_group" "k3s_all_in_one" {
  name        = "k3s all-in-one server"
  project_id  = var.project_id
  description = "make it accessible for both production and stage ports"
}

# Create security group rule allow web request
resource "tencentcloud_security_group_rule_set" "k3s_all_in_one" {
  security_group_id = tencentcloud_security_group.k3s_all_in_one.id
  ingress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "TCP"
    port        = "22"
    description = "SSH access"
  }
  ingress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "TCP"
    port        = "6443"
    description = "K8S api-server access"
  }
  egress {
    action      = "ACCEPT"
    cidr_block  = "0.0.0.0/0"
    protocol    = "ALL"
    port        = "ALL"
    description = "Allow all traffic"
  }
}

# Create a k3s server
resource "tencentcloud_instance" "k3s" {
  depends_on                 = [tencentcloud_security_group_rule_set.k3s_all_in_one]
  instance_name              = "k3s-all-in-one"
  count                      = 1
  project_id                 = var.project_id
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones[0].name
  image_id                   = data.tencentcloud_images.default.images[0].image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types[0].instance_type
  system_disk_type           = "CLOUD_BSSD"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  password                   = var.cvm_password
  instance_charge_type       = "SPOTPAID"
  spot_instance_type         = "ONE-TIME"
  spot_max_price             = "0.1"
  # key_ids                    = [var.ssh_key_id]
  orderly_security_groups    = [tencentcloud_security_group.k3s_all_in_one.id]
}
