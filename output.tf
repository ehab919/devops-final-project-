
provider "aws" {
  region = "us-west-1" 
}


# 2️⃣ جلب بيانات الـ NLB (Data Source)
data "aws_lb" "target_nlb" {
  arn = "arn:aws:elasticloadbalancing:us-west-1:251251171133:loadbalancer/net/abfb73709569344fba22b01e9cfb0f39/04a1b19c36c79984"
}

# 3️⃣ VPC Link
resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "myapp-vpc-link"
  description = "VPC Link to NLB in us-west-1"
  target_arns = [data.aws_lb.target_nlb.arn]
}

# 4️⃣ REST API
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "myapp-api"
  description = "API Gateway for myapp service"
}

# 5️⃣ Resource /myapp
resource "aws_api_gateway_resource" "myapp_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myapp"
}

# 6️⃣ GET Method
resource "aws_api_gateway_method" "get_myapp" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.myapp_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# 7️⃣ Integration
resource "aws_api_gateway_integration" "get_myapp_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.myapp_resource.id
  http_method             = aws_api_gateway_method.get_myapp.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.vpc_link.id
  uri                     = "http://${data.aws_lb.target_nlb.dns_name}/"

  depends_on = [
    aws_api_gateway_method.get_myapp,
    aws_api_gateway_vpc_link.vpc_link
  ]
}

# 8️⃣ Deployment & Stage
resource "aws_api_gateway_deployment" "myapp_deploy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  depends_on  = [aws_api_gateway_integration.get_myapp_integration]
}

resource "aws_api_gateway_stage" "dev_stage" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  deployment_id = aws_api_gateway_deployment.myapp_deploy.id
  stage_name    = "dev"
}

# 9️⃣ Outputs
output "api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.my_api.id}.execute-api.us-west-1.amazonaws.com/dev/myapp"
}