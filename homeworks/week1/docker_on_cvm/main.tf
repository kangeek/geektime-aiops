################################
# backend
################################

terraform {
  backend "cos" {
    region  = "ap-hongkong"
    bucket  = "tfstate-geektime-aiops-1258064038"
    prefix  = "homeworks/week1/docker_on_cvm"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

################################
# 1. CVM with docker
################################

# Create CVM
module "cvm_docker" {
  source                  = "../modules/cvm"
  cvm_name                = "docker"
}

# Install docker on CVM
resource "null_resource" "install_docker" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.cvm_docker.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }

    inline = [
      "sudo apt update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade",
      "sudo DEBIAN_FRONTEND=noninteractive apt install docker.io -y",
      "sudo systemctl enable --now docker",
      "sudo usermod -aG docker ubuntu",
    ]
  }
}
