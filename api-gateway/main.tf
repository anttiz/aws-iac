resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "todo-api"
  description = "TODO API Gateway"
}

# authorizer
resource "aws_api_gateway_authorizer" "api_authorizer" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  provider_arns = [var.cognito_user_arn]
}

# TODO end-point
resource "aws_api_gateway_resource" "todo_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "todo"
}

resource "aws_api_gateway_method" "todo_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.todo_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_method_response" "check_in_method_response" {
  for_each    = toset(var.api_status_response)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.todo_resource.id
  http_method = aws_api_gateway_method.todo_api_method.http_method
  status_code = each.value
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "DEV"
  depends_on  = [aws_api_gateway_method.todo_api_method]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_integration" "todo_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.todo_resource.id
  http_method             = aws_api_gateway_method.todo_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_todo.invoke_arn
}
