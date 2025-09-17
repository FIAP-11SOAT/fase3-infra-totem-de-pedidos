provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.projetc_name
      ManagedBy = "devops-team"
      Terraform = "true"
    }
  }
}
