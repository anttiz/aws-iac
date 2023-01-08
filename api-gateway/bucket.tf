resource "random_pet" "lambda_bucket_name" {
  prefix = "todo"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_todo" {
  type = "zip"

  source_dir  = "${path.module}/todo"
  output_path = "${path.module}/todo.zip"
}

resource "aws_s3_object" "lambda_todo" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "todo.zip"
  source = data.archive_file.lambda_todo.output_path

  etag = filemd5(data.archive_file.lambda_todo.output_path)
}
