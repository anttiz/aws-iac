resource "aws_s3_object" "lambda" {
  count = length(var.lambda_names)
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "${var.lambda_names[count.index]}.zip"
  source = data.archive_file.lambda[count.index].output_path
  etag = filemd5(data.archive_file.lambda[count.index].output_path)
}

resource "aws_lambda_function" "lambda" {
  count = length(var.lambda_names)
  environment {
    variables = {
      TODO_TABLE = var.dynamodb_table_name
    }
  }
  memory_size   = "128"
  timeout       = 10
  runtime       = "nodejs14.x"
  architectures = ["arm64"]
  handler       = "lambdas/${var.lambda_names[count.index]}.handler"
  function_name = "${var.lambda_names[count.index]}"
  role          = var.lambda_exec_arn
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda[count.index].key
  source_code_hash = data.archive_file.lambda[count.index].output_base64sha256
}

resource "aws_cloudwatch_log_group" "lambda" {
  count = length(var.lambda_names)
  name = "/aws/lambda/${aws_lambda_function.lambda[count.index].function_name}"
  retention_in_days = 30
}

data "archive_file" "lambda" {
  count = length(var.lambda_names)
  type        = "zip"
  source_file = "${path.module}/js/${var.lambda_names[count.index]}.js"
  output_path = "${path.module}/js/${var.lambda_names[count.index]}.zip"
}
