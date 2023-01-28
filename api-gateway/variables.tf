variable "cognito_user_arn" {}

variable "account_id" {}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-west-1"
}

variable "api_status_response" {
  description = "API http status response"
  type        = list(string)
  default     = ["200", "500"]
}

variable "dynamodb_table_arn" {
  type = string
}

variable "create_todo_lambda_invoke_arn" {
  type = string
}

variable "create_todo_lambda_function_name" {
  type = string
}

variable "delete_todo_lambda_invoke_arn" {
  type = string
}

variable "delete_todo_lambda_function_name" {
  type = string
}

variable "get_todos_lambda_invoke_arn" {
  type = string
}

variable "get_todos_lambda_function_name" {
  type = string
}
