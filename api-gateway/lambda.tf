resource "aws_api_gateway_resource" "todo_resource" {
  count = length(var.lambda_names)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.paths[count.index]
}

resource "aws_api_gateway_method" "todo_api_method" {
  count = length(var.lambda_names)
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.todo_resource[count.index].id
  http_method   = var.methods[count.index]
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_method_response" "todo_method_response" {
  count = length(var.api_status_response)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.todo_resource[var.api_status_response[count.index].index].id
  http_method = aws_api_gateway_method.todo_api_method[var.api_status_response[count.index].index].http_method
  status_code = var.api_status_response[count.index].status_code
}

resource "aws_api_gateway_integration" "todo_api_integration" {
  count = length(var.lambda_names)
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.todo_resource[count.index].id
  http_method             = aws_api_gateway_method.todo_api_method[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn[count.index]
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  count = length(var.lambda_names)
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name[count.index]
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.todo_api_method[count.index].http_method}${aws_api_gateway_resource.todo_resource[count.index].path}"
}

# cors
# OPTIONS HTTP method.
resource "aws_api_gateway_method" "todo_options_api_method" {
  count = length(var.lambda_names)
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.todo_resource[count.index].id
  http_method      = "OPTIONS"
  authorization    = "NONE"
  api_key_required = false
}

# OPTIONS method response.
resource "aws_api_gateway_method_response" "todo_options" {
  count = length(var.lambda_names)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.todo_resource[count.index].id
  http_method = aws_api_gateway_method.todo_options_api_method[count.index].http_method
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
resource "aws_api_gateway_integration" "todo_options" {
  count = length(var.lambda_names)
  rest_api_id          = aws_api_gateway_rest_api.rest_api.id
  resource_id          = aws_api_gateway_resource.todo_resource[count.index].id
  http_method          = "OPTIONS"
  type                 = "MOCK"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
}

# OPTIONS integration response.
resource "aws_api_gateway_integration_response" "todo_options" {
  count = length(var.lambda_names)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.todo_resource[count.index].id
  http_method = aws_api_gateway_integration.todo_options[count.index].http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,DELETE,PUT,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  count = length(var.lambda_names)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "DEV"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "api_options_deployment" {
  count = length(var.lambda_names)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "DEV"

  lifecycle {
    create_before_destroy = true
  }
}
