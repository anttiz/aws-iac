resource "aws_lambda_function" "lambda_todo" {
  function_name = "todo"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_todo.key

  runtime = "nodejs14.x"
  handler = "todo.handler"

  source_code_hash = data.archive_file.lambda_todo.output_base64sha256
  role             = var.lambda_exec_arn
  layers           = var.util_layer_arn_array
}

resource "aws_cloudwatch_log_group" "lambda_todo" {
  name = "/aws/lambda/${aws_lambda_function.lambda_todo.function_name}"

  retention_in_days = 30
}
