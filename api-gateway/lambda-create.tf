
resource "aws_lambda_function" "lambda_create_todo" {
  environment {
    variables = {
      TODO_TABLE = var.dynamodb_table_name
    }
  }
  memory_size   = "128"
  timeout       = 10
  runtime       = "nodejs14.x"
  architectures = ["arm64"]
  handler       = "lambdas/create-todo.handler"
  function_name = "create-todo"
  role          = aws_iam_role.lambda_exec.arn
  # filename      = "lambdas/create-todo.zip"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_create_todo.key
}

resource "aws_cloudwatch_log_group" "lambda_create_todo" {
  name = "/aws/lambda/${aws_lambda_function.lambda_create_todo.function_name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "apigw_create_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_create_todo.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.create_todo_api_method.http_method}${aws_api_gateway_resource.create_todo_resource.path}"
}
