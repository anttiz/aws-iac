
resource "aws_lambda_function" "lambda_get_todos" {
  environment {
    variables = {
      TODO_TABLE = var.dynamodb_table_name
    }
  }
  memory_size   = "128"
  timeout       = 10
  runtime       = "nodejs14.x"
  architectures = ["arm64"]
  handler       = "lambdas/get-todos.handler"
  function_name = "get-todos"
  role          = var.lambda_exec_arn
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda_get_todos.key
  source_code_hash = data.archive_file.lambda_get_todos.output_base64sha256
}

resource "aws_cloudwatch_log_group" "lambda_get_todos" {
  name = "/aws/lambda/${aws_lambda_function.lambda_get_todos.function_name}"

  retention_in_days = 30
}

data "archive_file" "lambda_get_todos" {
  type        = "zip"
  source_file = "${path.module}/js/get-todos.js"
  output_path = "${path.module}/js/get-todos.zip"
}

resource "aws_s3_object" "lambda_get_todos" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "get-todos.zip"
  source = data.archive_file.lambda_get_todos.output_path

  etag = filemd5(data.archive_file.lambda_get_todos.output_path)
}
