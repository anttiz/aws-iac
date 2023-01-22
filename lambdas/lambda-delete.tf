
resource "aws_lambda_function" "lambda_delete_todo" {
  environment {
    variables = {
      TODO_TABLE = var.dynamodb_table_name
    }
  }
  memory_size      = "128"
  timeout          = 10
  runtime          = "nodejs14.x"
  architectures    = ["arm64"]
  handler          = "lambdas/delete-todo.handler"
  function_name    = "delete-todo"
  role             = var.lambda_exec_arn
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_delete_todo.key
  source_code_hash = data.archive_file.lambda_delete_todo.output_base64sha256
}

resource "aws_cloudwatch_log_group" "lambda_delete_todo" {
  name = "/aws/lambda/${aws_lambda_function.lambda_delete_todo.function_name}"

  retention_in_days = 30
}

data "archive_file" "lambda_delete_todo" {
  type        = "zip"
  source_file = "${path.module}/js/delete-todo.js"
  output_path = "${path.module}/js/delete-todo.zip"
}

resource "aws_s3_object" "lambda_delete_todo" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "delete-todo.zip"
  source = data.archive_file.lambda_delete_todo.output_path

  etag = filemd5(data.archive_file.lambda_delete_todo.output_path)
}
