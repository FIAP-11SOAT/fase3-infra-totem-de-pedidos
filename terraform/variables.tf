data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "projetc_name" {
  description = "The name of the project"
  type        = string
  default     = "infra-totem-de-pedidos"
}
