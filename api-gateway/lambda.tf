resource "aws_lambda_function" "lambda_todo" {
  function_name = "todo"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_todo.key

  runtime = "nodejs14.x"
  handler = "todo.handler"

  source_code_hash = data.archive_file.lambda_todo.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  layers           = var.util_layer_arn_array
}

resource "aws_cloudwatch_log_group" "lambda_todo" {
  name = "/aws/lambda/${aws_lambda_function.lambda_todo.function_name}"

  retention_in_days = 30
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

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_todo.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.todo_api_method.http_method}${aws_api_gateway_resource.todo_resource.path}"
}
