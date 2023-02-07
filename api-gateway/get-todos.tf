# get-todos endpoint
resource "aws_api_gateway_resource" "get_todos_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "get"
}

resource "aws_api_gateway_method" "get_todos_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.get_todos_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_method_response" "get_todos_method_response" {
  for_each    = toset(var.api_status_response)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.get_todos_resource.id
  http_method = aws_api_gateway_method.get_todos_api_method.http_method
  status_code = each.value
}

resource "aws_api_gateway_integration" "get_todos_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.get_todos_resource.id
  http_method             = aws_api_gateway_method.get_todos_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.get_todos_lambda_invoke_arn
}

resource "aws_lambda_permission" "apigw_get_todos_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.get_todos_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.get_todos_api_method.http_method}${aws_api_gateway_resource.get_todos_resource.path}"
}

# cors
# OPTIONS HTTP method.
resource "aws_api_gateway_method" "get_todos_options" {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.get_todos_resource.id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

# OPTIONS method response.
resource "aws_api_gateway_method_response" "get_todos_options" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.get_todos_resource.id
  http_method = aws_api_gateway_method.get_todos_options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# OPTIONS integration.
resource "aws_api_gateway_integration" "get_todos_options" {
  rest_api_id          = aws_api_gateway_rest_api.rest_api.id
  resource_id          = aws_api_gateway_resource.get_todos_resource.id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
}

# OPTIONS integration response.
resource "aws_api_gateway_integration_response" "get_todos_options" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.get_todos_resource.id
  http_method = aws_api_gateway_integration.get_todos_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# deployment
resource "aws_api_gateway_deployment" "api_get_todos_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "DEV"
  depends_on  = [aws_api_gateway_method.get_todos_api_method,
    aws_api_gateway_integration.get_todos_api_integration]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "api_get_todos_options_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "DEV"
  depends_on  = [aws_api_gateway_method.get_todos_options,
    aws_api_gateway_integration.get_todos_options]

  lifecycle {
    create_before_destroy = true
  }
}
