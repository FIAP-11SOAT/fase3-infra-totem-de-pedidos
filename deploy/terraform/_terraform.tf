terraform {
  required_version = ">= 1.11.0"

  backend "s3" {
    bucket = "fase3-terraform-state"
    key    = "fase3-infra-totem-de-pedidos/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

  }
}
