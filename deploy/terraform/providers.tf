provider "aws" {
  region = local.aws_region

  default_tags {
    tags = {
      Project   = local.projetc_name
      ManagedBy = "devops-team"
      Terraform = "true"
    }
  }
}

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}
