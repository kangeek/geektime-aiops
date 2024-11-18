variable "project_id" {
  type    = string
  default = "1323177"
}

variable "cvm_name" {
  type = string
}

variable "cvm_ssh_key_id" {
  type    = string
  default = "skey-7imncx3r"
}

variable "cvm_ingress_ports_from_me" {
  type    = string
  default = "22,6443"
}

variable "cvm_extra_ingress_rules" {
  type = list(object({
    action             = string
    cidr_block         = optional(string)
    source_security_id = optional(string)
    protocol           = string
    port               = string
    description        = optional(string)
  }))
  default = [
    # {
    #   action      = "ACCEPT"
    #   cidr_block  = "0.0.0.0/0"
    #   protocol    = "ICMP"
    #   port        = "ALL"
    #   description = "Allow ICMP traffic"
    # }
  ]
}
