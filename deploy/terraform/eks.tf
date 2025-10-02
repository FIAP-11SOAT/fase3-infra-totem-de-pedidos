data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.eks_cluster.name
}

data "tls_certificate" "cluster_oidc" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster_oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "${local.projetc_name}-eks-cluster"
  role_arn = local.role_arn

  vpc_config {
    subnet_ids              = module.vpc.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [module.vpc]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "app-nodes"
  node_role_arn   = local.role_arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [aws_eks_cluster.eks_cluster]
}


output "eks_cluster_status" {
  description = "Status do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.status
}

output "eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.eks_cluster.endpoint
}