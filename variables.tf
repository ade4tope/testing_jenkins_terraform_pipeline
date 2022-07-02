variable "owner_email" {
  type    = string
  default = "infradev@tead.com"
}


variable "vpc_cidr" {
  default = "100.0.0.0/16"
}

variable "environment" {
  default = "dev"
}

locals {
  tags = {

    Enviroment      = "dev"
    Owner-Email     = "tope@tope.io"
    Managed-By      = "Terraform"
    Billing-Account = "1234567890"
  }
  environment = "dev"

}