resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${local.projetc_name}-eks-alb-AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = file("eks-alb-controller-iam-policy.json")

  tags = {
    Name = "${local.projetc_name}-eks-alb-AWSLoadBalancerControllerIAMPolicy"
  }
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}