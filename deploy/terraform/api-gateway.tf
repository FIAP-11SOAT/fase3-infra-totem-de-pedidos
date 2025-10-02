# resource "aws_apigatewayv2_api" "gtw" {
#   name          = "my-http-api"
#   protocol_type = "HTTP"
#   cors_configuration {
#     allow_headers = ["*"]
#     allow_methods = ["*"]
#     allow_origins = ["*"]
#   }
# }
#
# resource "aws_apigatewayv2_stage" "default" {
#   api_id      = aws_apigatewayv2_api.gtw.id
#   name        = "$default"
#   auto_deploy = true
# }

# output "api_endpoint" {
#   value = aws_apigatewayv2_stage.default.invoke_url
# }
