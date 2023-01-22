resource "random_pet" "lambda_bucket_name" {
  prefix = "todo"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_create_todo" {
  type        = "zip"
  source_file = "${path.module}/js/create-todo.js"
  output_path = "${path.module}/js/create-todo.zip"
}

resource "aws_s3_object" "lambda_create_todo" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "create-todo.zip"
  source = data.archive_file.lambda_create_todo.output_path

  etag = filemd5(data.archive_file.lambda_create_todo.output_path)
}
