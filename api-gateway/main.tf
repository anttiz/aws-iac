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

# create-todo endpoint
resource "aws_api_gateway_resource" "create_todo_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "create"
}

resource "aws_api_gateway_method" "create_todo_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.create_todo_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_method_response" "create_todo_method_response" {
  for_each    = toset(var.api_status_response)
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.create_todo_resource.id
  http_method = aws_api_gateway_method.create_todo_api_method.http_method
  status_code = each.value
}

resource "aws_api_gateway_integration" "create_todo_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.create_todo_resource.id
  http_method             = aws_api_gateway_method.create_todo_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.create_todo_lambda_invoke_arn
}

// All methods here
resource "aws_api_gateway_deployment" "api_create_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "DEV"
  depends_on  = [aws_api_gateway_method.create_todo_api_method]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name = "dynamodb_lambda_policy"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:*"],
        "Resource" : "${var.dynamodb_table_arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_lambda_permission" "apigw_create_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.create_todo_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.create_todo_api_method.http_method}${aws_api_gateway_resource.create_todo_resource.path}"
}
