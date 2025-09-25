resource "aws_eks_cluster" "eks_cluster" {
  name     = "challenge"
  role_arn = local.role_arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
    endpoint_private_access = true 
    endpoint_public_access  = true 
  }

  # Garante que a VPC esteja pronta antes de criar o cluster
  depends_on = [module.vpc]
}

# Recurso EKS Node Group
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