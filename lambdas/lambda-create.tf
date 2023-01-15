
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
  role          = var.lambda_exec_arn
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda_create_todo.key
}

resource "aws_cloudwatch_log_group" "lambda_create_todo" {
  name = "/aws/lambda/${aws_lambda_function.lambda_create_todo.function_name}"

  retention_in_days = 30
}
