resource "aws_apigatewayv2_api" "http_api" {
  name          = "totem-pedidos-api"
  protocol_type = "HTTP"
}

variable "lambda_arn" {
  description = "ARN da função Lambda que o API Gateway vai integrar"
  type        = string
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "hello_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /lambda/auth"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_vpc_link" "eks_link" {
  name               = "eks-vpc-link"
  security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids         = module.vpc.private_subnets
}

data "aws_lb" "eks_alb" {
  tags = {
    "kubernetes.io/ingress-name" = "totem-pedidos-ingress"
  }
}

resource "aws_apigatewayv2_integration" "eks_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = "http://${data.aws_lb.eks_alb.dns_name}"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.eks_link.id
  integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "eks_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /eks/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

output "api_endpoint" {
  value = aws_apigatewayv2_stage.default.invoke_url
}