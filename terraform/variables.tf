data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  aws_region = "us-east-1"
  projetc_name = "fase3-infra-totem-de-pedidos"
}

locals {
    role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
}
