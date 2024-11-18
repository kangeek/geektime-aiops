terraform {
  backend "cos" {
    region  = "ap-hongkong"
    bucket  = "tfstate-geektime-aiops-1258064038"
    prefix  = "lessons/module2/demo4"
    key     = "terraform.tfstate"
    encrypt = true
  }
}
