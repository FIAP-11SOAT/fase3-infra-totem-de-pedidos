resource "aws_lb" "eks_alb" {
  name               = md5("${local.project_name}-eks-internal-alb")
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.private_subnets

  tags = {
    Name = "${local.project_name}-eks-alb"
    "elbv2.k8s.aws/cluster" : aws_eks_cluster.eks_cluster.name
    "ingress.k8s.aws/resource" : "LoadBalancer"
    "ingress.k8s.aws/stack" : "k8s-shared-internal-alb-use1"
  }
}

resource "aws_lb_listener" "eks_alb_listener" {
  load_balancer_arn = aws_lb.eks_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response from ALB"
      status_code  = "404"
    }
  }
}

resource "aws_apigatewayv2_vpc_link" "eks_vpc_link" {
  name               = "eks_vpc_link"
  security_group_ids = [aws_security_group.vpc_link_sg.id]
  subnet_ids         = module.vpc.private_subnets
}

resource "aws_apigatewayv2_integration" "eks_integration" {
  api_id             = aws_apigatewayv2_api.gtw.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = aws_lb_listener.eks_alb_listener.arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.eks_vpc_link.id
}

resource "aws_apigatewayv2_route" "proxy_route" {
  api_id    = aws_apigatewayv2_api.gtw.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks_integration.id}"
}